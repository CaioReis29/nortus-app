import 'package:flutter/material.dart';

class AuthGreyLogo extends StatelessWidget {
  final double top;
  final double right;
  final double size;
  final double opacity;

  const AuthGreyLogo({
    super.key,
    required this.top,
    required this.right,
    required this.size,
    this.opacity = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      child: Opacity(
        opacity: opacity,
        child: Image.asset(
          'lib/assets/nortus_grey.png',
          width: size,
          height: size,
        ),
      ),
    );
  }
}
