// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:autoworld164/app/locale/data/datasources/app_locale_data_source.dart'
    as _i953;
import 'package:autoworld164/app/locale/data/repositories/app_locale_repository.dart'
    as _i186;
import 'package:autoworld164/app/locale/presentation/cubit/app_locale_cubit.dart'
    as _i1011;
import 'package:autoworld164/app/profile/presentation/cubit/account_actions_cubit.dart'
    as _i492;
import 'package:autoworld164/app/session/data/repositories/session_repository.dart'
    as _i769;
import 'package:autoworld164/app/session/presentation/cubit/session_cubit.dart'
    as _i161;
import 'package:autoworld164/core/di/app_module.dart' as _i68;
import 'package:autoworld164/core/services/translation_service.dart' as _i80;
import 'package:autoworld164/features/auth/data/datasources/auth_data_source.dart'
    as _i683;
import 'package:autoworld164/features/auth/data/repositories/auth_repository.dart'
    as _i31;
import 'package:autoworld164/features/auth/presentation/cubit/login_cubit.dart'
    as _i91;
import 'package:autoworld164/features/auth/presentation/cubit/register_cubit.dart'
    as _i122;
import 'package:autoworld164/features/auth/presentation/cubit/welcome_cubit.dart'
    as _i948;
import 'package:autoworld164/features/garage/data/data_sources/cars_data_source.dart'
    as _i482;
import 'package:autoworld164/features/garage/data/repositories/cars_repository.dart'
    as _i421;
import 'package:autoworld164/features/garage/presentation/cubit/car_form_cubit.dart'
    as _i158;
import 'package:autoworld164/features/garage/presentation/cubit/cars_collection_cubit.dart'
    as _i615;
import 'package:autoworld164/features/garage/presentation/cubit/search_photos_cubit.dart'
    as _i1018;
import 'package:autoworld164/features/hunting/data/repositories/hunting_repository.dart'
    as _i813;
import 'package:autoworld164/features/hunting/presentation/cubit/hunting_cubit.dart'
    as _i328;
import 'package:autoworld164/features/news/data/news_repository.dart' as _i225;
import 'package:autoworld164/features/news/presentation/news_cubit.dart'
    as _i537;
import 'package:autoworld164/features/profiles/data/datasources/shared_user_data_source.dart'
    as _i956;
import 'package:autoworld164/features/profiles/data/repositories/shared_user_repository.dart'
    as _i832;
import 'package:autoworld164/features/profiles/presentation/cubit/profile_cubit.dart'
    as _i146;
import 'package:autoworld164/features/settings/data/datasources/settings_data_source.dart'
    as _i1022;
import 'package:autoworld164/features/settings/data/repositories/settings_repository.dart'
    as _i173;
import 'package:autoworld164/features/settings/presentation/settings_cubit.dart'
    as _i496;
import 'package:autoworld164/features/subscription/data/datasources/subscription_data_source.dart'
    as _i604;
import 'package:autoworld164/features/subscription/data/repositories/subscription_repository.dart'
    as _i461;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.sharedPreferences,
      preResolve: true,
    );
    gh.lazySingleton<_i454.SupabaseClient>(() => appModule.supabaseClient);
    gh.lazySingleton<_i80.TranslationService>(() => _i80.TranslationService());
    gh.lazySingleton<_i813.HuntingRepository>(
      () => _i813.HuntingRepositoryImpl(),
    );
    gh.lazySingleton<_i604.SubscriptionDataSource>(
      () => _i604.FakeSubscriptionDataSource(),
    );
    gh.lazySingleton<_i461.SubscriptionRepository>(
      () =>
          _i461.SubscriptionRepositoryImpl(gh<_i604.SubscriptionDataSource>()),
    );
    gh.factory<_i328.HuntingCubit>(
      () => _i328.HuntingCubit(gh<_i813.HuntingRepository>()),
    );
    gh.lazySingleton<_i482.CarsDataSource>(
      () => _i482.CarsDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i421.CarsRepository>(
      () => _i421.CarsRepositoryImpl(gh<_i482.CarsDataSource>()),
    );
    gh.factory<_i1018.SearchPhotosCubit>(
      () => _i1018.SearchPhotosCubit(gh<_i421.CarsRepository>()),
    );
    gh.lazySingleton<_i953.AppLocaleDataSource>(
      () => _i953.SharedPreferencesAppLocaleDataSource(
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i1022.SettingsDataSource>(
      () => _i1022.SupabaseSettingsDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.factory<_i158.CarFormCubit>(
      () => _i158.CarFormCubit(gh<_i421.CarsRepository>()),
    );
    gh.factory<_i615.CarsCollectionCubit>(
      () => _i615.CarsCollectionCubit(gh<_i421.CarsRepository>()),
    );
    gh.lazySingleton<_i956.SharedUserDataSource>(
      () => _i956.SupabaseSharedUserDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i683.AuthDataSource>(
      () => _i683.SupabaseAuthDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i225.NewsDataSource>(
      () => _i225.NewsDataSourceImpl(gh<_i80.TranslationService>()),
    );
    gh.lazySingleton<_i31.AuthRepository>(
      () => _i31.AuthRepositoryImpl(gh<_i683.AuthDataSource>()),
    );
    gh.factory<_i91.LoginCubit>(
      () => _i91.LoginCubit(gh<_i31.AuthRepository>()),
    );
    gh.factory<_i122.RegisterCubit>(
      () => _i122.RegisterCubit(gh<_i31.AuthRepository>()),
    );
    gh.factory<_i948.WelcomeCubit>(
      () => _i948.WelcomeCubit(gh<_i31.AuthRepository>()),
    );
    gh.factory<_i492.AccountActionsCubit>(
      () => _i492.AccountActionsCubit(
        gh<_i31.AuthRepository>(),
        gh<_i461.SubscriptionRepository>(),
      ),
    );
    gh.lazySingleton<_i173.SettingsRepository>(
      () => _i173.SettingsRepositoryImpl(gh<_i1022.SettingsDataSource>()),
    );
    gh.lazySingleton<_i225.NewsRepository>(
      () => _i225.NewsRepositoryImpl(gh<_i225.NewsDataSource>()),
    );
    gh.lazySingleton<_i186.AppLocaleRepository>(
      () => _i186.AppLocaleRepositoryImpl(gh<_i953.AppLocaleDataSource>()),
    );
    gh.factory<_i537.NewsCubit>(
      () => _i537.NewsCubit(gh<_i225.NewsRepository>()),
    );
    gh.lazySingleton<_i832.SharedUserRepository>(
      () => _i832.SharedUserRepositoryImpl(gh<_i956.SharedUserDataSource>()),
    );
    gh.lazySingleton<_i769.SessionRepository>(
      () => _i769.SessionRepositoryImpl(
        gh<_i31.AuthRepository>(),
        gh<_i832.SharedUserRepository>(),
        gh<_i461.SubscriptionRepository>(),
      ),
    );
    gh.lazySingleton<_i161.SessionCubit>(
      () => _i161.SessionCubit(gh<_i769.SessionRepository>()),
    );
    gh.lazySingleton<_i1011.AppLocaleCubit>(
      () => _i1011.AppLocaleCubit(gh<_i186.AppLocaleRepository>()),
    );
    gh.factory<_i146.ProfileCubit>(
      () => _i146.ProfileCubit(gh<_i832.SharedUserRepository>()),
    );
    gh.factory<_i496.SettingsCubit>(
      () => _i496.SettingsCubit(
        gh<_i173.SettingsRepository>(),
        gh<_i832.SharedUserRepository>(),
        gh<_i31.AuthRepository>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i68.AppModule {}
