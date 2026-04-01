import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/app/profile/presentation/cubit/account_actions_cubit.dart';

import '../../../../support/mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockSubscriptionRepository subscriptionRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    subscriptionRepository = MockSubscriptionRepository();
  });

  blocTest<AccountActionsCubit, AccountActionsState>(
    'emits success when signOut succeeds',
    build: () {
      when(() => authRepository.signOut()).thenAnswer((_) async {});
      return AccountActionsCubit(authRepository, subscriptionRepository);
    },
    act: (cubit) => cubit.signOut(),
    expect: () => [
      const AccountActionsState.initial(activeAction: AccountAction.signOut),
      const AccountActionsState.initial(successKey: 'signed_out'),
    ],
  );

  blocTest<AccountActionsCubit, AccountActionsState>(
    'emits success when deleteAccount succeeds',
    build: () {
      when(() => authRepository.deleteAccount()).thenAnswer((_) async {});
      when(() => authRepository.signOut()).thenAnswer((_) async {});
      return AccountActionsCubit(authRepository, subscriptionRepository);
    },
    act: (cubit) => cubit.deleteAccount(),
    expect: () => [
      const AccountActionsState.initial(
        activeAction: AccountAction.deleteAccount,
      ),
      const AccountActionsState.initial(successKey: 'account_deleted'),
    ],
  );

  blocTest<AccountActionsCubit, AccountActionsState>(
    'emits error when deleteAccount fails',
    build: () {
      when(
        () => authRepository.deleteAccount(),
      ).thenThrow(StateError('delete_account_failed'));
      return AccountActionsCubit(authRepository, subscriptionRepository);
    },
    act: (cubit) => cubit.deleteAccount(),
    expect: () => [
      const AccountActionsState.initial(
        activeAction: AccountAction.deleteAccount,
      ),
      const AccountActionsState.initial(errorKey: 'delete_account_failed'),
    ],
  );

  blocTest<AccountActionsCubit, AccountActionsState>(
    'emits success when buyPro succeeds',
    build: () {
      when(
        () => subscriptionRepository.purchasePro(any()),
      ).thenAnswer((_) async {});
      return AccountActionsCubit(authRepository, subscriptionRepository);
    },
    act: (cubit) => cubit.buyPro('guest-1'),
    expect: () => [
      const AccountActionsState.initial(activeAction: AccountAction.buyPro),
      const AccountActionsState.initial(successKey: 'pro_enabled'),
    ],
  );

  blocTest<AccountActionsCubit, AccountActionsState>(
    'emits success when setDeveloperProOverride succeeds',
    build: () {
      when(
        () => subscriptionRepository.setDeveloperProOverride(
          userId: any(named: 'userId'),
          isPro: any(named: 'isPro'),
        ),
      ).thenAnswer((_) async {});
      return AccountActionsCubit(authRepository, subscriptionRepository);
    },
    act: (cubit) =>
        cubit.setDeveloperProOverride(userId: 'guest-1', isPro: false),
    expect: () => [
      const AccountActionsState.initial(
        activeAction: AccountAction.developerProOverride,
      ),
      const AccountActionsState.initial(successKey: 'pro_disabled'),
    ],
  );
}
