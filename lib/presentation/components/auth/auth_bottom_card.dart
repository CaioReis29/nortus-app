import 'package:flutter/material.dart';

class AuthBottomCard extends StatelessWidget {
  final double height;
  final Color color;
  final Widget? child;

  const AuthBottomCard({
    super.key,
    required this.height,
    required this.color,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: child == null
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: child,
              ),
      ),
    );
  }
}
