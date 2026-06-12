import 'package:flutter/material.dart';
import 'package:flutter_simulador_copa_2026/di/service_locator.dart';
import 'package:flutter_simulador_copa_2026/views/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupInjecaoDependencias();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simulador Copa 2026',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF004B23),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF004B23),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
