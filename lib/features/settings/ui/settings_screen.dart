import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart' as fp;
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/di/injection.dart';
import '../../../l10n/l10n.dart';
import '../../../shared/error_messages.dart';
import '../../profiles/models/shared_user_model.dart';
import '../models/settings_model.dart';
import '../presentation/settings_cubit.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return const Scaffold(body: Center(child: Text('No user')));

    return BlocProvider(
      create: (context) => getIt<SettingsCubit>()..init(userId),
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
              if (state is Success) {
                final message = state.messageKey != null 
                  ? (state.messageKey == 'account_upgraded_successfully' 
                      ? l10n.account_upgraded_successfully 
                      : l10n.backup_restored_successfully)
                  : l10n.saveSuccess;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              }
              if (state is Error && state.errorKey != null) {
                final error = messageForErrorKey(l10n, state.errorKey);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error), backgroundColor: Colors.red),
                );
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
                  Data(settings: final settings, profile: final profile, isGuest: final isGuest) =>
                    _SettingsList(settings: settings, profile: profile, isGuest: isGuest),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsList extends StatelessWidget {
  final SettingsModel settings;
  final SharedUserModel? profile;
  final bool isGuest;

  const _SettingsList({
    required this.settings, 
    this.profile,
    required this.isGuest,
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
          _SettingsCategoryCard(
            title: l10n.settingsSectionProfile,
            icon: Icons.person_outline,
            child: _ProfileSection(
              profile: profile, 
              settings: settings, 
              userId: userId,
              isGuest: isGuest,
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
            title: l10n.settingsSectionBackup,
            icon: Icons.backup_outlined,
            child: _BackupSection(),
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

class _ProfileSection extends StatefulWidget {
  final SharedUserModel? profile;
  final SettingsModel settings;
  final String userId;
  final bool isGuest;

  const _ProfileSection({
    this.profile, 
    required this.settings, 
    required this.userId,
    required this.isGuest,
  });

  @override
  State<_ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<_ProfileSection> {
  late TextEditingController _usernameController;
  late TextEditingController _garageNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.profile?.username ?? '');
    _garageNameController = TextEditingController(text: widget.settings.garageName ?? '');
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void didUpdateWidget(covariant _ProfileSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile?.username != widget.profile?.username) {
      _usernameController.text = widget.profile?.username ?? '';
    }
    if (oldWidget.settings.garageName != widget.settings.garageName) {
      _garageNameController.text = widget.settings.garageName ?? '';
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _garageNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (!mounted) return;
      final bytes = await image.readAsBytes();
      final extension = image.path.split('.').last.toLowerCase();
      
      if (mounted) {
        await context.read<SettingsCubit>().updateProfilePhoto(
          userId: widget.userId,
          bytes: bytes,
          extension: extension,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFFD700), width: 2),
                ),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white10,
                  backgroundImage: widget.profile?.photoUrl != null 
                    ? NetworkImage(widget.profile!.photoUrl!) 
                    : null,
                  child: widget.profile?.photoUrl == null 
                    ? const Icon(Icons.person, size: 40, color: Colors.white38) 
                    : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD700),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, size: 14, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _SettingsTextField(
          label: l10n.settingsUsernameLabel,
          icon: Icons.alternate_email,
          controller: _usernameController,
          onChanged: (val) => context.read<SettingsCubit>().updateUsername(widget.userId, val),
        ),
        const SizedBox(height: 16),
        _SettingsTextField(
          label: l10n.settingsGarageNameLabel,
          icon: Icons.garage_outlined,
          controller: _garageNameController,
          onChanged: (val) => context.read<SettingsCubit>().updateGarageName(widget.userId, val),
        ),
        if (widget.isGuest) ...[
          const SizedBox(height: 24),
          const Divider(color: Colors.white12, height: 1),
          const SizedBox(height: 24),
          _SettingsTextField(
            label: l10n.settingsEmailLabel,
            icon: Icons.email_outlined,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            onChanged: (val) {},
          ),
          const SizedBox(height: 16),
          _SettingsTextField(
            label: l10n.settingsPasswordLabel,
            icon: Icons.lock_outline,
            controller: _passwordController,
            obscureText: true,
            onChanged: (val) {},
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final email = _emailController.text.trim();
                final password = _passwordController.text.trim();
                if (email.isNotEmpty && password.isNotEmpty) {
                  context.read<SettingsCubit>().upgradeAccount(
                    email: email,
                    password: password,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                l10n.settingsRegisterButton.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
              ),
            ),
          ),
        ],
        if (!widget.isGuest) ...[
          const SizedBox(height: 24),
          _ActionTile(
            label: l10n.settingsChangeLoginLabel,
            icon: Icons.login,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _ActionTile(
            label: l10n.settingsChangePasswordLabel,
            icon: Icons.lock_outline,
            onTap: () {},
          ),
        ],
      ],
    );
  }
}

class _SettingsTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final Function(String) onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;

  const _SettingsTextField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.onChanged,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ),
        TextField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.white38, size: 18),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFFFD700)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
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
              onTap: () => context.read<SettingsCubit>().updateLanguage(userId, l),
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
            final path = await context.read<SettingsCubit>().exportBackup();
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
