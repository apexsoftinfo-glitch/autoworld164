import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/error_messages.dart';
import '../../data/repositories/auth_repository.dart';

part 'welcome_cubit.freezed.dart';

@freezed
sealed class WelcomeState with _$WelcomeState {
  const factory WelcomeState.initial({
    @Default(false) bool isLoading,
    String? errorKey,
  }) = WelcomeStateData;
}

@injectable
class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit(this._authRepository) : super(const WelcomeState.initial());

  final AuthRepository _authRepository;

  Future<void> continueAsGuest() async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true, errorKey: null));

    try {
      await _authRepository.continueAsGuest();
      emit(state.copyWith(isLoading: false));
    } catch (error) {
      debugPrint('❌ [WelcomeCubit] continueAsGuest error: $error');
      emit(state.copyWith(isLoading: false, errorKey: mapErrorToKey(error)));
    }
  }
}
