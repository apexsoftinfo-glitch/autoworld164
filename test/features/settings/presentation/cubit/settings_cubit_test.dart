import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:autoworld164/features/settings/presentation/settings_cubit.dart';
import 'package:autoworld164/features/settings/models/settings_model.dart';
import 'package:autoworld164/features/profiles/models/shared_user_model.dart';
import 'package:autoworld164/features/auth/models/auth_principal_model.dart';

import '../../../../support/mocks.dart';

class FakeDateTime extends Fake implements DateTime {}

void main() {
  late MockSettingsRepository settingsRepository;
  late MockSharedUserRepository sharedUserRepository;
  late MockAuthRepository authRepository;
  late MockCarsRepository carsRepository;

  setUpAll(() {
    registerFallbackValue(FakeDateTime());
  });

  setUp(() {
    settingsRepository = MockSettingsRepository();
    sharedUserRepository = MockSharedUserRepository();
    authRepository = MockAuthRepository();
    carsRepository = MockCarsRepository();
  });

  group('SettingsCubit', () {
    const userId = 'user123';
    final mockSettings = SettingsModel(
      id: userId,
      currency: AppCurrency.usd,
      language: AppLanguage.en,
      garageBackground: 'assets/bg.png',
    );
    final mockProfile = SharedUserModel(id: userId, firstName: 'John');

    blocTest<SettingsCubit, SettingsState>(
      'emits Loading then Data (twice - with null profile then with John) when init is successful',
      build: () {
        when(() => settingsRepository.watchSettings(userId))
            .thenAnswer((_) => Stream.value(mockSettings));
        when(() => sharedUserRepository.watchSharedUser(userId))
            .thenAnswer((_) => Stream.value(mockProfile));
        when(() => authRepository.watchPrincipal())
            .thenAnswer((_) => Stream.value(const AuthPrincipalModel(userId: userId, isAnonymous: false, email: 'test@example.com')));
        when(() => authRepository.currentPrincipal)
            .thenReturn(const AuthPrincipalModel(userId: userId, isAnonymous: false, email: 'test@example.com'));
        
        return SettingsCubit(
          settingsRepository,
          sharedUserRepository,
          authRepository,
          carsRepository,
        );
      },
      act: (cubit) => cubit.init(userId),
      expect: () => [
        const SettingsState.loading(),
        SettingsState.data(
          settings: mockSettings,
          profile: null,
          isGuest: false,
        ),
        SettingsState.data(
          settings: mockSettings,
          profile: mockProfile,
          isGuest: false,
        ),
      ],
    );

    blocTest<SettingsCubit, SettingsState>(
      'exportBackup emits exporting status and success',
      build: () {
        when(() => settingsRepository.watchSettings(userId))
            .thenAnswer((_) => Stream.value(mockSettings));
        when(() => sharedUserRepository.watchSharedUser(userId))
            .thenAnswer((_) => Stream.value(mockProfile));
        when(() => authRepository.watchPrincipal())
            .thenAnswer((_) => Stream.value(const AuthPrincipalModel(userId: userId, isAnonymous: false, email: 'test@example.com')));
        when(() => authRepository.currentPrincipal)
            .thenReturn(const AuthPrincipalModel(userId: userId, isAnonymous: false, email: 'test@example.com'));
            
        when(() => settingsRepository.exportBackup())
            .thenAnswer((_) async => 'path/to/backup.zip');
        when(() => settingsRepository.updateLastBackupAt(userId, any()))
            .thenAnswer((_) async {});

        return SettingsCubit(
          settingsRepository,
          sharedUserRepository,
          authRepository,
          carsRepository,
        );
      },
      act: (cubit) async {
        cubit.init(userId);
        await Future.delayed(Duration.zero); // Let init finish its emissions
        await cubit.exportBackup(userId);
      },
      skip: 1, // Skip Loading. Next is Data(profile: null)
      expect: () => [
        SettingsState.data(
          settings: mockSettings,
          profile: null,
          isGuest: false,
        ),
        SettingsState.data(
          settings: mockSettings,
          profile: mockProfile,
          isGuest: false,
        ),
        SettingsState.data(
          settings: mockSettings,
          profile: mockProfile,
          isGuest: false,
          isExporting: true,
        ),
        SettingsState.data(
          settings: mockSettings,
          profile: mockProfile,
          isGuest: false,
          isExporting: false,
        ),
        const SettingsState.success(messageKey: 'backup_created_successfully'),
        SettingsState.data(
          settings: mockSettings,
          profile: mockProfile,
          isGuest: false,
          isExporting: false,
        ),
      ],
    );
  });
}
