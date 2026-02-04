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

  void _emitError(String message) {
    emit(const AuthInitial());
    emit(AuthError(message));
  }

  Future<void> login(String login, String password, {bool keepConnected = false}) async {
    if (!_isValidEmail(login)) {
      _emitError('E-mail inválido');
      return;
    }
    if (!_isValidPassword(password)) {
      _emitError('Senha deve ter pelo menos 6 caracteres');
      return;
    }
    emit(const AuthLoading());
    final Result<AuthResult, Failure> result =
      await loginUseCase(login: login, password: password, keepConnected: keepConnected);
    result.open(
      (auth) {
        final ok = auth?.isAuthenticated ?? false;
        emit(ok ? const AuthAuthenticated() : const AuthError('Invalid credentials'));
      },
      (err) {
        _emitError(err?.message ?? 'Authentication failed');
      },
    );
  }

  Future<void> signUp(String email, String password, String confirm) async {
    if (!_isValidEmail(email)) {
      _emitError('E-mail inválido');
      return;
    }
    if (!_isValidPassword(password)) {
      _emitError('Senha deve ter pelo menos 6 caracteres');
      return;
    }
    if (confirm != password) {
      _emitError('Senhas não coincidem');
      return;
    }
    emit(const AuthLoading());
    _emitError('Cadastro não implementado ainda');
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

  bool _isValidEmail(String email) {
    final hasAt = email.contains('@');
    final hasDot = email.contains('.');
    return hasAt && hasDot && email.isNotEmpty;
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }
}