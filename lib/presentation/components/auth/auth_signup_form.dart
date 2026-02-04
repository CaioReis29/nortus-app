import 'package:flutter/material.dart';
import 'package:nortus/presentation/components/common/app_text_field.dart';
import 'package:nortus/presentation/components/common/app_button.dart';

class AuthSignUpForm extends StatefulWidget {
  final void Function(String email, String password, String confirm) onSubmit;
  final bool isLoading;
  const AuthSignUpForm({super.key, required this.onSubmit, this.isLoading = false});

  @override
  State<AuthSignUpForm> createState() => _AuthSignUpFormState();
}

class _AuthSignUpFormState extends State<AuthSignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }


  void _submit() {
    widget.onSubmit(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _confirmController.text.trim(),
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
          const SizedBox(height: 12),
          AppTextField(
            controller: _confirmController,
            label: 'Confirmar senha',
            isPassword: true,
          ),
          const SizedBox(height: 16),
          AppButton(
            label: 'Cadastrar',
            isLoading: widget.isLoading,
            onPressed: _submit,
            height: 44,
          ),
        ],
      ),
    );
  }
}
