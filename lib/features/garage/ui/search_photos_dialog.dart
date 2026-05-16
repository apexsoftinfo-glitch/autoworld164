import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../l10n/l10n.dart';
import '../presentation/cubit/search_photos_cubit.dart';

class SearchPhotosDialog extends StatelessWidget {
  final String query;

  const SearchPhotosDialog({super.key, required this.query});

  static Future<String?> show(BuildContext context, String query) {
    return showDialog<String>(
      context: context,
      builder: (_) => SearchPhotosDialog(query: query),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocProvider(
      create: (context) => getIt<SearchPhotosCubit>()..search(query),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A120B).withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                Text(
                  l10n.carSearchPhotosLabel.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  query.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    query,
                    style: const TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 24),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: BlocBuilder<SearchPhotosCubit, SearchPhotosState>(
                    builder: (context, state) {
                      return state.when(
                        initial: () => const SizedBox(height: 200),
                        loading: () => const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator(color: Color(0xFFFFD700))),
                        ),
                        error: (key) => SizedBox(
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
                              const SizedBox(height: 16),
                              Text(key, style: const TextStyle(color: Colors.redAccent)),
                                TextButton(
                                  onPressed: () => context.read<SearchPhotosCubit>().search(query),
                                  child: Text(l10n.marketTryAgain.toUpperCase(), style: const TextStyle(color: Color(0xFFFFD700))),
                                ),
                              ],
                            ),
                          ),
                          success: (urls, isLoadingMore) => urls.isEmpty
                              ? SizedBox(
                                  height: 200,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.search_off, color: Colors.white24, size: 40),
                                      const SizedBox(height: 16),
                                      Text(l10n.marketSearchNoResults, style: const TextStyle(color: Colors.white24)),
                                      const SizedBox(height: 8),
                                      TextButton(
                                        onPressed: () => context.read<SearchPhotosCubit>().search(query),
                                        child: Text(l10n.marketTryAgain.toUpperCase(), style: const TextStyle(color: Color(0xFFFFD700))),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: GridView.builder(
                                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12,
                                        ),
                                        itemCount: urls.length,
                                        itemBuilder: (context, i) {
                                          final url = urls[i];
                                          return GestureDetector(
                                            onTap: () => Navigator.pop(context, url),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(color: Colors.white10),
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(16),
                                                child: Image.network(
                                                  url,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context, child, progress) {
                                                    if (progress == null) return child;
                                                    return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                                                  },
                                                  errorBuilder: (context, error, stackTrace) => const Center(
                                                    child: Icon(Icons.broken_image_outlined, color: Colors.white24, size: 30),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    if (isLoadingMore)
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 20),
                                        child: CircularProgressIndicator(color: Color(0xFFFFD700)),
                                      )
                                    else if (urls.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 20),
                                        child: TextButton.icon(
                                          onPressed: () => context.read<SearchPhotosCubit>().loadMore(query),
                                          icon: const Icon(Icons.add_circle_outline, color: Color(0xFFFFD700)),
                                          label: Text(
                                            l10n.huntingSearchButton.toUpperCase(),
                                            style: const TextStyle(
                                              color: Color(0xFFFFD700),
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    l10n.closeButtonLabel.toUpperCase(),
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
