import 'package:flutter/material.dart';
import 'package:nortus/core/theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onPressed;
  final double? height;
  final IconData? icon;
  final ButtonStyle? style;

  const AppButton({
    super.key,
    required this.label,
    this.isLoading = false,
    this.onPressed,
    this.height = 44,
    this.icon,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 64,
      child: ElevatedButton(
        style:
            style ??
            ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : (icon != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon),
                        const SizedBox(width: 8),
                        Text(label),
                      ],
                    )
                  : Text(label, style: TextStyle(color: Colors.white))),
      ),
    );
  }
}
