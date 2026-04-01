import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../features/auth/data/repositories/auth_repository.dart';
import '../../../../features/subscription/data/repositories/subscription_repository.dart';
import '../../../../shared/error_messages.dart';

part 'account_actions_cubit.freezed.dart';

enum AccountAction {
  signOut,
  deleteAccount,
  buyPro,
  developerProOverride,
}

@freezed
sealed class AccountActionsState with _$AccountActionsState {
  const factory AccountActionsState.initial({
    AccountAction? activeAction,
    String? errorKey,
    String? successKey,
  }) = AccountActionsStateData;
}

@injectable
class AccountActionsCubit extends Cubit<AccountActionsState> {
  AccountActionsCubit(this._authRepository, this._subscriptionRepository)
    : super(const AccountActionsState.initial());

  final AuthRepository _authRepository;
  final SubscriptionRepository _subscriptionRepository;

  Future<void> signOut() async {
    if (state.activeAction != null) return;

    emit(
      state.copyWith(
        activeAction: AccountAction.signOut,
        errorKey: null,
        successKey: null,
      ),
    );

    try {
      await _authRepository.signOut();
      emit(state.copyWith(activeAction: null, successKey: 'signed_out'));
    } catch (error) {
      debugPrint('❌ [AccountActionsCubit] signOut error: $error');
      emit(state.copyWith(activeAction: null, errorKey: mapErrorToKey(error)));
    }
  }

  Future<void> deleteAccount() async {
    if (state.activeAction != null) return;

    emit(
      state.copyWith(
        activeAction: AccountAction.deleteAccount,
        errorKey: null,
        successKey: null,
      ),
    );

    try {
      await _authRepository.deleteAccount();
      await _authRepository.signOut();
      emit(state.copyWith(activeAction: null, successKey: 'account_deleted'));
    } catch (error) {
      debugPrint('❌ [AccountActionsCubit] deleteAccount error: $error');
      emit(state.copyWith(activeAction: null, errorKey: mapErrorToKey(error)));
    }
  }

  Future<void> buyPro(String userId) async {
    if (state.activeAction != null) return;

    emit(
      state.copyWith(
        activeAction: AccountAction.buyPro,
        errorKey: null,
        successKey: null,
      ),
    );

    try {
      await _subscriptionRepository.purchasePro(userId);
      emit(state.copyWith(activeAction: null, successKey: 'pro_enabled'));
    } catch (error) {
      debugPrint('❌ [AccountActionsCubit] buyPro error: $error');
      emit(state.copyWith(activeAction: null, errorKey: mapErrorToKey(error)));
    }
  }

  Future<void> setDeveloperProOverride({
    required String userId,
    required bool isPro,
  }) async {
    if (state.activeAction != null) return;

    emit(
      state.copyWith(
        activeAction: AccountAction.developerProOverride,
        errorKey: null,
        successKey: null,
      ),
    );

    try {
      await _subscriptionRepository.setDeveloperProOverride(
        userId: userId,
        isPro: isPro,
      );
      emit(
        state.copyWith(
          activeAction: null,
          successKey: isPro ? 'pro_enabled' : 'pro_disabled',
        ),
      );
    } catch (error) {
      debugPrint(
        '❌ [AccountActionsCubit] setDeveloperProOverride error: $error',
      );
      emit(state.copyWith(activeAction: null, errorKey: mapErrorToKey(error)));
    }
  }

  void clearFeedback() {
    if (state.errorKey == null && state.successKey == null) return;
    emit(state.copyWith(errorKey: null, successKey: null));
  }
}
