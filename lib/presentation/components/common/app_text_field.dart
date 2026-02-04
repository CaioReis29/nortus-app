import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool isPassword;
  final double radius;
  final bool filled;
  final Color? fillColor;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  final bool autofocus;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
    this.radius = 16,
    this.filled = true,
    this.fillColor,
    this.enabled = true,
    this.maxLines,
    this.minLines,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputAction,
    this.autofocus = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.all(Radius.circular(widget.radius));
    final maxLines = widget.isPassword ? 1 : (widget.maxLines ?? 1);

    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      autofocus: widget.autofocus,
      cursorColor: Colors.blue.shade700,
      obscureText: widget.isPassword ? _obscure : false,
      maxLines: maxLines,
      minLines: widget.minLines,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        filled: widget.filled,
        fillColor: widget.fillColor ?? Colors.white,
        border: OutlineInputBorder(borderRadius: radius),
        errorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: Colors.red.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: Colors.blue.shade700),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        errorStyle: TextStyle(color: Colors.red.shade300),
        prefixIcon: widget.prefixIcon,
        suffixIcon:
            widget.suffixIcon ??
            (widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null),
      ),
    );
  }
}
