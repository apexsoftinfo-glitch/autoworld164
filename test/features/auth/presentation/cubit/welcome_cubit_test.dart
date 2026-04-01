import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/features/auth/presentation/cubit/welcome_cubit.dart';

import '../../../../support/mocks.dart';

void main() {
  late MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
  });

  blocTest<WelcomeCubit, WelcomeState>(
    'emits loading then idle when continueAsGuest succeeds',
    build: () {
      when(() => authRepository.continueAsGuest()).thenAnswer((_) async {});
      return WelcomeCubit(authRepository);
    },
    act: (cubit) => cubit.continueAsGuest(),
    expect: () => [
      const WelcomeState.initial(isLoading: true),
      const WelcomeState.initial(isLoading: false),
    ],
  );

  blocTest<WelcomeCubit, WelcomeState>(
    'emits error key when continueAsGuest fails',
    build: () {
      when(
        () => authRepository.continueAsGuest(),
      ).thenThrow(Exception('anonymous sign-ins are disabled'));
      return WelcomeCubit(authRepository);
    },
    act: (cubit) => cubit.continueAsGuest(),
    expect: () => [
      const WelcomeState.initial(isLoading: true),
      const WelcomeState.initial(
        isLoading: false,
        errorKey: 'anonymous_auth_disabled',
      ),
    ],
  );
}
