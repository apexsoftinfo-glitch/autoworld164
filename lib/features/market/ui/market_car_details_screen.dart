import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/l10n.dart';
import '../../garage/ui/widgets/car_photo.dart';
import '../models/market_car_model.dart';
import '../presentation/cubit/market_form_cubit.dart';
import '../data/repositories/market_repository.dart';
import 'market_car_form_screen.dart';
import 'widgets/market_sold_success_dialog.dart';
import '../../../../shared/sound_helper.dart';

class MarketCarDetailsScreen extends StatefulWidget {
  final MarketCarModel car;

  const MarketCarDetailsScreen({super.key, required this.car});

  @override
  State<MarketCarDetailsScreen> createState() => _MarketCarDetailsScreenState();
}

class _MarketCarDetailsScreenState extends State<MarketCarDetailsScreen> {
  final GlobalKey _boundaryKey = GlobalKey();
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final isPolish = Localizations.localeOf(context).languageCode == 'pl';
    final currencyFormat = NumberFormat.simpleCurrency(
      locale: isPolish ? 'pl_PL' : 'en_US',
      name: isPolish ? 'PLN' : 'USD',
      decimalDigits: 0,
    );
    final l10n = context.l10n;

    return BlocProvider(
      create: (context) => getIt<MarketFormCubit>(),
      child: StreamBuilder<List<MarketCarModel>>(
        stream: getIt<MarketRepository>().marketCarsStream,
        builder: (context, snapshot) {
          final currentCar = snapshot.data?.firstWhere(
            (c) => c.id == widget.car.id,
            orElse: () => widget.car,
          ) ?? widget.car;

          return BlocListener<MarketFormCubit, MarketFormState>(
            listener: (context, state) {
              state.whenOrNull(
                success: () {
                  SoundHelper.playDeleteChime();
                  Navigator.pop(context);
                },
                error: (key, p, s) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(key), backgroundColor: Colors.redAccent),
                  );
                },
              );
            },
            child: Builder(
              builder: (context) => Scaffold(
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.white70),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MarketCarFormScreen(car: currentCar)),
                      ),
                    ),
                  ],
                ),
                body: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF0C0C0C),
                            Color(0xFF1A120B),
                            Color(0xFF0C0C0C),
                          ],
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _PhotoGallery(car: currentCar),
                                    const SizedBox(height: 24),
                                    // Basic Info
                                    Text(
                                      (currentCar.toyMaker ?? l10n.carProducerPlaceholder).toUpperCase(),
                                      style: const TextStyle(color: Color(0xFFFFD700), fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${currentCar.brand} ${currentCar.modelName}',
                                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        _InfoChip(label: currentCar.status.toUpperCase(), color: Colors.white10),
                                        if (currentCar.series != null) ...[
                                          const SizedBox(width: 8),
                                          _InfoChip(label: currentCar.series!.toUpperCase(), color: const Color(0xFFFFD700).withValues(alpha: 0.1)),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 32),
                                    // Price and Tags
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(currentCar.isAuction ? l10n.marketAuction.toUpperCase() : l10n.marketPrice.toUpperCase(), style: const TextStyle(color: Colors.white30, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                              if (currentCar.isAuction)
                                                const Padding(
                                                  padding: EdgeInsets.only(top: 4),
                                                  child: Icon(Icons.gavel, color: Color(0xFFFFD700), size: 32),
                                                )
                                              else
                                                Text(
                                                  currencyFormat.format(currentCar.price),
                                                  style: const TextStyle(color: Color(0xFFFFD700), fontSize: 24, fontWeight: FontWeight.w900),
                                                ),
                                            ],
                                          ),
                                        Row(
                                          children: [
                                            if (currentCar.isExchange) _TypeBadge(label: l10n.marketExchangeBadge.toUpperCase(), color: Colors.blueAccent),
                                            if (currentCar.isSale) ...[
                                              const SizedBox(width: 8),
                                              _TypeBadge(label: l10n.marketSaleBadge.toUpperCase(), color: Colors.greenAccent),
                                            ],
                                          ],
                                        ),
                                      ],
                                    ),
                                    if (currentCar.notes != null && currentCar.notes!.isNotEmpty) ...[
                                      const SizedBox(height: 32),
                                      Text(l10n.marketNotes.toUpperCase(), style: const TextStyle(color: Colors.white30, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                      const SizedBox(height: 8),
                                      Text(
                                        currentCar.notes!,
                                        style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                        // Bottom Buttons
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _ActionButton(
                                label: l10n.marketEditListing,
                                icon: Icons.edit_outlined,
                                color: Colors.white70,
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => MarketCarFormScreen(car: currentCar)),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _ActionButton(
                                label: l10n.marketExchangedSold,
                                icon: Icons.check_circle_outline,
                                color: Colors.greenAccent,
                                onPressed: () async {
                                  final cubit = context.read<MarketFormCubit>();
                                  final confirmed = await MarketSoldSuccessDialog.show(context);
                                  if (confirmed == true && mounted) {
                                    cubit.deleteCar(widget.car.id);
                                  }
                                },
                              ),
                              const SizedBox(height: 12),
                              _ActionButton(
                                label: l10n.marketGenerateListing,
                                icon: Icons.share_outlined,
                                color: const Color(0xFFFFD700),
                                isLoading: _isGenerating,
                                onPressed: _generateAndShareListing,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: -2000,
                  child: RepaintBoundary(
                    key: _boundaryKey,
                    child: _ListingPreview(car: currentCar, currencyFormat: currencyFormat),
                  ),
                ),
              ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _generateAndShareListing() async {
    setState(() => _isGenerating = true);
    try {
      // Small delay to ensure rendering
      await Future.delayed(const Duration(milliseconds: 300));
      
      final boundary = _boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = byteData!.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = File(p.join(tempDir.path, 'listing_${widget.car.id}.png'));
      await file.writeAsBytes(bytes);

      // ignore: deprecated_member_use
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: '${widget.car.brand} ${widget.car.modelName}',
        text: 'AutoWorld 1/64 - ${widget.car.brand} ${widget.car.modelName} for ${widget.car.isSale ? "sale" : "exchange"}!',
      );
    } catch (e) {
      debugPrint('Error generating listing: $e');
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }
}

class _PhotoGallery extends StatelessWidget {
  final MarketCarModel car;
  const _PhotoGallery({required this.car});

  @override
  Widget build(BuildContext context) {
    final paths = car.photoPaths;
    if (paths.isEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white10),
        ),
        child: const Center(child: Icon(Icons.directions_car, color: Colors.white10, size: 64)),
      );
    }

    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: paths.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => _FullScreenGallery(paths: paths, initialIndex: index),
                ),
              );
            },
            child: Hero(
              tag: 'photo_$index',
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CarPhoto(path: paths[index], fit: BoxFit.cover, folderName: 'autoworld_photos'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FullScreenGallery extends StatelessWidget {
  final List<String> paths;
  final int initialIndex;

  const _FullScreenGallery({required this.paths, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: const CloseButton(color: Colors.white)),
      body: PhotoViewGallery.builder(
        itemCount: paths.length,
        pageController: PageController(initialPage: initialIndex),
        builder: (context, index) {
          return PhotoViewGalleryPageOptions.customChild(
            child: CarPhoto(path: paths[index], fit: BoxFit.contain, folderName: 'autoworld_photos'),
            heroAttributes: PhotoViewHeroAttributes(tag: 'photo_$index'),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
          );
        },
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  const _InfoChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _TypeBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900)),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final bool isLoading;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Icon(icon, color: color),
        label: Text(label.toUpperCase(), style: TextStyle(color: color, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withValues(alpha: 0.5)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: color.withValues(alpha: 0.05),
        ),
      ),
    );
  }
}

