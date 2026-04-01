// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:myapp/app/profile/presentation/cubit/account_actions_cubit.dart'
    as _i89;
import 'package:myapp/app/session/data/repositories/session_repository.dart'
    as _i667;
import 'package:myapp/app/session/presentation/cubit/session_cubit.dart' as _i9;
import 'package:myapp/core/di/app_module.dart' as _i583;
import 'package:myapp/features/auth/data/datasources/auth_data_source.dart'
    as _i725;
import 'package:myapp/features/auth/data/repositories/auth_repository.dart'
    as _i545;
import 'package:myapp/features/auth/presentation/cubit/login_cubit.dart'
    as _i318;
import 'package:myapp/features/auth/presentation/cubit/register_cubit.dart'
    as _i200;
import 'package:myapp/features/auth/presentation/cubit/welcome_cubit.dart'
    as _i818;
import 'package:myapp/features/profiles/data/datasources/shared_user_data_source.dart'
    as _i217;
import 'package:myapp/features/profiles/data/repositories/shared_user_repository.dart'
    as _i184;
import 'package:myapp/features/profiles/presentation/cubit/profile_cubit.dart'
    as _i872;
import 'package:myapp/features/subscription/data/datasources/subscription_data_source.dart'
    as _i757;
import 'package:myapp/features/subscription/data/repositories/subscription_repository.dart'
    as _i1047;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.lazySingleton<_i454.SupabaseClient>(() => appModule.supabaseClient);
    gh.lazySingleton<_i757.SubscriptionDataSource>(
      () => _i757.FakeSubscriptionDataSource(),
    );
    gh.lazySingleton<_i725.AuthDataSource>(
      () => _i725.SupabaseAuthDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i1047.SubscriptionRepository>(
      () =>
          _i1047.SubscriptionRepositoryImpl(gh<_i757.SubscriptionDataSource>()),
    );
    gh.lazySingleton<_i217.SharedUserDataSource>(
      () => _i217.SupabaseSharedUserDataSource(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i545.AuthRepository>(
      () => _i545.AuthRepositoryImpl(gh<_i725.AuthDataSource>()),
    );
    gh.factory<_i89.AccountActionsCubit>(
      () => _i89.AccountActionsCubit(
        gh<_i545.AuthRepository>(),
        gh<_i1047.SubscriptionRepository>(),
      ),
    );
    gh.lazySingleton<_i184.SharedUserRepository>(
      () => _i184.SharedUserRepositoryImpl(gh<_i217.SharedUserDataSource>()),
    );
    gh.factory<_i318.LoginCubit>(
      () => _i318.LoginCubit(gh<_i545.AuthRepository>()),
    );
    gh.factory<_i200.RegisterCubit>(
      () => _i200.RegisterCubit(gh<_i545.AuthRepository>()),
    );
    gh.factory<_i818.WelcomeCubit>(
      () => _i818.WelcomeCubit(gh<_i545.AuthRepository>()),
    );
    gh.factory<_i872.ProfileCubit>(
      () => _i872.ProfileCubit(gh<_i184.SharedUserRepository>()),
    );
    gh.lazySingleton<_i667.SessionRepository>(
      () => _i667.SessionRepositoryImpl(
        gh<_i545.AuthRepository>(),
        gh<_i184.SharedUserRepository>(),
        gh<_i1047.SubscriptionRepository>(),
      ),
    );
    gh.lazySingleton<_i9.SessionCubit>(
      () => _i9.SessionCubit(gh<_i667.SessionRepository>()),
    );
    return this;
  }
}

class _$AppModule extends _i583.AppModule {}
