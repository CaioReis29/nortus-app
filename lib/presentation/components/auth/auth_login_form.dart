import 'package:flutter/material.dart';
import 'package:nortus/core/theme/app_colors.dart';
import 'package:nortus/presentation/components/common/app_text_field.dart';
import 'package:nortus/presentation/components/common/app_button.dart';

class AuthLoginForm extends StatefulWidget {
  final void Function(String email, String password, bool keepConnected) onSubmit;
  final bool isLoading;
  const AuthLoginForm({super.key, required this.onSubmit, this.isLoading = false});

  @override
  State<AuthLoginForm> createState() => _AuthLoginFormState();
}

class _AuthLoginFormState extends State<AuthLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _keepConnected = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  void _submit() {
    widget.onSubmit(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _keepConnected,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _emailController,
            label: 'E-mail',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          AppTextField(
            controller: _passwordController,
            label: 'Senha',
            isPassword: true,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                activeColor: AppColors.primaryColor,
                value: _keepConnected,
                onChanged: (v) => setState(() => _keepConnected = v ?? false),
              ),
              const SizedBox(width: 4),
              const Text('Mantenha-me conectado'),
            ],
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Entrar',
            isLoading: widget.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
