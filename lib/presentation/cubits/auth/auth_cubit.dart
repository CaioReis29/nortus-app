import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_result/flutter_result.dart';
import 'package:nortus/core/exceptions/app_exception.dart';
import 'package:nortus/domain/models/auth_result.dart';
import 'package:nortus/domain/usecases/auth/login_usecase.dart';
import 'package:nortus/domain/usecases/auth/logout_usecase.dart';
import 'package:nortus/domain/usecases/auth/check_session_usecase.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckSessionUseCase checkSessionUseCase;

  static const _msgInvalidEmail = 'E-mail inválido';
  static const _msgInvalidPassword = 'Senha deve ter pelo menos 6 caracteres';
  static const _msgPasswordsNotMatch = 'Senhas não coincidem';
  static const _msgAuthFailed = 'Falha na autenticação';
  static const _msgInvalidCredentials = 'Credenciais inválidas';
  static const _msgSignupNotImplemented = 'Cadastro não implementado ainda';
  static const _msgLogoutFailed = 'Falha ao sair';

  AuthCubit({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.checkSessionUseCase,
  }) : super(const AuthInitial());

  void _emitFailure(String message) {
    final token = DateTime.now().toIso8601String();
    emit(AuthError(message, token: token));
  }

  Future<void> login(String login, String password, {bool keepConnected = false}) async {
    if (state is AuthLoading) return;
    final trimmedLogin = login.trim();
    final trimmedPassword = password.trim();
    if (!_isValidEmail(trimmedLogin)) {
      _emitFailure(_msgInvalidEmail);
      return;
    }
    if (!_isValidPassword(trimmedPassword)) {
      _emitFailure(_msgInvalidPassword);
      return;
    }
    emit(const AuthLoading());
    final Result<AuthResult, Failure> result =
        await loginUseCase(login: trimmedLogin, password: trimmedPassword, keepConnected: keepConnected);
    result.open(
      (auth) {
        final ok = auth?.isAuthenticated ?? false;
        if (ok) {
          emit(const AuthAuthenticated());
        } else {
          _emitFailure(_msgInvalidCredentials);
        }
      },
      (err) {
        _emitFailure(err?.message ?? _msgAuthFailed);
      },
    );
  }

  Future<void> signUp(String email, String password, String confirm) async {
    if (state is AuthLoading) return;
    final e = email.trim();
    final p = password.trim();
    final c = confirm.trim();
    if (!_isValidEmail(e)) {
      _emitFailure(_msgInvalidEmail);
      return;
    }
    if (!_isValidPassword(p)) {
      _emitFailure(_msgInvalidPassword);
      return;
    }
    if (c != p) {
      _emitFailure(_msgPasswordsNotMatch);
      return;
    }
    emit(const AuthLoading());
    _emitFailure(_msgSignupNotImplemented);
  }

  Future<void> logout() async {
    final res = await logoutUseCase();
    res.open(
      (_) => emit(const AuthUnauthenticated()),
      (err) => _emitFailure(err?.message ?? _msgLogoutFailed),
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