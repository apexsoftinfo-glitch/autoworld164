import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/di/injection.dart';
import '../../../l10n/l10n.dart';
import '../models/car_model.dart';
import '../presentation/cubit/cars_collection_cubit.dart';

import 'car_form_screen.dart';
import 'car_details_screen.dart';

class GarageScreen extends StatelessWidget {
  const GarageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CarsCollectionCubit>(),
      child: const _GarageScreenView(),
    );
  }
}

class _GarageScreenView extends StatelessWidget {
  const _GarageScreenView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          l10n.garageTitle.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w200,
            letterSpacing: 4,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/warm_garage.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              const Color(0xFF2D1B0D).withValues(alpha: 0.5),
              BlendMode.darken,
            ),
          ),
        ),
        child: BlocBuilder<CarsCollectionCubit, CarsCollectionState>(
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFFFFD700)),
              ),
              error: (key) => Center(
                child: Text(
                  key,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              data: (cars, filtered, purchaseTotal, estimatedTotal, stats, query, viewType) {
                if (cars.isEmpty) {
                  return const _EmptyGarageView();
                }

                return Column(
                  children: [
                    _GarageSummaryHeader(
                      pieces: filtered.length,
                      totalValue: estimatedTotal,
                    ),
                    const SizedBox(height: 16),
                    _SearchAndToggleBar(
                      query: query,
                      viewType: viewType,
                      onSearch: (v) => context.read<CarsCollectionCubit>().search(v),
                      onToggle: () => context.read<CarsCollectionCubit>().toggleView(),
                    ),
                    Expanded(
                      child: viewType == CollectionViewType.grid 
                        ? GridView.builder(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              return _CarCard(car: filtered[index]);
                            },
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                            itemCount: filtered.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              return _CarListTile(car: filtered[index]);
                            },
                          ),
                    ),
                  ],
                );
              },
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}

class _GarageSummaryHeader extends StatelessWidget {
  final int pieces;
  final double totalValue;

  const _GarageSummaryHeader({
    required this.pieces,
    required this.totalValue,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final valueStr = totalValue >= 1000 
      ? '${(totalValue / 1000).toStringAsFixed(1)}K' 
      : totalValue.toStringAsFixed(0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 10, 16, 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Stat(
            label: l10n.garageTotalItems.toUpperCase(),
            value: pieces.toString(),
          ),
          _Stat(
            label: l10n.garageTotalValue.toUpperCase(),
            value: '\$$valueStr',
            valueColor: const Color(0xFFFFD700),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _Stat({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 8,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _CarCard extends StatelessWidget {
  final CarModel car;

  const _CarCard({required this.car});

  @override
  Widget build(BuildContext context) {
    final supabase = getIt<SupabaseClient>();
    final photoUrl = car.photoPath != null 
      ? supabase.storage.from('autoworld_photos').getPublicUrl(car.photoPath!)
      : null;

    return _GlassBox(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: photoUrl != null
                      ? Image.network(
                          photoUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _ImagePlaceholder(),
                        )
                      : _ImagePlaceholder(),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            car.brand.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFFFFD700),
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            car.modelName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          if (car.series != null)
                             Text(
                              car.series!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${car.estimatedValue.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Icon(Icons.chevron_right, size: 16, color: Colors.white24),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CarDetailsScreen(car: car)),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.05),
      child: const Center(
        child: Icon(Icons.directions_car_outlined, color: Colors.white12, size: 40),
      ),
    );
  }
}

class _EmptyGarageView extends StatelessWidget {
  const _EmptyGarageView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.garage_outlined, size: 80, color: Colors.white12),
            const SizedBox(height: 24),
            Text(
              l10n.garageEmptyStateTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.garageEmptyStateSubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),
            _GlassBox(
              padding: const EdgeInsets.all(0),
              borderColor: const Color(0xFFFFD700).withValues(alpha: 0.3),
              child: FilledButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CarFormScreen()),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                icon: const Icon(Icons.add),
                label: Text(
                  l10n.garageAddFirstCarButton.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchAndToggleBar extends StatelessWidget {
  final String query;
  final CollectionViewType viewType;
  final ValueChanged<String> onSearch;
  final VoidCallback onToggle;

  const _SearchAndToggleBar({
    required this.query,
    required this.viewType,
    required this.onSearch,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _GlassBox(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                onChanged: onSearch,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Szukaj modelu...',
                  hintStyle: TextStyle(color: Colors.white24, fontSize: 12),
                  border: InputBorder.none,
                  icon: Icon(Icons.search, size: 18, color: Colors.white38),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _GlassBox(
            padding: EdgeInsets.zero,
            child: IconButton(
              icon: Icon(
                viewType == CollectionViewType.grid ? Icons.view_headline : Icons.grid_view,
                color: Colors.white70,
                size: 18,
              ),
              onPressed: onToggle,
            ),
          ),
        ],
      ),
    );
  }
}

class _CarListTile extends StatelessWidget {
  final CarModel car;
  const _CarListTile({required this.car});

  @override
  Widget build(BuildContext context) {
    final supabase = getIt<SupabaseClient>();
    final photoUrl = car.photoPath != null 
      ? supabase.storage.from('autoworld_photos').getPublicUrl(car.photoPath!)
      : null;

    return _GlassBox(
      padding: const EdgeInsets.all(12),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CarDetailsScreen(car: car)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 60,
                height: 60,
                child: photoUrl != null
                  ? Image.network(photoUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => _ImagePlaceholder())
                  : _ImagePlaceholder(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.brand.toUpperCase(),
                    style: const TextStyle(color: Color(0xFFFFD700), fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                  Text(
                    car.modelName,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),
                  ),
                  if (car.series != null)
                    Text(
                      car.series!,
                      style: const TextStyle(color: Colors.white38, fontSize: 10),
                    ),
                ],
              ),
            ),
            Text(
              '\$${car.estimatedValue.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color? borderColor;
  const _GlassBox({
    required this.child,
    required this.padding,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: borderColor ?? Colors.white.withValues(alpha: 0.1),
                width: 0.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
