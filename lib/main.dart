import 'package:flutter/material.dart';
import 'package:nortus/core/app/nortus_app.dart';
import 'package:nortus/core/di/container_di.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final containerDi = ContainerDi();
  containerDi.setup();

  runApp(const NortusApp());
}