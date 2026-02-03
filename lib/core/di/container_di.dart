
import 'package:get_it/get_it.dart';
import 'package:nortus/core/router/app_notifier.dart';
import 'package:nortus/presentation/cubits/auth/auth_cubit.dart';

class ContainerDi {
  final getIt = GetIt.instance;
  
  void setup() {
    getIt.registerLazySingleton<AuthCubit>(() => AuthCubit());
    getIt.registerLazySingleton<RouterNotifier>(() => RouterNotifier(getIt<AuthCubit>()));
  }
  
}