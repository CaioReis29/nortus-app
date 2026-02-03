import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nortus/core/router/app_paths.dart';
import 'package:nortus/core/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.go(RoutePaths.news);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Image.asset(
          'lib/assets/logo/nortus_white_name.png',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
