import 'package:flutter/material.dart';
import 'package:nortus/core/theme/app_colors.dart';
import 'package:nortus/presentation/components/auth/auth_mode.dart';

class AuthModeSwitch extends StatelessWidget {
  final AuthMode mode;
  final ValueChanged<AuthMode> onChanged;
  const AuthModeSwitch({super.key, required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final bool isLogin = mode == AuthMode.login;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(AuthMode.login),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: isLogin ? AppColors.buttonColor : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Acessar conta',
                  style: TextStyle(
                    color: isLogin ? Colors.white : AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(AuthMode.cadastro),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: !isLogin ? AppColors.buttonColor : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Não tenho conta',
                  style: TextStyle(
                    color: !isLogin ? Colors.white : AppColors.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
