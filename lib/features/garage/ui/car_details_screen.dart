import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import '../../../core/di/injection.dart';
import '../models/car_model.dart';
import 'car_form_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/cubit/car_form_cubit.dart';
import '../utils/car_pdf_generator.dart';

class CarDetailsScreen extends StatelessWidget {
  final CarModel car;

  const CarDetailsScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final supabase = getIt<SupabaseClient>();
    final isPolish = Localizations.localeOf(context).languageCode == 'pl';
    
    final currencyFormat = NumberFormat.simpleCurrency(
      locale: isPolish ? 'pl_PL' : 'en_US',
      name: isPolish ? 'PLN' : 'USD',
    );

    return BlocProvider(
      create: (context) => getIt<CarFormCubit>(),
      child: BlocListener<CarFormCubit, CarFormState>(
        listener: (context, state) {
          state.whenOrNull(
            success: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Model został usunięty z garażu'),
                  backgroundColor: Colors.black87,
                ),
              );
            },
            error: (key, _) {
               ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(key),
                  backgroundColor: Colors.red.shade800,
                ),
              );
            },
          );
        },
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              _DeleteButton(carId: car.id),
            ],
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0C0C0C), // Deep black
                  Color(0xFF2D1B0D), // Warm garage dark brown
                  Color(0xFF0C0C0C), // Deep black at bottom
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PhotoGallery(car: car, supabase: supabase),
                    const SizedBox(height: 32),
                    Text(
                      car.toyMaker?.toUpperCase() ?? 'PRODUCENT NIEZNANY',
                      style: const TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      car.brand,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w200,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      car.modelName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    _DetailGrid(car: car, currencyFormat: currencyFormat),
                    
                    const SizedBox(height: 48),
                    
                    _ActionButtons(car: car, supabase: supabase),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotoGallery extends StatefulWidget {
  final CarModel car;
  final SupabaseClient supabase;

  const _PhotoGallery({required this.car, required this.supabase});

  @override
  State<_PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<_PhotoGallery> {
  int _currentIndex = 0;
  String? _docsPath;

  @override
  void initState() {
    super.initState();
    _initPath();
  }

  Future<void> _initPath() async {
    final docs = await getApplicationDocumentsDirectory();
    if (mounted) {
      setState(() => _docsPath = docs.path);
    }
  }

  ImageProvider _getImageProvider(String path) {
    if (path.startsWith('http')) return NetworkImage(path);
    if (path.contains('/')) {
      final url = widget.supabase.storage.from('autoworld_photos').getPublicUrl(path);
      return NetworkImage(url);
    }
    if (_docsPath == null) return const AssetImage('assets/images/placeholder.png') as ImageProvider;
    return FileImage(File(p.join(_docsPath!, 'autoworld_photos', path)));
  }

  @override
  Widget build(BuildContext context) {
    final photoPaths = widget.car.allPhotoPaths;
    
    if (photoPaths.isEmpty) {
      return const _HeroContainer(child: _Placeholder());
    }

    return Stack(
      children: [
        _HeroContainer(
          child: PhotoViewGallery.builder(
            itemCount: photoPaths.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: _getImageProvider(photoPaths[index]),
                initialScale: PhotoViewComputedScale.covered,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            onPageChanged: (index) => setState(() => _currentIndex = index),
            backgroundDecoration: const BoxDecoration(color: Colors.transparent),
            scrollPhysics: const BouncingScrollPhysics(),
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFD700)),
            ),
          ),
        ),
        if (photoPaths.length > 1)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: photoPaths.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == entry.key
                        ? const Color(0xFFFFD700)
                        : Colors.white.withValues(alpha: 0.3),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _HeroContainer extends StatelessWidget {
  final Widget child;
  const _HeroContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: child,
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.05),
      child: const Center(
        child: Icon(Icons.directions_car_outlined, size: 80, color: Colors.white12),
      ),
    );
  }
}

class _DetailGrid extends StatelessWidget {
  final CarModel car;
  final NumberFormat currencyFormat;

  const _DetailGrid({required this.car, required this.currencyFormat});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _DetailItem(label: 'SERIA', value: car.series ?? '-'),
        _DetailItem(label: 'DATA ZAKUPU', value: car.purchaseDate != null ? DateFormat('dd.MM.yyyy').format(car.purchaseDate!) : '-'),
        _DetailItem(label: 'CENA ZAKUPU', value: currencyFormat.format(car.purchasePrice)),
        _DetailItem(label: 'SZAC. WARTOŚĆ', value: currencyFormat.format(car.estimatedValue), highlight: true),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _DetailItem({required this.label, required this.value, this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: highlight ? const Color(0xFFFFD700) : Colors.white70,
            fontSize: 16,
            fontWeight: highlight ? FontWeight.bold : FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final CarModel car;
  final SupabaseClient supabase;
  const _ActionButtons({required this.car, required this.supabase});

  @override
  Widget build(BuildContext context) {
    final isPolish = Localizations.localeOf(context).languageCode == 'pl';

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CarFormScreen(car: car)),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text(
                'REDAGUJ DANE',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 13),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD700).withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: OutlinedButton(
            onPressed: () => CarPdfGenerator.generateAndShare(
              car,
              isPolish: isPolish,
              supabase: supabase,
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: const Color(0xFFFFD700).withValues(alpha: 0.4)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.zero,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.picture_as_pdf, color: Color(0xFFFFD700), size: 20),
                Text(
                  'PDF',
                  style: TextStyle(color: Color(0xFFFFD700), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final String carId;
  const _DeleteButton({required this.carId});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
      onPressed: () => _confirmDelete(context),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (diagContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1A120B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: Colors.white12)),
          title: const Text('Usuń model', style: TextStyle(color: Colors.white)),
          content: const Text('Czy na pewno chcesz usunąć ten model z garażu?', style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(diagContext),
              child: const Text('ANULUJ', style: TextStyle(color: Colors.white38)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(diagContext);
                context.read<CarFormCubit>().deleteCar(carId);
              },
              child: const Text('USUŃ', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
