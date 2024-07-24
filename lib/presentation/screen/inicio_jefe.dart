import 'package:flutter/material.dart';
import 'package:ACG/presentation/screen/generar_contrato.dart';
import 'package:ACG/presentation/screen/mensajes_contratos.dart';
import 'package:ACG/presentation/screen/anexo.dart';

class InicioJefe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('¿Que desea hacer?'),
      ),
      body: Row(
        children: <Widget>[
          // Dos tercios de la pantalla para el logo
          Expanded(
            flex: 2,
            child: SizedBox(
              width: 250,
              height: 250,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/img/logo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          // Un tercio de la pantalla para los botones
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GenerateContractScreen(),
                      ),
                    );
                  },
                  child: const Text('Generar Contrato'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContractReviewPage(),
                      ),
                    );
                  },
                  child: const Text('Revisar Contrato'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
