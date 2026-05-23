import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/locale/models/app_locale_option_model.dart';
import '../../../../app/locale/presentation/cubit/app_locale_cubit.dart';
import '../../../../app/developer/ui/developer_screen.dart';
import '../../../../app/profile/presentation/cubit/account_actions_cubit.dart';
import '../../../../app/session/presentation/cubit/session_cubit.dart';
import '../../../../app/session/presentation/session_localizations.dart';
import '../../../../core/di/injection.dart';
import '../../../../features/auth/presentation/ui/login_screen.dart';
import '../../../../features/auth/presentation/ui/register_screen.dart';
import '../../../../core/config/revenuecat_config.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/error_messages.dart';
import '../../../settings/models/settings_model.dart';
import '../../../settings/presentation/settings_cubit.dart';
import '../cubit/profile_cubit.dart';
import '../../ui/widgets/profile_photo.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppLocaleCubit>.value(value: getIt<AppLocaleCubit>()),
        BlocProvider<SessionCubit>.value(value: getIt<SessionCubit>()),
        BlocProvider<ProfileCubit>(create: (_) => getIt<ProfileCubit>()),
        BlocProvider<AccountActionsCubit>(
          create: (_) => getIt<AccountActionsCubit>(),
        ),
      ],
      child: const _ProfileViewWrapper(),
    );
  }
}

