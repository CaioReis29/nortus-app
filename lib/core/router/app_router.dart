import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:nortus/core/router/app_notifier.dart';
import 'package:nortus/core/router/app_paths.dart';
import 'package:nortus/presentation/cubits/auth/auth_cubit.dart';
import 'package:nortus/presentation/screens/auth/auth_page.dart';
import 'package:nortus/presentation/screens/home/home_pager_page.dart';
import 'package:nortus/presentation/screens/profile/profile_page.dart';
import 'package:nortus/presentation/screens/splash/splash_page.dart';

final getIt = GetIt.instance;

class AppRouter {
  static GoRouter router() {
    final routerNotifier = getIt<RouterNotifier>();
    return GoRouter(
      initialLocation: RoutePaths.splash,
      refreshListenable: routerNotifier,
      redirect: (context, state) {
        final authState = getIt<AuthCubit>().state;

        final isLoggedIn = authState is AuthAuthenticated;
        final isLoggingIn = state.matchedLocation == RoutePaths.auth;
        final isSplash = state.matchedLocation == RoutePaths.splash;

        if (isSplash) return null;

        if (!isLoggedIn && !isLoggingIn) {
          return RoutePaths.auth;
        }

        if (isLoggedIn && isLoggingIn) {
          return RoutePaths.news;
        }

        return null;
      },

      routes: [
        GoRoute(
          path: RoutePaths.splash,
          builder: (_, __) => const SplashPage(),
        ),
        GoRoute(
          path: RoutePaths.auth,
          builder: (_, __) => const AuthPage(),
        ),
        GoRoute(
          path: RoutePaths.news,
          builder: (_, __) => const HomePagerPage(),
        ),
        GoRoute(
          path: RoutePaths.profile,
          builder: (_, __) => const ProfilePage(),
        ),
      ],
    );
  }
}
