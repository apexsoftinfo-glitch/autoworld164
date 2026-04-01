import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/error_messages.dart';
import '../../data/repositories/auth_repository.dart';

part 'register_cubit.freezed.dart';

@freezed
sealed class RegisterState with _$RegisterState {
  const factory RegisterState.initial({
    @Default(false) bool isLoading,
    String? errorKey,
  }) = RegisterStateData;
}

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._authRepository) : super(const RegisterState.initial());

  final AuthRepository _authRepository;

  Future<void> register({
    required String email,
    required String password,
  }) async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true, errorKey: null));

    try {
      await _authRepository.upgradeAnonymousWithEmail(
        email: email.trim(),
        password: password,
      );
      emit(state.copyWith(isLoading: false));
    } catch (error) {
      debugPrint('❌ [RegisterCubit] register error: $error');
      emit(state.copyWith(isLoading: false, errorKey: mapErrorToKey(error)));
    }
  }
}
