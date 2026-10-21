// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/example/bloc/example_detail_bloc.dart' as _i719;
import '../../features/example/cubit/example_cubit.dart' as _i256;
import '../../features/example/data/datasources/item_remote_data_source.dart'
    as _i205;
import '../../features/example/data/repositories/i_item_repository.dart'
    as _i224;
import '../../features/example/data/repositories/item_repository_impl.dart'
    as _i187;
import '../cubit/app_settings_cubit.dart' as _i30;
import '../cubit/connectivity_cubit.dart' as _i948;
import '../network/auth_interceptor.dart' as _i908;
import '../network/dio_client.dart' as _i667;
import '../network/token_provider.dart' as _i853;
import '../observability/analytics_service.dart' as _i207;
import '../observability/crash_reporter.dart' as _i72;
import '../observability/force_update_gate.dart' as _i1050;
import '../observability/remote_config_service.dart' as _i939;
import '../services/connectivity_service.dart' as _i47;
import '../storage/prefs_service.dart' as _i415;
import '../storage/secure_storage_service.dart' as _i666;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final prefsModule = _$PrefsModule();
    final dioModule = _$DioModule();
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => prefsModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i666.SecureStorageService>(
      () => _i666.SecureStorageService(),
    );
    gh.lazySingleton<_i207.IAnalyticsService>(
      () => _i207.NoOpAnalyticsService(),
    );
    gh.lazySingleton<_i47.IConnectivityService>(
      () => _i47.ConnectivityService(),
    );
    gh.lazySingleton<_i72.ICrashReporter>(() => _i72.NoOpCrashReporter());
    gh.lazySingleton<_i939.IRemoteConfigService>(
      () => _i939.NoOpRemoteConfigService(),
    );
    gh.lazySingleton<_i853.TokenProvider>(() => _i853.NoOpTokenProvider());
    gh.lazySingleton<_i948.ConnectivityCubit>(
      () => _i948.ConnectivityCubit(gh<_i47.IConnectivityService>()),
    );
    gh.lazySingleton<_i415.PrefsService>(
      () => _i415.PrefsService(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i1050.ForceUpdateGate>(
      () => _i1050.ForceUpdateGate(gh<_i939.IRemoteConfigService>()),
    );
    gh.lazySingleton<_i30.AppSettingsCubit>(
      () => _i30.AppSettingsCubit(gh<_i415.PrefsService>()),
    );
    gh.lazySingleton<_i908.AuthInterceptor>(
      () => _i908.AuthInterceptor(gh<_i853.TokenProvider>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => dioModule.dio(gh<_i908.AuthInterceptor>()),
    );
    gh.lazySingleton<_i205.IItemRemoteDataSource>(
      () => _i205.ItemRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i224.IItemRepository>(
      () => _i187.ItemRepositoryImpl(gh<_i205.IItemRemoteDataSource>()),
    );
    gh.factory<_i719.ExampleDetailBloc>(
      () => _i719.ExampleDetailBloc(gh<_i224.IItemRepository>()),
    );
    gh.factory<_i256.ExampleCubit>(
      () => _i256.ExampleCubit(gh<_i224.IItemRepository>()),
    );
    return this;
  }
}

class _$PrefsModule extends _i415.PrefsModule {}

class _$DioModule extends _i667.DioModule {}
