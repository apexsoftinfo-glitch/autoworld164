import 'dart:ui';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/di/injection.dart';
import '../../../l10n/l10n.dart';
import '../../settings/presentation/settings_cubit.dart' as settings;
import '../../../shared/ui/widgets/garage_background.dart';
import '../models/car_model.dart';
import '../presentation/cubit/cars_collection_cubit.dart';

import 'car_form_screen.dart';
import 'car_details_screen.dart';
import 'widgets/car_photo.dart';
import '../utils/garage_card_pdf_generator.dart';

class GarageScreen extends StatelessWidget {
  const GarageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<CarsCollectionCubit>()),
        if (userId != null)
          BlocProvider.value(value: getIt<settings.SettingsCubit>()..init(userId)),
      ],
      child: const _GarageScreenView(),
    );
  }
}

class _GarageScreenView extends StatelessWidget {
  const _GarageScreenView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<settings.SettingsCubit, settings.SettingsState>(
        builder: (context, settingsState) {
          final background = settingsState is settings.Data 
              ? settingsState.settings.garageBackground 
              : 'assets/images/warm_garage.png';

          return GarageBackground(
            path: background,
            alpha: 0.5,
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
                          onFilter: () => _showBrandFilter(context, stats, query),
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            backgroundColor: const Color(0xFF2D1B0D),
                            color: const Color(0xFFFFD700),
                            onRefresh: () async {
                               context.read<CarsCollectionCubit>().retry();
                            },
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
                        ),
                        const _BottomAddButton(),
                      ],
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showBrandFilter(BuildContext context, Map<String, int> stats, String currentQuery) {
    final brands = stats.keys.toList()..sort();
    final cubit = context.read<CarsCollectionCubit>();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _BrandFilterSheet(
        brands: brands,
        stats: stats,
        currentQuery: currentQuery,
        onSelect: (brand) {
          cubit.search(brand ?? '');
          Navigator.pop(context);
        },
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
    final isPolish = Localizations.localeOf(context).languageCode == 'pl';
    
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
            value: isPolish ? '$valueStr PLN' : '\$$valueStr',
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
    final photoPath = car.displayPhotoPath;

    final isPolish = Localizations.localeOf(context).languageCode == 'pl';
    final currencyFormat = NumberFormat.simpleCurrency(
      locale: isPolish ? 'pl_PL' : 'en_US',
      name: isPolish ? 'PLN' : 'USD',
      decimalDigits: 0,
    );

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
                  child: photoPath != null
                      ? CarPhoto(
                          path: photoPath,
                          fit: BoxFit.cover,
                          placeholder: _ImagePlaceholder(),
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
                            (car.toyMaker ?? 'PRODUCENT').toUpperCase(),
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
                            '${car.brand} ${car.modelName}',
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
                            currencyFormat.format(car.estimatedValue),
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
          // Share button overlay — bottom right
          Positioned(
            bottom: 8,
            right: 8,
            child: _ShareButton(car: car),
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
  final VoidCallback onFilter;

  const _SearchAndToggleBar({
    required this.query,
    required this.viewType,
    required this.onSearch,
    required this.onToggle,
    required this.onFilter,
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
                decoration: InputDecoration(
                  hintText: 'Szukaj modelu...',
                  hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.directions_car, 
                    size: 18, 
                    color: query.isNotEmpty ? const Color(0xFFFFD700) : Colors.white12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _GlassBox(
            padding: EdgeInsets.zero,
            child: IconButton(
              icon: Icon(
                query.isNotEmpty ? Icons.filter_list_off : Icons.filter_list,
                color: query.isNotEmpty ? const Color(0xFFFFD700) : Colors.white70,
                size: 18,
              ),
              onPressed: onFilter,
            ),
          ),
          const SizedBox(width: 8),
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
    final photoPath = car.displayPhotoPath;

    final isPolish = Localizations.localeOf(context).languageCode == 'pl';
    final currencyFormat = NumberFormat.simpleCurrency(
      locale: isPolish ? 'pl_PL' : 'en_US',
      name: isPolish ? 'PLN' : 'USD',
      decimalDigits: 0,
    );

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
                child: photoPath != null
                  ? CarPhoto(path: photoPath, fit: BoxFit.cover, placeholder: _ImagePlaceholder())
                  : _ImagePlaceholder(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (car.toyMaker ?? 'PRODUCENT').toUpperCase(),
                    style: const TextStyle(color: Color(0xFFFFD700), fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1),
                  ),
                  Text(
                    '${car.brand} ${car.modelName}',
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
              currencyFormat.format(car.estimatedValue),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            _ShareButton(car: car),
          ],
        ),
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  final CarModel car;
  const _ShareButton({required this.car});

  @override
  Widget build(BuildContext context) {
    final supabase = getIt<SupabaseClient>();
    final settingsState = context.watch<settings.SettingsCubit>().state;
    final garageName = settingsState is settings.Data
        ? settingsState.settings.garageName
        : null;

    return GestureDetector(
      onTap: () => GarageCardPdfGenerator.generateAndShare(
        car,
        garageName: garageName,
        supabase: supabase,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.ios_share, size: 11, color: Colors.white60),
            SizedBox(width: 3),
            Text(
              'PDF',
              style: TextStyle(color: Colors.white60, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomAddButton extends StatelessWidget {
  const _BottomAddButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Row(
        children: [
          _GlassBox(
            padding: EdgeInsets.zero,
            child: SizedBox(
              width: 56,
              height: 56,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: FilledButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CarFormScreen()),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                icon: const Icon(Icons.add),
                label: const Text(
                  'DODAJ NOWY MODEL',
                  style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandFilterSheet extends StatelessWidget {
  final List<String> brands;
  final Map<String, int> stats;
  final String currentQuery;
  final Function(String?) onSelect;

  const _BrandFilterSheet({
    required this.brands,
    required this.stats,
    required this.currentQuery,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PRODUCENCI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w200,
                    letterSpacing: 2,
                  ),
                ),
                if (currentQuery.isNotEmpty)
                  TextButton(
                    onPressed: () => onSelect(null),
                    child: Text(
                      'USUŃ FILTR',
                      style: TextStyle(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.7),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                final count = stats[brand] ?? 0;
                final isSelected = currentQuery.toLowerCase() == brand.toLowerCase();
                
                return ListTile(
                  onTap: () => onSelect(brand),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFFD700).withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.directions_car, 
                      size: 16, 
                      color: isSelected ? const Color(0xFFFFD700) : Colors.white38,
                    ),
                  ),
                  title: Text(
                    brand.toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? const Color(0xFFFFD700) : Colors.white70,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w900 : FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      count.toString(),
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.01),
                ],
              ),
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
