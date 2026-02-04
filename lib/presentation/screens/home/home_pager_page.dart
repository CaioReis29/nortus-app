import 'package:flutter/material.dart';
import 'package:nortus/core/theme/app_colors.dart';
import 'package:nortus/presentation/screens/news/news_view.dart';
import 'package:nortus/presentation/screens/profile/profile_view.dart';

class HomePagerPage extends StatelessWidget {
  const HomePagerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Image.asset(
                'lib/assets/logo/nortus_mini_logo.png',
                height: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TabBar(
                  isScrollable: false,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  dividerColor: Colors.transparent,
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  indicatorColor: Colors.transparent,
                  indicator: const UnderlineTabIndicator(borderSide: BorderSide(color: Colors.transparent, width: 0)),
                  tabs: const [
                    Tab(text: 'Notícias'),
                    Tab(text: 'Meu Perfil'),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: const TabBarView(
          children: [
            NewsView(),
            ProfileView(),
          ],
        ),
      ),
    );
  }
}
