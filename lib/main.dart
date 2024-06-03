import 'package:flutter/material.dart';
import 'package:appatec_prototipo/presentation/screen/login.dart';
import 'package:appatec_prototipo/presentation/theme_switcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
        useMaterial3: true,
        colorSchemeSeed: _isDarkMode ? Colors.grey : Colors.blue,
      ),
      home: LoginScreen(toggleTheme: toggleTheme, isDarkMode: _isDarkMode),
    );
  }
}