class _ProfileViewWrapper extends StatelessWidget {
  const _ProfileViewWrapper();

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final userId = session.userIdOrNull;
    if (userId == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFFD700)),
        ),
      );
    }

    return BlocProvider<SettingsCubit>.value(
      value: getIt<SettingsCubit>()..init(userId),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  late final TextEditingController _firstNameController;
  late final FocusNode _firstNameFocusNode;

  late final TextEditingController _garageNameController;
  late final FocusNode _garageNameFocusNode;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _firstNameFocusNode = FocusNode();

    _garageNameController = TextEditingController();
    _garageNameFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _firstNameFocusNode.dispose();

    _garageNameController.dispose();
    _garageNameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>().state;
    final sharedUser = session.sharedUserOrNull;
    final firstName = sharedUser?.firstName ?? '';
    final l10n = context.l10n;

    if (!_firstNameFocusNode.hasFocus &&
        _firstNameController.text != firstName) {
      _firstNameController.text = firstName;
    }

    final settingsState = context.watch<SettingsCubit>().state;
    String garageName = '';
    if (settingsState is Data) {
      garageName = settingsState.settings.garageName ?? '';
    }
    if (!_garageNameFocusNode.hasFocus &&
        _garageNameController.text != garageName) {
      _garageNameController.text = garageName;
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.successKey == 'profile_saved') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.profileSavedSnackbar),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<ProfileCubit>().clearFeedback();
            }
          },
        ),
        BlocListener<AccountActionsCubit, AccountActionsState>(
          listener: (context, state) {
            if (state.successKey == 'pro_enabled') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.proEnabledSnackbar),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<AccountActionsCubit>().clearFeedback();
            }
            if (state.successKey == 'password_changed') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.saveSuccess),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<AccountActionsCubit>().clearFeedback();
            }
          },
        ),
      ],
      child: PopScope(
        canPop: !_hasUnsavedChanges(firstName, garageName),
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop || !_hasUnsavedChanges(firstName, garageName)) return;

          final shouldDiscard = await _confirmDiscardChanges(context);
          if (!context.mounted || !shouldDiscard) return;
          Navigator.of(context).pop();
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                l10n.profileTitle.toUpperCase(),
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
            extendBodyBehindAppBar: true,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/warm_garage.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withValues(alpha: 0.85),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, profileState) {
                          return BlocBuilder<
                            AccountActionsCubit,
                            AccountActionsState
                          >(
                            builder: (context, accountState) {
                              final isSavingName = profileState.isSaving;
                              final activeAccountAction =
                                  accountState.activeAction;
                              final isInteractionLocked =
                                  isSavingName || activeAccountAction != null;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (session.shouldShowProtectProBanner) ...[
                                    const _ProtectProBanner(),
                                    const SizedBox(height: 20),
                                  ],
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(color: Colors.white12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Center(
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                                                    width: 2,
                                                  ),
                                                ),
                                                child: ProfilePhoto(
                                                  radius: 40,
                                                  url: sharedUser?.photoUrl,
                                                ),
                                              ),
                                              if (isSavingName)
                                                Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: const BoxDecoration(
                                                    color: Colors.black45,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Center(
                                                    child: CircularProgressIndicator(
                                                      color: Color(0xFFFFD700),
                                                      strokeWidth: 2,
                                                    ),
                                                  ),
                                                ),
                                              if (!isSavingName)
                                                Positioned(
                                                  bottom: 0,
                                                  right: 0,
                                                  child: GestureDetector(
                                                    onTap: () => _pickImage(context, session),
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
                                        _ProfileTextField(
                                          label: l10n.firstNameFieldLabel,
                                          icon: Icons.person_outline,
                                          controller: _firstNameController,
                                          focusNode: _firstNameFocusNode,
                                          enabled: !isInteractionLocked,
                                          keyboardType: TextInputType.name,
                                          textCapitalization: TextCapitalization.words,
                                          onChanged: (_) => setState(() {}),
                                        ),
                                        const SizedBox(height: 16),
                                        _ProfileTextField(
                                          label: l10n.settingsGarageNameLabel,
                                          icon: Icons.garage_outlined,
                                          controller: _garageNameController,
                                          focusNode: _garageNameFocusNode,
                                          enabled: !isInteractionLocked,
                                          keyboardType: TextInputType.text,
                                          onChanged: (_) => setState(() {}),
                                        ),
                                        const SizedBox(height: 24),
                                        ElevatedButton(
                                          onPressed: !isInteractionLocked && _hasUnsavedChanges(firstName, garageName)
                                              ? () => _saveProfile(context, session, firstName, garageName)
                                              : null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFFFD700),
                                            foregroundColor: Colors.black,
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            disabledBackgroundColor: Colors.white12,
                                            disabledForegroundColor: Colors.white30,
                                          ),
                                          child: isSavingName
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.black,
                                                  ),
                                                )
                                              : Text(
                                                  l10n.carFormSaveButton.toUpperCase(),
                                                  style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
                                                ),
                                        ),
                                        if (!session.isAnonymousUser) ...[
                                          const SizedBox(height: 24),
                                          const Divider(color: Colors.white10, height: 1),
                                          const SizedBox(height: 24),
                                          _ProfileTextField(
                                            label: l10n.emailFieldLabel,
                                            icon: Icons.email_outlined,
                                            controller: TextEditingController(text: session.emailOrNull),
                                            focusNode: FocusNode(),
                                            enabled: false,
                                            keyboardType: TextInputType.emailAddress,
                                          ),
                                          const SizedBox(height: 16),
                                          OutlinedButton.icon(
                                            onPressed: !isInteractionLocked
                                                ? () => _showChangePasswordDialog(context)
                                                : null,
                                            icon: const Icon(Icons.lock_outline),
                                            label: Text(l10n.settingsChangePasswordLabel.toUpperCase()),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: const Color(0xFFFFD700),
                                              side: const BorderSide(color: Color(0xFFFFD700)),
                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            ),
                                          ),
                                        ],
                                        const SizedBox(height: 24),
                                        const Divider(color: Colors.white10, height: 1),
                                        const SizedBox(height: 24),
                                        _AppLanguageDropdown(
                                          isEnabled: !isInteractionLocked,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (profileState.errorKey != null) ...[
                                    const SizedBox(height: 16),
                                    SelectableText(
                                      messageForErrorKey(l10n, profileState.errorKey),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                  if (accountState.errorKey != null) ...[
                                    const SizedBox(height: 16),
                                    SelectableText(
                                      messageForErrorKey(l10n, accountState.errorKey),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                  const SizedBox(height: 24),
                                  if (session.isAnonymousUser) ...[
                                    ElevatedButton(
                                      onPressed: !isInteractionLocked
                                          ? () async {
                                              final result = await Navigator.of(context).push<bool>(
                                                MaterialPageRoute<bool>(
                                                  builder: (_) => const RegisterScreen(),
                                                ),
                                              );
                                              if (!context.mounted) return;
                                              if (result == true) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(l10n.accountSecuredSnackbar),
                                                    backgroundColor: Colors.green,
                                                  ),
                                                );
                                              }
                                            }
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFFFD700),
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      ),
                                      child: Text(
                                        l10n.registerButtonLabel.toUpperCase(),
                                        style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    OutlinedButton(
                                      onPressed: !isInteractionLocked
                                          ? () => Navigator.of(context).push<void>(
                                                MaterialPageRoute<void>(
                                                  builder: (_) => const LoginScreen(),
                                                ),
                                              )
                                          : null,
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFFFFD700),
                                        side: const BorderSide(color: Color(0xFFFFD700)),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      ),
                                      child: Text(
                                        l10n.loginButtonLabel.toUpperCase(),
                                        style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                  if (!session.isAnonymousUser) ...[
                                    OutlinedButton(
                                      onPressed: !isInteractionLocked
                                          ? () => context.read<AccountActionsCubit>().signOut()
                                          : null,
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.white70,
                                        side: const BorderSide(color: Colors.white24),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      ),
                                      child: activeAccountAction == AccountAction.signOut
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70),
                                            )
                                          : Text(
                                              l10n.logoutButtonLabel.toUpperCase(),
                                              style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1),
                                            ),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                  if (!session.isProUser && RevenueCatConfig.isEnabled) ...[
                                    ElevatedButton(
                                      onPressed: !isInteractionLocked && session.userIdOrNull != null
                                          ? () => context.read<AccountActionsCubit>().buyPro(session.userIdOrNull!)
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFFFD700),
                                        foregroundColor: Colors.black,
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      ),
                                      child: activeAccountAction == AccountAction.buyPro
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                                            )
                                          : Text(
                                              l10n.buyProButtonLabel.toUpperCase(),
                                              style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
                                            ),
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                  OutlinedButton(
                                    onPressed: !isInteractionLocked
                                        ? () => _confirmDeleteAccount(context)
                                        : null,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.redAccent,
                                      side: const BorderSide(color: Colors.redAccent),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    ),
                                    child: activeAccountAction == AccountAction.deleteAccount
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.redAccent),
                                          )
                                        : Text(
                                            l10n.deleteAccountButtonLabel.toUpperCase(),
                                            style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1),
                                          ),
                                  ),
                                  if (kDebugMode) ...[
                                    const Divider(height: 48, color: Colors.white10),
                                    _ProfileSummary(session: session),
                                    const SizedBox(height: 12),
                                    OutlinedButton.icon(
                                      onPressed: !isInteractionLocked
                                          ? () => Navigator.of(context).push<void>(
                                                MaterialPageRoute<void>(
                                                  builder: (_) => const DeveloperScreen(),
                                                ),
                                              )
                                          : null,
                                      icon: const Icon(Icons.developer_mode),
                                      label: Text(l10n.developerToolsTitle.toUpperCase()),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.white54,
                                        side: const BorderSide(color: Colors.white24),
                                        padding: const EdgeInsets.symmetric(vertical: 16),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _hasUnsavedChanges(String firstName, String garageName) {
    return _firstNameController.text.trim() != firstName.trim() ||
        _garageNameController.text.trim() != garageName.trim();
  }

  Future<bool> _confirmDiscardChanges(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          context.l10n.discardChangesTitle,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        content: Text(
          context.l10n.discardChangesBody,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              context.l10n.stayButtonLabel.toUpperCase(),
              style: const TextStyle(color: Colors.white38, fontWeight: FontWeight.w900),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              context.l10n.discardButtonLabel.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final l10n = context.l10n;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.deleteAccountDialogTitle,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        content: Text(
          l10n.deleteAccountDialogBody,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              l10n.deleteAccountCancelButtonLabel.toUpperCase(),
              style: const TextStyle(color: Colors.white38, fontWeight: FontWeight.w900),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              l10n.deleteAccountConfirmButtonLabel.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );

    if (context.mounted && result == true) {
      context.read<AccountActionsCubit>().deleteAccount();
    }
  }

  Future<void> _pickImage(BuildContext context, SessionState session) async {
    final userId = session.userIdOrNull;
    if (userId == null) return;

    final cubit = context.read<ProfileCubit>();
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      final extension = image.path.split('.').last.toLowerCase();
      
      cubit.saveProfilePhoto(
        userId: userId,
        bytes: bytes,
        extension: extension,
      );
    }
  }

  Future<void> _saveProfile(
    BuildContext context,
    SessionState session,
    String currentFirstName,
    String currentGarageName,
  ) async {
    final userId = session.userIdOrNull;
    if (userId == null) return;

    FocusScope.of(context).unfocus();

    final newFirstName = _firstNameController.text.trim();
    final newGarageName = _garageNameController.text.trim();

    final cubit = context.read<ProfileCubit>();
    final settingsCubit = context.read<SettingsCubit>();

    if (newFirstName != currentFirstName) {
      await cubit.saveFirstName(
        userId: userId,
        firstName: newFirstName,
      );
    }

    if (newGarageName != currentGarageName) {
      await cubit.saveGarageName(
        userId: userId,
        garageName: newGarageName,
      );
      // Also update settings cubit state so the garage background or other observers update
      settingsCubit.updateGarageName(userId, newGarageName);
    }
  }

  Future<void> _showChangePasswordDialog(BuildContext context) async {
    final l10n = context.l10n;
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    var obscurePassword = true;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return BlocProvider<AccountActionsCubit>.value(
          value: context.read<AccountActionsCubit>(),
          child: StatefulBuilder(
            builder: (context, setState) {
              return BlocConsumer<AccountActionsCubit, AccountActionsState>(
                listenWhen: (prev, curr) =>
                    prev.successKey != curr.successKey ||
                    prev.errorKey != curr.errorKey,
                listener: (context, state) {
                  if (state.successKey == 'password_changed') {
                    Navigator.of(context).pop();
                  }
                },
                builder: (context, state) {
                  final isLoading =
                      state.activeAction == AccountAction.changePassword;

                  return AlertDialog(
                    backgroundColor: const Color(0xFF1C1C1E),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    title: Text(
                      l10n.settingsChangePasswordLabel,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                    content: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: passwordController,
                            obscureText: obscurePassword,
                            enabled: !isLoading,
                            keyboardType: TextInputType.visiblePassword,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: l10n.passwordFieldLabel,
                              labelStyle: const TextStyle(color: Colors.white54),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white54,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                              ),
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
                            ),
                            validator: (val) {
                              if (val == null || val.trim().length < 6) {
                                return l10n.errorPassword;
                              }
                              return null;
                            },
                          ),
                          if (state.errorKey != null &&
                              state.activeAction == null) ...[
                            const SizedBox(height: 16),
                            SelectableText(
                              messageForErrorKey(l10n, state.errorKey),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed:
                            isLoading
                                ? null
                                : () => Navigator.of(context).pop(),
                        child: Text(
                          l10n.deleteAccountCancelButtonLabel.toUpperCase(),
                          style: const TextStyle(color: Colors.white38, fontWeight: FontWeight.w900),
                        ),
                      ),
                      FilledButton(
                        onPressed:
                            isLoading
                                ? null
                                : () {
                                    if (formKey.currentState?.validate() ??
                                        false) {
                                      context
                                          .read<AccountActionsCubit>()
                                          .changePassword(
                                            passwordController.text,
                                          );
                                    }
                                  },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD700),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child:
                            isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.black,
                                    ),
                                  )
                                : Text(
                                    l10n.carFormSaveButton.toUpperCase(),
                                    style: const TextStyle(fontWeight: FontWeight.w900),
                                  ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;

  const _ProfileTextField({
    required this.label,
    required this.icon,
    required this.controller,
    required this.focusNode,
    required this.enabled,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
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
          focusNode: focusNode,
          enabled: enabled,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          onChanged: onChanged,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
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
            disabledBorder: OutlineInputBorder(
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

class _AppLanguageDropdown extends StatelessWidget {
  const _AppLanguageDropdown({required this.isEnabled});

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<AppLocaleCubit, AppLocaleState>(
      builder: (context, state) {
        final isSelectionEnabled = isEnabled && !state.isSaving;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<AppLocaleOptionModel>(
              initialValue: state.selectedOption,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              dropdownColor: const Color(0xFF1C1C1E),
              decoration: InputDecoration(
                labelText: l10n.profileLanguageSectionTitle,
                labelStyle: const TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.w600),
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
              items: [
                DropdownMenuItem(
                  value: AppLocaleOptionModel.system,
                  child: Text(l10n.languageOptionSystem),
                ),
                DropdownMenuItem(
                  value: AppLocaleOptionModel.polish,
                  child: Text(l10n.languageOptionPolish),
                ),
                DropdownMenuItem(
                  value: AppLocaleOptionModel.english,
                  child: Text(l10n.languageOptionEnglish),
                ),
              ],
              onChanged: isSelectionEnabled
                  ? (option) {
                      if (option == null) return;
                      context.read<AppLocaleCubit>().selectLocale(option);
                      final userId = context.read<SessionCubit>().state.userIdOrNull;
                      if (userId != null) {
                        final appLanguage = option == AppLocaleOptionModel.polish
                            ? AppLanguage.pl
                            : AppLanguage.en;
                        context.read<SettingsCubit>().updateLanguage(userId, appLanguage);
                      }
                    }
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.profileLanguageSectionDescription,
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
            if (state.selectedOption == AppLocaleOptionModel.system) ...[
              const SizedBox(height: 4),
              Text(
                l10n.languageOptionSystemDescription,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
            if (state.errorKey != null) ...[
              const SizedBox(height: 8),
              SelectableText(
                messageForErrorKey(l10n, state.errorKey),
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        );
      },
    );
  }
}


class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary({required this.session});

  final SessionState session;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.sessionDisplayName(session),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            SelectableText(l10n.sessionUserId(session.userIdOrNull ?? '-')),
            const SizedBox(height: 8),
            SelectableText(l10n.sessionEmail(session.emailOrNull ?? '-')),
            const SizedBox(height: 8),
            SelectableText(l10n.sessionPlan(context.tierLabel(session.tier))),
          ],
        ),
      ),
    );
  }
}

class _ProtectProBanner extends StatelessWidget {
  const _ProtectProBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.protectProBannerTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.protectProBannerBody,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