class _ListingPreview extends StatelessWidget {
  final MarketCarModel car;
  final NumberFormat currencyFormat;

  const _ListingPreview({required this.car, required this.currencyFormat});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: 1080,
      height: 1350,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA), // Light neutral background
      ),
      child: Stack(
        children: [
          // Subtle background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: Image.asset(
                'assets/images/garage_bg.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(),
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Info Section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (car.toyMaker ?? l10n.carProducerPlaceholder).toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF6C757D),
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${car.brand} ${car.modelName}',
                            style: const TextStyle(
                              color: Color(0xFF212529),
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                          if (car.notes != null && car.notes!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              car.notes!,
                              style: const TextStyle(
                                color: Color(0xFF6C757D),
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.directions_car, color: Color(0xFFDAA520), size: 48),
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.marketCondition.toUpperCase(), style: const TextStyle(color: Color(0xFF6C757D), fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        Text(
                          car.status.toUpperCase(),
                          style: const TextStyle(color: Color(0xFF212529), fontSize: 32, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (car.isAuction)
                          const Icon(Icons.gavel, color: Color(0xFFDAA520), size: 100)
                        else
                          Text(
                            currencyFormat.format(car.price),
                            style: const TextStyle(color: Color(0xFFDAA520), fontSize: 80, fontWeight: FontWeight.w900),
                          ),
                        Text(
                          car.isAuction 
                              ? l10n.marketAuctionStatus.toUpperCase() 
                              : (car.isSale && car.isExchange 
                                  ? l10n.marketForSaleExchange.toUpperCase()
                                  : (car.isSale ? l10n.marketForSale.toUpperCase() : l10n.marketForExchange.toUpperCase())),
                          style: const TextStyle(color: Color(0xFF6C757D), fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 60),
                const Divider(color: Color(0xFFDEE2E6), thickness: 2),
                const SizedBox(height: 40),

                // Photos Section
                Expanded(
                  child: _buildPhotoLayout(),
                ),
                
                const SizedBox(height: 40),
                Center(
                  child: Text(
                    l10n.marketGeneratedBy.toUpperCase(),
                    style: const TextStyle(color: Color(0xFFADB5BD), fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoLayout() {
    final photos = car.photoPaths;
    if (photos.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE9ECEF),
          borderRadius: BorderRadius.circular(32),
        ),
        child: const Center(child: Icon(Icons.directions_car, color: Colors.white, size: 200)),
      );
    }

    if (photos.length == 1) {
      return _buildPhotoItem(photos.first, isLarge: true);
    }

    // Grid layout for multiple photos
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 30,
        mainAxisSpacing: 30,
        childAspectRatio: 4 / 3,
      ),
      itemCount: photos.length > 4 ? 4 : photos.length, // Limit to 4 for clean look or more if needed
      itemBuilder: (context, index) => _buildPhotoItem(photos[index]),
    );
  }

  Widget _buildPhotoItem(String path, {bool isLarge = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isLarge ? 40 : 24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isLarge ? 40 : 24),
        child: CarPhoto(
          path: path,
          fit: BoxFit.cover,
          folderName: 'autoworld_photos',
        ),
      ),
    );
  }
}
