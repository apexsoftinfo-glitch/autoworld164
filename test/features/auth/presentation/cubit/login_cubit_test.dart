import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myapp/features/auth/presentation/cubit/login_cubit.dart';

import '../../../../support/mocks.dart';

void main() {
  late MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
  });

  blocTest<LoginCubit, LoginState>(
    'emits loading then idle when login succeeds',
    build: () {
      when(
        () => authRepository.loginWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});
      return LoginCubit(authRepository);
    },
    act: (cubit) =>
        cubit.login(email: 'user@example.com', password: 'secret123'),
    expect: () => [
      const LoginState.initial(isLoading: true),
      const LoginState.initial(isLoading: false),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'emits invalid_credentials when login fails',
    build: () {
      when(
        () => authRepository.loginWithEmail(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(Exception('invalid login credentials'));
      return LoginCubit(authRepository);
    },
    act: (cubit) => cubit.login(email: 'user@example.com', password: 'wrong'),
    expect: () => [
      const LoginState.initial(isLoading: true),
      const LoginState.initial(
        isLoading: false,
        errorKey: 'invalid_credentials',
      ),
    ],
  );
}
