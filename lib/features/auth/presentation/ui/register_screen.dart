import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/session/presentation/cubit/session_cubit.dart';
import '../../../../core/di/injection.dart';
import '../../../../l10n/l10n.dart';
import '../../../../shared/error_messages.dart';
import '../cubit/register_cubit.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SessionCubit>.value(value: getIt<SessionCubit>()),
        BlocProvider<RegisterCubit>(create: (_) => getIt<RegisterCubit>()),
      ],
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<SessionCubit, SessionState>(
      listenWhen: (previous, current) =>
          previous.isAnonymousUser && !current.isAnonymousUser,
      listener: (context, state) {
        Navigator.of(context).pop(true);
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(title: Text(l10n.registerScreenTitle)),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      final isLoading = state.isLoading;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.secureGuestAccountTitle,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n.secureGuestAccountBody,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            enabled: !isLoading,
                            keyboardType: TextInputType.emailAddress,
                            textCapitalization: TextCapitalization.none,
                            autofillHints: const [AutofillHints.email],
                            decoration: InputDecoration(
                              labelText: l10n.emailFieldLabel,
                            ),
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) =>
                                _passwordFocusNode.requestFocus(),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            enabled: !isLoading,
                            keyboardType: TextInputType.visiblePassword,
                            textCapitalization: TextCapitalization.none,
                            autofillHints: const [AutofillHints.newPassword],
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: l10n.passwordFieldLabel,
                            ),
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _submit(context),
                          ),
                          if (state.errorKey != null) ...[
                            const SizedBox(height: 16),
                            SelectableText(
                              messageForErrorKey(l10n, state.errorKey),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          FilledButton(
                            onPressed: isLoading
                                ? null
                                : () => _submit(context),
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(l10n.registerButtonLabel),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<RegisterCubit>().register(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }
}
