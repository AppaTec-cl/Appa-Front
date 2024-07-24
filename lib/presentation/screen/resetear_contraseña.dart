import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Pantalla de restablecimiento de contraseña
class PaginaRestablecerContrasena extends StatefulWidget {
  @override
  _EstadoPaginaRestablecerContrasena createState() =>
      _EstadoPaginaRestablecerContrasena();
}

class _EstadoPaginaRestablecerContrasena
    extends State<PaginaRestablecerContrasena> {
  final _claveFormulario = GlobalKey<FormState>();
  final _controladorToken = TextEditingController();
  final _controladorContrasena = TextEditingController();

  // Función para restablecer la contraseña
  Future<void> _restablecerContrasena(
      String token, String nuevaContrasena) async {
    final url =
        'https://appatec-back-3c17836d3790.herokuapp.com/reset_password/$token';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'token': token, 'new_password': nuevaContrasena}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contraseña actualizada exitosamente')),
      );
      // Navegar a la página de inicio de sesión o mostrar un mensaje de éxito
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error: ${json.decode(response.body)['error']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restablecer Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _claveFormulario,
          child: Column(
            children: [
              TextFormField(
                controller: _controladorToken,
                decoration: const InputDecoration(
                  labelText: 'Ingresa tu Token',
                  border: OutlineInputBorder(),
                ),
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Por favor, ingrese el token';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _controladorContrasena,
                decoration: const InputDecoration(
                  labelText: 'Ingresa tu nueva contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Por favor, ingrese su nueva contraseña';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_claveFormulario.currentState!.validate()) {
                    _restablecerContrasena(
                        _controladorToken.text, _controladorContrasena.text);
                  }
                },
                child: Text('Restablecer Contraseña'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
