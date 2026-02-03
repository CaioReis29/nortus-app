import 'package:flutter/material.dart';
import 'package:nortus/core/router/app_router.dart';
import 'package:nortus/core/theme/app_theme.dart';

class NortusApp extends StatelessWidget {
  const NortusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Nortus',
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router(),
    );
  }
}
