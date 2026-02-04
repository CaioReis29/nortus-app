import 'package:flutter/material.dart';
import 'package:nortus/core/router/app_router.dart';
import 'package:nortus/core/theme/app_colors.dart';
import 'package:nortus/presentation/components/auth/auth_blue_logo.dart';
import 'package:nortus/presentation/components/auth/auth_bottom_card.dart';
import 'package:nortus/presentation/components/auth/auth_grey_logo.dart';
import 'package:nortus/presentation/components/auth/auth_mode.dart';
import 'package:nortus/presentation/components/auth/auth_mode_switch.dart';
import 'package:nortus/presentation/components/auth/auth_login_form.dart';
import 'package:nortus/presentation/components/auth/auth_signup_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nortus/presentation/cubits/auth/auth_cubit.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthMode _mode = AuthMode.login;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final cardHeight = size.height * 0.4;
    final cardTop = size.height - cardHeight;
    final double greySize = size.height * 0.45;
    const double greyOverlap = 84;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocListener<AuthCubit, AuthState>(
          bloc: getIt<AuthCubit>(),
          listenWhen: (prev, curr) => curr is AuthError,
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.transparent)),
      
            AuthBlueLogo(top: cardTop - 284, left: 16),
      
            AuthGreyLogo(
              top: cardTop - greySize + greyOverlap,
              right: -(size.width * 0.25),
              size: greySize,
              opacity: 0.8,
            ),
      
            AuthBottomCard(
              height: cardHeight,
              color: AppColors.primaryColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
      
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: BlocBuilder<AuthCubit, AuthState>(
                        bloc: getIt<AuthCubit>(),
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: _mode == AuthMode.login
                                ? AuthLoginForm(
                                    isLoading: isLoading,
                                    onSubmit: (email, password, keepConnected) {
                                      getIt<AuthCubit>().login(
                                        email,
                                        password,
                                        keepConnected: keepConnected,
                                      );
                                    },
                                  )
                                : AuthSignUpForm(
                                    isLoading: isLoading,
                                    onSubmit: (email, password, confirm) {
                                      getIt<AuthCubit>().signUp(email, password, confirm);
                                    },
                                  ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
      
            Positioned(
              top: cardTop - 30,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 280,
                  child: AuthModeSwitch(
                    mode: _mode,
                    onChanged: (m) => setState(() => _mode = m),
                  ),
                ),
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}
