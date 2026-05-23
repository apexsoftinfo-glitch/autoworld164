import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart' as fp;
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/di/injection.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/error_messages.dart';
import '../../../app/locale/presentation/cubit/app_locale_cubit.dart';
import '../../../app/locale/models/app_locale_option_model.dart';
import '../../profiles/models/shared_user_model.dart';
import '../../profiles/presentation/ui/profile_screen.dart';
import '../models/settings_model.dart';
import '../presentation/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return const Scaffold(body: Center(child: Text('No user')));

    return BlocProvider.value(
      value: getIt<SettingsCubit>()..init(userId),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          l10n.settingsTitle.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/settings_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Blur and Darken Overlay
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withValues(alpha: 0.6),
              ),
            ),
          ),
          // Content
          BlocListener<SettingsCubit, SettingsState>(
            listener: (context, state) {
              if (state is Data) {
                if (state.isImporting) {
                  _showImportStatusDialog(context, isProgress: true);
                }
                if (state.isExporting) {
                  _showExportStatusDialog(context, isProgress: true);
                }
              }

              if (state is Success) {
                if (state.messageKey == 'backup_restored_successfully') {
                  // Close progress dialog if open
                  Navigator.of(context, rootNavigator: true).pop();
                  _showImportStatusDialog(context, isProgress: false, success: true);
                } else if (state.messageKey == 'backup_created_successfully') {
                  // Close progress dialog if open
                  Navigator.of(context, rootNavigator: true).pop();
                } else {
                  final message = state.messageKey == 'account_upgraded_successfully' 
                      ? l10n.account_upgraded_successfully 
                      : l10n.saveSuccess;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                }
              }
              
              if (state is Error) {
                if (state.errorKey == 'error_importing_backup') {
                  // Close progress dialog if open
                  Navigator.of(context, rootNavigator: true).pop();
                  _showImportStatusDialog(context, isProgress: false, success: false, error: state.errorMessage);
                } else if (state.errorKey == 'error_exporting_backup') {
                  // Close progress dialog if open
                  Navigator.of(context, rootNavigator: true).pop();
                } else if (state.errorKey != null) {
                  final error = messageForErrorKey(l10n, state.errorKey);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                return switch (state) {
                  Initial() || Loading() || Success() => const Center(
                      child: CircularProgressIndicator(color: Color(0xFFFFD700)),
                    ),
                  Error(errorKey: final key) => Center(
                      child: Text(
                        messageForErrorKey(l10n, key),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  Data(settings: final settings, profile: final profile, isGuest: final isGuest, pendingEmail: final pendingEmail, isUploadingPhoto: final isUploadingPhoto, isImporting: _, localPhotoBytes: final localPhotoBytes) =>
                    _SettingsList(
                      settings: settings, 
                      profile: profile, 
                      isGuest: isGuest, 
                      pendingEmail: pendingEmail,
                      isUploadingPhoto: isUploadingPhoto,
                      localPhotoBytes: localPhotoBytes,
                    ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showExportStatusDialog(BuildContext context, {required bool isProgress}) {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      barrierDismissible: !isProgress,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isProgress) ...[
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(color: Color(0xFFFFD700), strokeWidth: 3),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.settingsBackupCreate.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1),
                ),
                const SizedBox(height: 12),
                const LinearProgressIndicator(
                  backgroundColor: Colors.white10,
                  color: Color(0xFFFFD700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Przygotowywanie plików...',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
                const SizedBox(height: 4),
                const Text(
                  'To może chwilę potrwać',
                  style: TextStyle(color: Colors.white24, fontSize: 10),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showImportStatusDialog(BuildContext context, {required bool isProgress, bool success = false, String? error}) {
    final l10n = context.l10n;
    showDialog<void>(
      context: context,
      barrierDismissible: !isProgress,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isProgress) ...[
                const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(color: Color(0xFFFFD700), strokeWidth: 3),
                ),
                const SizedBox(height: 24),
                Text(
                  l10n.settingsBackupRestore.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1),
                ),
                const SizedBox(height: 12),
                const LinearProgressIndicator(
                  backgroundColor: Colors.white10,
                  color: Color(0xFFFFD700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Przenoszenie danych...',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ] else if (success) ...[
                const Icon(Icons.check_circle_outline, color: Colors.green, size: 64),
                const SizedBox(height: 16),
                Text(
                  l10n.backup_restored_successfully.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(l10n.commonOk.toUpperCase()),
                  ),
                ),
              ] else ...[
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                const Text(
                  'BŁĄD IMPORTU',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  error ?? 'Nieznany błąd',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.commonOk.toUpperCase(), style: const TextStyle(color: Colors.white54)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsList extends StatelessWidget {
  final SettingsModel settings;
  final SharedUserModel? profile;
  final bool isGuest;
  final String? pendingEmail;

  final bool isUploadingPhoto;
  final Uint8List? localPhotoBytes;

  const _SettingsList({
    required this.settings, 
    this.profile,
    required this.isGuest,
    this.pendingEmail,
    required this.isUploadingPhoto,
    this.localPhotoBytes,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final userId = Supabase.instance.client.auth.currentUser!.id;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 80,
        20,
        40,
      ),
      child: Column(
        children: [
          _ActionTile(
            label: l10n.settingsSectionProfile,
            icon: Icons.person_outline,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
          const SizedBox(height: 20),
          _SettingsCategoryCard(
            title: l10n.settingsSectionCurrency,
            icon: Icons.payments_outlined,
            child: _CurrencySection(settings: settings, userId: userId),
          ),
          const SizedBox(height: 20),
          _SettingsCategoryCard(
            title: l10n.settingsSectionLanguage,
            icon: Icons.language_outlined,
            child: _LanguageSection(settings: settings, userId: userId),
          ),
          const SizedBox(height: 20),
          _SettingsCategoryCard(
            title: l10n.settingsSectionAppearance,
            icon: Icons.palette_outlined,
            child: _AppearanceSection(settings: settings, userId: userId),
          ),
          const SizedBox(height: 20),
          _SettingsCategoryCard(
            title: l10n.settingsSectionBackup,
            icon: Icons.backup_outlined,
            child: _BackupSection(),
          ),
          const SizedBox(height: 40),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final info = snapshot.data!;
                return Text(
                  'AutoWorld164 v${info.version}+${info.buildNumber}',
                  style: const TextStyle(
                    color: Colors.white24,
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsCategoryCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SettingsCategoryCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  State<_SettingsCategoryCard> createState() => _SettingsCategoryCardState();
}

class _SettingsCategoryCardState extends State<_SettingsCategoryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Icon(widget.icon, color: const Color(0xFFFFD700), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 200),
                    turns: _isExpanded ? 0.5 : 0,
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              children: [
                const Divider(color: Colors.white12, height: 1),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: widget.child,
                ),
              ],
            ),
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
            sizeCurve: Curves.easeInOut,
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionTile({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white54, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrencySection extends StatelessWidget {
  final SettingsModel settings;
  final String userId;

  const _CurrencySection({required this.settings, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: AppCurrency.values.map((c) {
        final isSelected = settings.currency == c;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _ChoiceCard(
              label: c.name.toUpperCase(),
              isSelected: isSelected,
              onTap: () => context.read<SettingsCubit>().updateCurrency(userId, c),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _LanguageSection extends StatelessWidget {
  final SettingsModel settings;
  final String userId;

  const _LanguageSection({required this.settings, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: AppLanguage.values.map((l) {
        final isSelected = settings.language == l;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _ChoiceCard(
              label: l == AppLanguage.pl ? 'PL' : 'EN',
              isSelected: isSelected,
              onTap: () {
                context.read<SettingsCubit>().updateLanguage(userId, l);
                final localeOption = l == AppLanguage.pl 
                    ? AppLocaleOptionModel.polish 
                    : AppLocaleOptionModel.english;
                context.read<AppLocaleCubit>().selectLocale(localeOption);
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChoiceCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFD700) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? null : Border.all(color: Colors.white12),
          boxShadow: isSelected ? [
            BoxShadow(
              color: const Color(0xFFFFD700).withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ] : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white70,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _BackupSection extends StatelessWidget {
  const _BackupSection();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final userId = Supabase.instance.client.auth.currentUser!.id;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.settingsBackupDescription,
          style: const TextStyle(color: Colors.white54, fontSize: 12, height: 1.5),
        ),
        const SizedBox(height: 20),
        _ActionTile(
          label: l10n.settingsBackupCreate,
          icon: Icons.file_upload_outlined,
          onTap: () async {
            final box = context.findRenderObject() as RenderBox?;
            final path = await context.read<SettingsCubit>().exportBackup(userId);
            if (path != null) {
              await SharePlus.instance.share(
                ShareParams(
                  files: [XFile(path)],
                  text: 'AutoWorld 1/64 Backup',
                  sharePositionOrigin: box != null ? box.localToGlobal(Offset.zero) & box.size : null,
                ),
              );
            }
          },
        ),
        const SizedBox(height: 12),
        _ActionTile(
          label: l10n.settingsBackupRestore,
          icon: Icons.file_download_outlined,
          onTap: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: const Color(0xFF1C1C1E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                title: Text(l10n.backup_restore_confirm_title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                content: Text(l10n.backup_restore_confirm_body, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(l10n.commonNo.toUpperCase(), style: const TextStyle(color: Colors.white38, fontWeight: FontWeight.w900)),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(l10n.commonYes.toUpperCase(), style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.w900)),
                  ),
                ],
              ),
            );

            if (confirm == true) {
              final result = await fp.FilePicker.pickFiles(
                type: fp.FileType.custom,
                allowedExtensions: ['zip'],
              );

              if (result != null && result.files.single.path != null) {
                if (context.mounted) {
                  await context.read<SettingsCubit>().importBackup(result.files.single.path!, userId);
                }
              }
            }
          },
        ),
      ],
    );
  }
}

class _AppearanceSection extends StatelessWidget {
  final SettingsModel settings;
  final String userId;

  const _AppearanceSection({required this.settings, required this.userId});

  @override
  Widget build(BuildContext context) {
    final backgrounds = [
      {'path': 'assets/images/warm_garage.png', 'name': 'Klasyczny'},
      {'path': 'assets/images/industrial_dark_garage.png', 'name': 'Industrialny'},
      {'path': 'assets/images/modern_carbon_garage.png', 'name': 'Ciemny Carbon'},
      {'path': 'assets/images/add_model_bg.png', 'name': 'Nowoczesny'},
      {'path': 'assets/images/settings_bg.png', 'name': 'Abstrakcyjny'},
    ];

    final isCustomBg = settings.garageBackground.isNotEmpty && !settings.garageBackground.startsWith('assets/');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: backgrounds.length + 1,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index == 0) {
                return _CustomBackgroundTile(
                  userId: userId, 
                  isSelected: isCustomBg,
                  path: isCustomBg ? settings.garageBackground : null,
                );
              }
              final bg = backgrounds[index - 1];
              final isSelected = !isCustomBg && settings.garageBackground == bg['path'];
              
              return GestureDetector(
                onTap: () => context.read<SettingsCubit>().updateGarageBackground(userId, bg['path']!),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? const Color(0xFFFFD700) : Colors.white12,
                          width: isSelected ? 3 : 1,
                        ),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                            blurRadius: 10,
                          )
                        ] : null,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(bg['path']!, fit: BoxFit.cover),
                          if (isSelected) 
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFD700),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check, size: 12, color: Colors.black),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bg['name']!,
                      style: TextStyle(
                        color: isSelected ? const Color(0xFFFFD700) : Colors.white54,
                        fontSize: 10,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CustomBackgroundTile extends StatelessWidget {
  final String userId;
  final bool isSelected;
  final String? path;

  const _CustomBackgroundTile({
    required this.userId,
    required this.isSelected,
    this.path,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picker = ImagePicker();
        final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
        if (image != null) {
          final bytes = await image.readAsBytes();
          final extension = p.extension(image.path).replaceAll('.', '');
          if (context.mounted) {
            context.read<SettingsCubit>().updateCustomBackground(
              userId: userId,
              bytes: bytes,
              extension: extension,
            );
          }
        }
      },
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? const Color(0xFFFFD700) : Colors.white12,
                width: isSelected ? 3 : 1,
              ),
              color: Colors.white.withValues(alpha: 0.05),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                  blurRadius: 10,
                )
              ] : null,
            ),
            clipBehavior: Clip.antiAlias,
            child: path != null 
              ? FutureBuilder<String>(
                  future: _getLocalPath(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final file = File(snapshot.data!);
                      if (file.existsSync()) {
                        return Image.file(file, fit: BoxFit.cover);
                      }
                    }
                    return const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFFD700)));
                  },
                )
              : const Center(child: Icon(Icons.add_photo_alternate_outlined, color: Colors.white24, size: 32)),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.settingsAddCustomBackground.toUpperCase(),
            style: TextStyle(
              color: isSelected ? const Color(0xFFFFD700) : Colors.white54,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _getLocalPath() async {
    final docs = await getApplicationDocumentsDirectory();
    return p.join(docs.path, 'autoworld_photos', path!);
  }
}
