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
import '../utils/garage_card_png_generator.dart';
import '../../../l10n/l10n.dart';
import '../../market/presentation/cubit/market_cubit.dart';
import '../../market/ui/widgets/garage_move_success_dialog.dart';
import '../../../shared/sound_helper.dart';
import '../../settings/models/settings_model.dart';
import '../../settings/presentation/settings_cubit.dart';

class CarDetailsScreen extends StatelessWidget {
  final CarModel car;

  const CarDetailsScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final supabase = getIt<SupabaseClient>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<CarFormCubit>()),
        BlocProvider(create: (context) => getIt<MarketCubit>()),
        BlocProvider.value(value: getIt<SettingsCubit>()),
      ],
      child: BlocListener<MarketCubit, MarketState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (key) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(key),
                  backgroundColor: Colors.red.shade800,
                ),
              );
            },
          );
        },
        child: BlocListener<CarFormCubit, CarFormState>(
          listener: (context, state) {
            final l10n = context.l10n;
            state.whenOrNull(
              success: () {
                SoundHelper.playDeleteChime();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.carDeletedSuccessfully),
                    backgroundColor: Colors.black87,
                  ),
                );
              },
              error: (key, producers, series) {
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
                _DeleteButton(car: car),
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
                    Color(0xFF0C0C0C),
                    Color(0xFF2D1B0D),
                    Color(0xFF0C0C0C),
                  ],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // ── Scrollable content ───────────────────────────────────
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _PhotoGallery(car: car, supabase: supabase),
                            const SizedBox(height: 16),
                            Text(
                              car.toyMaker?.toUpperCase() ?? 'PRODUCENT NIEZNANY',
                              style: const TextStyle(
                                color: Color(0xFFFFD700),
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 4),
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
                            const SizedBox(height: 16),
                            _DetailGrid(car: car),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),

                    // ── Action buttons — always visible at bottom ────────────
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        border: Border(
                          top: BorderSide(color: Colors.white.withValues(alpha: 0.07)),
                        ),
                      ),
                      child: _ActionButtons(car: car, supabase: supabase),
                    ),
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

  const _DetailGrid({required this.car});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // Waluta z ustawień użytkownika
    final settingsState = context.watch<SettingsCubit>().state;
    final currency = settingsState is Data
        ? settingsState.settings.currency
        : AppCurrency.pln;
    final (currencyLocale, currencyName) = switch (currency) {
      AppCurrency.pln => ('pl_PL', 'PLN'),
      AppCurrency.usd => ('en_US', 'USD'),
      AppCurrency.eur => ('de_DE', 'EUR'),
    };
    final currencyFormat = NumberFormat.simpleCurrency(
      locale: currencyLocale,
      name: currencyName,
    );

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.8,
      crossAxisSpacing: 12,
      mainAxisSpacing: 8,
      children: [
        _DetailItem(
          label: l10n.carDetailsCondition, 
          value: _getLocalizedStatus(context, car.status).toUpperCase(),
        ),
        _DetailItem(label: l10n.carDetailsSeries, value: car.series ?? '-'),
        _DetailItem(label: l10n.carDetailsDate, value: car.purchaseDate != null ? DateFormat('dd.MM.yyyy').format(car.purchaseDate!) : '-'),
        _DetailItem(label: l10n.carDetailsPurchasePrice, value: currencyFormat.format(car.purchasePrice), highlight: true),
      ],
    );
  }

  String _getLocalizedStatus(BuildContext context, String status) {
    final l10n = context.l10n;
    return switch (status) {
      'Nowy' => l10n.carConditionNew,
      'Idealny' => l10n.carConditionMint,
      'Dobry' => l10n.carConditionGood,
      'Lekko uszkodzony' => l10n.carConditionFair,
      'Uszkodzony' => l10n.carConditionPoor,
      'Luzak (bez opakowania)' => l10n.carConditionLoose,
      'Inne' => l10n.carConditionOther,
      _ => status,
    };
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
    final l10n = context.l10n;
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
              child: Text(
                l10n.carDetailsEditData.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 13),
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
                color: Colors.greenAccent.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: OutlinedButton(
            onPressed: () => _confirmSell(context),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.greenAccent.withValues(alpha: 0.4)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.zero,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.sell_outlined, color: Colors.greenAccent, size: 20),
                Text(
                  l10n.sellButtonLabel,
                  style: const TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1),
                ),
              ],
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
            onPressed: () => GarageCardPngGenerator.generateAndShare(
              context,
              car,
              garageName: null, // We could fetch this if we had the cubit here, but for now simple
              isPolish: isPolish,
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: const Color(0xFFFFD700).withValues(alpha: 0.4)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.zero,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_outlined, color: Color(0xFFFFD700), size: 18),
                    SizedBox(width: 4),
                    Icon(Icons.ios_share, color: Color(0xFFFFD700), size: 15),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _confirmSell(BuildContext context) {
    final l10n = context.l10n;
    
    showDialog(
      context: context,
      builder: (diagContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1A120B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: Colors.white12)),
          title: Text(
            l10n.marketMoveConfirmTitle,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            l10n.marketMoveConfirmBody,
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(diagContext),
              child: Text(l10n.cancelButtonLabel.toUpperCase(), style: const TextStyle(color: Colors.white38)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(diagContext);
                try {
                  await context.read<MarketCubit>().moveFromGarage(car);
                  if (context.mounted) {
                    await GarageMoveSuccessDialog.show(context, car);
                    if (context.mounted) {
                      Navigator.pop(context); // Go back to Garage
                    }
                  }
                } catch (e) {
                  // Error handled by BlocListener
                }
              },
              child: Text(
                l10n.marketMoveButton.toUpperCase(), 
                style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final CarModel car;
  const _DeleteButton({required this.car});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
      onPressed: () => _confirmDelete(context),
    );
  }

  void _confirmDelete(BuildContext context) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (diagContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1A120B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: Colors.white12)),
          title: Text(l10n.carDetailsDeleteConfirmTitle, style: const TextStyle(color: Colors.white)),
          content: Text(l10n.carDetailsDeleteConfirmBody, style: const TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(diagContext),
              child: Text(l10n.closeButtonLabel.toUpperCase(), style: const TextStyle(color: Colors.white38)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(diagContext);
                context.read<CarFormCubit>().deleteCar(car);
              },
              child: Text(l10n.deleteAccountConfirmButtonLabel.toUpperCase(), style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
