import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_result/flutter_result.dart';
import 'package:nortus/core/exceptions/app_exception.dart';
import 'package:nortus/domain/entities/auth_result.dart';
import 'package:nortus/domain/usecases/auth/login_usecase.dart';
import 'package:nortus/domain/usecases/auth/logout_usecase.dart';
import 'package:nortus/domain/usecases/auth/check_session_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckSessionUseCase checkSessionUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.checkSessionUseCase,
  }) : super(const AuthInitial());

  Future<void> login(String login, String password) async {
    emit(const AuthLoading());
    final Result<AuthResult, AppException> result =
        await loginUseCase(login: login, password: password);
    result.open(
      (auth) {
        final ok = auth?.isAuthenticated ?? false;
        emit(ok ? const AuthAuthenticated() : const AuthError('Invalid credentials'));
      },
      (err) {
        emit(AuthError(err?.message ?? 'Authentication failed'));
      },
    );
  }

  Future<void> logout() async {
    final res = await logoutUseCase();
    res.open(
      (_) => emit(const AuthUnauthenticated()),
      (err) => emit(AuthError(err?.message ?? 'Logout failed')),
    );
  }

  Future<void> checkSession() async {
    final res = await checkSessionUseCase();
    res.open(
      (logged) => emit((logged ?? false) ? const AuthAuthenticated() : const AuthUnauthenticated()),
      (err) => emit(const AuthInitial()),
    );
  }
}