import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/features/auth/presentation/cubit/register_cubit.dart';

import '../../../../support/mocks.dart';

void main() {
  late MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
  });

  blocTest<RegisterCubit, RegisterState>(
    'emits loading then idle when guest upgrade succeeds',
    build: () {
      when(
        () => authRepository.upgradeAnonymousWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});
      return RegisterCubit(authRepository);
    },
    act: (cubit) =>
        cubit.register(email: 'guest@example.com', password: 'secret123'),
    expect: () => [
      const RegisterState.initial(isLoading: true),
      const RegisterState.initial(isLoading: false),
    ],
  );

  blocTest<RegisterCubit, RegisterState>(
    'emits error when guest upgrade fails',
    build: () {
      when(
        () => authRepository.upgradeAnonymousWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception('email already in use'));
      return RegisterCubit(authRepository);
    },
    act: (cubit) =>
        cubit.register(email: 'guest@example.com', password: 'secret123'),
    expect: () => [
      const RegisterState.initial(isLoading: true),
      const RegisterState.initial(isLoading: false, errorKey: 'email_error'),
    ],
  );
}
