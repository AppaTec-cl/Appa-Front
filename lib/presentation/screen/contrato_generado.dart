import 'package:flutter/material.dart';

class ContractScreen extends StatelessWidget {
  const ContractScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contrato Generado'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                child: ListTile(
                  title: const Text('Previsualizar Contrato'),
                  onTap: _previewContract,
                  trailing: const Icon(Icons.visibility),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: ListTile(
                  title: const Text('Descargar Contrato'),
                  onTap: _downloadContract,
                  trailing: const Icon(Icons.download),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: ListTile(
                  title: const Text('Enviar Contrato'),
                  onTap: _sendContract,
                  trailing: const Icon(Icons.send),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _previewContract() {
    // Funcionalidad
  }

  void _downloadContract() {
    // Funcionalidad
  }

  void _sendContract() {
    // Funcionalidad
  }
}
