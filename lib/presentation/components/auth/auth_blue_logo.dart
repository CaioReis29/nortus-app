import 'package:flutter/material.dart';

class AuthBlueLogo extends StatelessWidget {
  final double top;
  final double left;
  final double width;
  final double height;

  const AuthBlueLogo({
    super.key,
    required this.top,
    required this.left,
    this.width = 142,
    this.height = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Image.asset(
        'lib/assets/logo/nortus_blue_name.png',
        width: width,
        height: height,
      ),
    );
  }
}
