import 'package:flutter/material.dart';
import 'package:appatec_prototipo/presentation/screen/login.dart'; // Asegúrate de tener la ruta correcta a tu archivo

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orange,
      ),
      home: LoginScreen(),
    );
  }
}
