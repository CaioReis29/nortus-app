import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:nortus/core/router/app_notifier.dart';
import 'package:nortus/core/network/http_client.dart';
import 'package:nortus/data/datasources/auth_local_datasource.dart';
import 'package:nortus/data/datasources/auth_remote_datasource.dart';
import 'package:nortus/data/repositories/auth_repository_impl.dart';
import 'package:nortus/domain/repositories/auth_repository.dart';
import 'package:nortus/presentation/cubits/auth/auth_cubit.dart';
import 'package:nortus/domain/usecases/auth/login_usecase.dart';
import 'package:nortus/domain/usecases/auth/logout_usecase.dart';
import 'package:nortus/domain/usecases/auth/check_session_usecase.dart';

class ContainerDi {
  final getIt = GetIt.instance;

  void setup() {
    getIt.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: 'https://flutter-challenge.wiremockapi.cloud',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      ),
    );
    getIt.registerLazySingleton<HttpClient>(() => HttpClient(getIt<Dio>()));
      getIt.registerLazySingleton<AuthRemoteDatasource>(
        () => AuthRemoteDatasource(getIt<HttpClient>()),
      );
    getIt.registerLazySingleton<AuthLocalDatasource>(
      () => AuthLocalDatasource(),
    );
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remote: getIt<AuthRemoteDatasource>(),
        local: getIt<AuthLocalDatasource>(),
      ),
    );

    // Use cases
    getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
    getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
    getIt.registerLazySingleton(() => CheckSessionUseCase(getIt<AuthRepository>()));

    // Cubit
    getIt.registerLazySingleton<AuthCubit>(
      () => AuthCubit(
        loginUseCase: getIt<LoginUseCase>(),
        logoutUseCase: getIt<LogoutUseCase>(),
        checkSessionUseCase: getIt<CheckSessionUseCase>(),
      ),
    );

    getIt.registerLazySingleton<RouterNotifier>(
      () => RouterNotifier(getIt<AuthCubit>()),
    );
  }
}
