import 'package:flutter/material.dart';
import 'package:nortus/presentation/screens/home/home_page.dart';

class NortusApp extends StatelessWidget {
  const NortusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nortus App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}
