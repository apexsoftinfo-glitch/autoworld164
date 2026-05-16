import 'dart:ui';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/di/injection.dart';
import '../../../l10n/l10n.dart';
import '../../settings/presentation/settings_cubit.dart' as settings;
import '../../../shared/ui/widgets/garage_background.dart';
import '../models/market_car_model.dart';
import '../presentation/cubit/market_cubit.dart';
import '../../garage/presentation/cubit/cars_collection_cubit.dart'; // For SortType/Order
import '../../garage/ui/widgets/car_photo.dart';
import 'market_car_form_screen.dart';
import 'market_car_details_screen.dart';
import 'widgets/garage_move_success_dialog.dart';
import 'garage_selection_dialog.dart';
import 'widgets/market_report_dialog.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<MarketCubit>()),
        if (userId != null)
          BlocProvider.value(value: getIt<settings.SettingsCubit>()..init(userId)),
      ],
      child: const _MarketScreenView(),
    );
  }
}

class _MarketScreenView extends StatelessWidget {
  const _MarketScreenView();

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
            child: BlocBuilder<MarketCubit, MarketState>(
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
                  data: (cars, filtered, query, viewType, st, so) {
                    if (cars.isEmpty) {
                      return const _EmptyMarketView();
                    }

                    return Column(
                      children: [
                        _MarketHeader(count: filtered.length),
                        const SizedBox(height: 16),
                        _SearchAndToggleBar(
                          query: query,
                          viewType: viewType,
                          onSearch: (v) => context.read<MarketCubit>().search(v),
                          onToggle: () => context.read<MarketCubit>().toggleView(),
                        ),
                        _SortBar(
                          currentSort: st,
                          currentOrder: so,
                          onSort: (type) => context.read<MarketCubit>().changeSort(type),
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            backgroundColor: const Color(0xFF2D1B0D),
                            color: const Color(0xFFFFD700),
                            onRefresh: () async {
                               context.read<MarketCubit>().retry();
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
                                    return _MarketCarCard(car: filtered[index]);
                                  },
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                                  itemCount: filtered.length,
                                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    return _MarketCarListTile(car: filtered[index]);
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
}

class _MarketHeader extends StatelessWidget {
  final int count;

  const _MarketHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.fromLTRB(16, kToolbarHeight + 10, 16, 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                count.toString(),
                style: const TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                context.l10n.huntingTitle.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchAndToggleBar extends StatelessWidget {
  final String query;
  final CollectionViewType viewType;
  final Function(String) onSearch;
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
                decoration: InputDecoration(
                  hintText: context.l10n.huntingSearchHint,
                  hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
                  border: InputBorder.none,
                  icon: const Icon(Icons.search, color: Color(0xFFFFD700), size: 18),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _GlassBox(
            padding: EdgeInsets.zero,
            child: IconButton(
              onPressed: onToggle,
              icon: Icon(
                viewType == CollectionViewType.grid ? Icons.list : Icons.grid_view,
                color: Colors.white70,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SortBar extends StatelessWidget {
  final SortType currentSort;
  final SortOrder currentOrder;
  final Function(SortType) onSort;

  const _SortBar({
    required this.currentSort,
    required this.currentOrder,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
      child: Row(
        children: [
          _SortButton(
            icon: Icons.layers_outlined,
            label: l10n.carSeriesLabel.toUpperCase(),
            isSelected: currentSort == SortType.series,
            order: currentOrder,
            onTap: () => onSort(SortType.series),
          ),
          const SizedBox(width: 8),
          _SortButton(
            icon: Icons.sell_outlined,
            label: l10n.carPurchasePriceLabel.split('(').first.trim().toUpperCase(),
            isSelected: currentSort == SortType.price,
            order: currentOrder,
            onTap: () => onSort(SortType.price),
          ),
          const SizedBox(width: 8),
          _SortButton(
            icon: Icons.factory_outlined,
            label: l10n.carProducerPlaceholder.toUpperCase(),
            isSelected: currentSort == SortType.producer,
            order: currentOrder,
            onTap: () => onSort(SortType.producer),
          ),
        ],
      ),
    );
  }
}

class _SortButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final SortOrder order;
  final VoidCallback onTap;

  const _SortButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFFFFD700);
    final color = isSelected ? activeColor : Colors.white70;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? activeColor.withValues(alpha: 0.2) : Colors.black45,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? activeColor.withValues(alpha: 0.6) : Colors.white12,
                width: isSelected ? 1 : 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 4),
                  Icon(
                    order == SortOrder.asc ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 10,
                    color: activeColor,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MarketCarCard extends StatelessWidget {
  final MarketCarModel car;

  const _MarketCarCard({required this.car});

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
                          folderName: 'autoworld_photos',
                          placeholder: const _ImagePlaceholder(),
                        )
                      : const _ImagePlaceholder(),
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
                            (car.toyMaker ?? context.l10n.carProducerPlaceholder).toUpperCase(),
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
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currencyFormat.format(car.price),
                            style: const TextStyle(
                              color: Color(0xFFFFD700),
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Expanded(
                            child: _MarketTags(car: car),
                          ),
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
              borderRadius: BorderRadius.circular(20),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MarketCarDetailsScreen(car: car)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MarketCarListTile extends StatelessWidget {
  final MarketCarModel car;
  const _MarketCarListTile({required this.car});

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
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MarketCarDetailsScreen(car: car)),
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 80,
            height: 80,
            child: photoPath != null
                ? CarPhoto(
                    path: photoPath,
                    fit: BoxFit.cover,
                    folderName: 'autoworld_photos',
                    placeholder: const _ImagePlaceholder(),
                  )
                : const _ImagePlaceholder(),
          ),
        ),
        title: Text(
          '${car.brand} ${car.modelName}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Row(
          children: [
             Text(
              car.toyMaker?.toUpperCase() ?? '',
              style: const TextStyle(color: Color(0xFFFFD700), fontSize: 9, fontWeight: FontWeight.w900),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _MarketTags(car: car),
            ),
          ],
        ),
        trailing: Text(
          currencyFormat.format(car.price),
          style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.w900),
        ),
      ),
    );
  }
}

class _MarketTags extends StatelessWidget {
  final MarketCarModel car;
  const _MarketTags({required this.car});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 4,
      runSpacing: 4,
      children: [
        if (car.isAuction)
          _Tag(
            label: l10n.marketAuction.toUpperCase(),
            color: const Color(0xFFFFD700),
          ),
        if (car.isExchange)
          _Tag(
            label: l10n.marketExchangeBadge.toUpperCase(),
            color: Colors.blueAccent,
          ),
        if (car.isSale)
          _Tag(
            label: l10n.marketSaleBadge.toUpperCase(),
            color: Colors.greenAccent,
          ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 6,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _EmptyMarketView extends StatelessWidget {
  const _EmptyMarketView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.store_outlined, size: 64, color: Colors.white10),
          const SizedBox(height: 16),
          Text(
            context.l10n.huntingEmptyTitle.toUpperCase(),
            style: const TextStyle(color: Colors.white30, fontWeight: FontWeight.w900, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              context.l10n.huntingEmptySubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white10, fontSize: 12),
            ),
          ),
          const SizedBox(height: 32),
          _BottomAddButton(),
        ],
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
          _GlassBox(
            padding: EdgeInsets.zero,
            child: SizedBox(
              width: 56,
              height: 56,
              child: BlocBuilder<MarketCubit, MarketState>(
                builder: (context, state) {
                  final cars = state.maybeWhen(
                    data: (c, fc, q, vt, st, so) => fc,
                    orElse: () => <MarketCarModel>[],
                  );
                  return IconButton(
                    onPressed: cars.isEmpty ? null : () => MarketReportDialog.show(context, cars),
                    icon: Icon(
                      Icons.analytics_outlined, 
                      color: cars.isEmpty ? Colors.white10 : const Color(0xFFFFD700), 
                      size: 24,
                    ),
                  );
                },
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
                onPressed: () => _showAddOptions(context),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD700),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                icon: const Icon(Icons.add),
                label: Text(
                  context.l10n.garageAddNewCarButton,
                  style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A120B).withValues(alpha: 0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _OptionButton(
                icon: Icons.add_circle_outline,
                label: context.l10n.marketAddManual,
                onTap: () {
                  Navigator.pop(sheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MarketCarFormScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
              _OptionButton(
                icon: Icons.garage_outlined,
                label: context.l10n.marketAddFromGarage,
                onTap: () async {
                  Navigator.pop(sheetContext);
                  final car = await GarageSelectionDialog.show(context);
                  if (car != null && context.mounted) {
                    // Show loading overlay or handle it in cubit
                    try {
                      await context.read<MarketCubit>().moveFromGarage(car);
                      if (context.mounted) {
                        GarageMoveSuccessDialog.show(context, car);
                      }
                    } catch (e) {
                      // Error is logged in cubit
                    }
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OptionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFFD700)),
            const SizedBox(width: 16),
            Text(
              label.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 13),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.05),
      child: const Center(
        child: Icon(Icons.directions_car, color: Colors.white10, size: 48),
      ),
    );
  }
}

class _GlassBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _GlassBox({required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: child,
        ),
      ),
    );
  }
}
