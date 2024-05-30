import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppaTeam',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sesión Iniciada'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Acción para Revisar Contrato
                },
                child: Text('Revisar Contrato', style: TextStyle(fontSize: 24)),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Acción para Historial de contrato
                },
                child: Text('Historial de contrato',
                    style: TextStyle(fontSize: 24)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
