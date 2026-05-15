import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../l10n/l10n.dart';
import '../../garage/models/car_model.dart';
import '../../garage/presentation/cubit/cars_collection_cubit.dart';
import '../../garage/ui/widgets/car_photo.dart';

class GarageSelectionDialog extends StatelessWidget {
  const GarageSelectionDialog({super.key});

  static Future<CarModel?> show(BuildContext context) {
    return showDialog<CarModel>(
      context: context,
      builder: (context) => const GarageSelectionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (context) => getIt<CarsCollectionCubit>(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A120B).withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Text(
                  l10n.marketSelectModelTitle.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: BlocBuilder<CarsCollectionCubit, CarsCollectionState>(
                    builder: (context, state) {
                      final query = state.maybeWhen(
                        data: (c, fc, pt, st, q, vt, stype, sorder) => q,
                        orElse: () => '',
                      );
                      return _SearchInput(
                        query: query,
                        onChanged: (v) => context.read<CarsCollectionCubit>().search(v),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<CarsCollectionCubit, CarsCollectionState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        loading: () => const Center(
                          child: CircularProgressIndicator(color: Color(0xFFFFD700)),
                        ),
                        error: (key) => Center(child: Text(key, style: const TextStyle(color: Colors.white))),
                        data: (cars, filtered, pt, st, q, vt, stype, sorder) {
                          if (filtered.isEmpty) {
                            return Center(
                              child: Text(
                                l10n.homeNoModelsTitle,
                                style: const TextStyle(color: Colors.white38),
                              ),
                            );
                          }
                          return ListView.separated(
                            padding: const EdgeInsets.all(24),
                            itemCount: filtered.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final car = filtered[index];
                              return _CarSelectionTile(
                                car: car,
                                onTap: () => Navigator.pop(context, car),
                              );
                            },
                          );
                        },
                        orElse: () => const SizedBox.shrink(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    l10n.cancelButtonLabel.toUpperCase(),
                    style: const TextStyle(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchInput extends StatelessWidget {
  final String query;
  final ValueChanged<String> onChanged;

  const _SearchInput({required this.query, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: TextField(
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: context.l10n.garageSearchHint,
          hintStyle: const TextStyle(color: Colors.white24),
          border: InputBorder.none,
          icon: const Icon(Icons.search, color: Color(0xFFFFD700), size: 18),
        ),
      ),
    );
  }
}

class _CarSelectionTile extends StatelessWidget {
  final CarModel car;
  final VoidCallback onTap;

  const _CarSelectionTile({required this.car, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 60,
                height: 60,
                child: car.displayPhotoPath != null
                    ? CarPhoto(path: car.displayPhotoPath!, fit: BoxFit.cover)
                    : Container(color: Colors.white10, child: const Icon(Icons.directions_car, color: Colors.white10, size: 30)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (car.toyMaker ?? '').toUpperCase(),
                    style: const TextStyle(color: Color(0xFFFFD700), fontSize: 8, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    '${car.brand} ${car.modelName}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (car.series != null)
                    Text(
                      car.series!,
                      style: const TextStyle(color: Colors.white38, fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}
