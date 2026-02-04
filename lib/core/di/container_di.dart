import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:nortus/core/consntants/api_urls.dart';
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
import 'package:nortus/core/network/connectivity_service.dart';
import 'package:nortus/core/storage/favorites_service.dart';
import 'package:nortus/domain/repositories/favorites_repository.dart';
import 'package:nortus/data/repositories/favorites_repository_impl.dart';
import 'package:nortus/domain/usecases/favorites/get_favorites_usecase.dart';
import 'package:nortus/domain/usecases/favorites/toggle_favorite_news_usecase.dart';
import 'package:nortus/domain/usecases/favorites/watch_favorites_usecase.dart';
import 'package:nortus/data/datasources/news_remote_datasource.dart';
import 'package:nortus/domain/repositories/news_repository.dart';
import 'package:nortus/data/repositories/news_repository_impl.dart';
import 'package:nortus/domain/usecases/news/get_news_page_usecase.dart';
import 'package:nortus/presentation/cubits/news/news_cubit.dart';

class ContainerDi {
  final getIt = GetIt.instance;

  void setup() {
    getIt.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: ApiUrls.baseUrl,
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
    getIt.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remote: getIt<AuthRemoteDatasource>(),
        local: getIt<AuthLocalDatasource>(),
        connectivity: getIt<ConnectivityService>(),
      ),
    );

    getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
    getIt.registerLazySingleton(() => LogoutUseCase(getIt<AuthRepository>()));
    getIt.registerLazySingleton(() => CheckSessionUseCase(getIt<AuthRepository>()));

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

    getIt.registerLazySingleton<NewsRemoteDatasource>(
      () => NewsRemoteDatasource(getIt<HttpClient>()),
    );
    getIt.registerLazySingleton<NewsRepository>(
      () => NewsRepositoryImpl(getIt<NewsRemoteDatasource>()),
    );
    getIt.registerLazySingleton(() => GetNewsPageUseCase(getIt<NewsRepository>()));
    getIt.registerLazySingleton<NewsCubit>(() => NewsCubit(getIt<GetNewsPageUseCase>()));
    getIt.registerLazySingleton<FavoritesService>(() => FavoritesService());
    getIt.registerLazySingleton<FavoritesRepository>(() => FavoritesRepositoryImpl(getIt<FavoritesService>()));
    getIt.registerLazySingleton(() => GetFavoritesUseCase(getIt<FavoritesRepository>()));
    getIt.registerLazySingleton(() => ToggleFavoriteNewsUseCase(getIt<FavoritesRepository>()));
    getIt.registerLazySingleton(() => WatchFavoritesUseCase(getIt<FavoritesRepository>()));
  }
}
