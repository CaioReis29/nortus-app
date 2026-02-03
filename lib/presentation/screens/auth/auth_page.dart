import 'package:flutter/material.dart';
import 'package:nortus/core/theme/app_colors.dart';
import 'package:nortus/presentation/components/auth/auth_blue_logo.dart';
import 'package:nortus/presentation/components/auth/auth_bottom_card.dart';
import 'package:nortus/presentation/components/auth/auth_grey_logo.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final cardHeight = size.height * 0.4;
    final cardTop = size.height - cardHeight;
    final double greySize = size.height * 0.45;
    const double greyOverlap = 84;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Container(color: Colors.transparent)),

          AuthBlueLogo(top: cardTop - 284, left: 16),

          AuthGreyLogo(
            top: cardTop - greySize + greyOverlap,
            right: -(size.width * 0.25),
            size: greySize,
            opacity: 0.8,
          ),

          AuthBottomCard(height: cardHeight, color: AppColors.primaryColor),
        ],
      ),
    );
  }
}
