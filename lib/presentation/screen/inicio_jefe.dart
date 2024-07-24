import 'package:flutter/material.dart';
import 'package:ACG/presentation/screen/generar_contrato.dart';
import 'package:ACG/presentation/screen/mensajes_contratos.dart';
import 'package:ACG/dart_rut_validator.dart';

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
                  onPressed: () => _showRutDialog(context),
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

  void _showRutDialog(BuildContext context) {
    final TextEditingController rutController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    void onChangedApplyFormat(String text) {
      RUTValidator.formatFromTextController(rutController);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ingresar RUT del Trabajador'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: rutController,
              onChanged: onChangedApplyFormat,
              decoration: const InputDecoration(
                labelText: 'RUT',
                border: OutlineInputBorder(),
              ),
              validator: RUTValidator(validationErrorText: 'Ingrese RUT válido')
                  .validator,
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  String rut = rutController.text;
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenerateContractScreen(rut: rut),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
