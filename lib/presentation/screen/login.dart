import 'package:flutter/material.dart';
import 'package:ACG/presentation/screen/crear_usuario.dart';
import 'package:ACG/presentation/screen/revisar_contrato.dart';
import 'package:ACG/presentation/screen/firmar_gerente.dart';
import 'package:ACG/presentation/screen/inicio_jefe.dart';
import 'package:ACG/presentation/theme_switcher.dart';
import 'package:ACG/presentation/screen/resetear_contraseña.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ACG/dart_rut_validator.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

// Pantalla de inicio de sesión
class PantallaInicioSesion extends StatelessWidget {
  final Function alternarTema;
  final bool modoOscuro;

  PantallaInicioSesion(
      {super.key, required this.alternarTema, required this.modoOscuro});

  final TextEditingController controladorUsuario = TextEditingController();
  final TextEditingController controladorContrasena = TextEditingController();

  // Formatea el texto ingresado en el campo de RUT
  void alCambiarAplicarFormato(String texto) {
    RUTValidator.formatFromTextController(controladorUsuario);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: SizedBox(
                width: 650,
                height: 650,
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
          ),
          const Padding(
            padding: EdgeInsets.only(top: 25.0, bottom: 25.0),
            child: VerticalDivider(
              color: Colors.grey,
              width: 1,
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '¡Bienvenido!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Inicia Sesión',
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    onChanged: alCambiarAplicarFormato,
                    controller: controladorUsuario,
                    decoration: const InputDecoration(
                      labelText: 'Ingresa tu RUT',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controladorContrasena,
                    decoration: const InputDecoration(
                      labelText: 'Ingresa tu Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      mostrarDialogoRecuperarContrasena(context);
                    },
                    child: const Text('Recuperar Contraseña'),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      String idUsuario = controladorUsuario.text;
                      String contrasena = controladorContrasena.text;
                      if (idUsuario.isNotEmpty && contrasena.isNotEmpty) {
                        iniciarSesion(idUsuario, contrasena, context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                                'Por favor ingrese ambos, usuario y contraseña')));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Iniciar Sesión'),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿Eres administrador?'),
                      Flexible(
                        child: TextButton(
                          onPressed: () => mostrarDialogoContactoAdmin(context),
                          child: const Text('Crear Cuenta'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AlternadorTema(
        alternarTema: alternarTema,
        modoOscuro: modoOscuro,
      ),
    );
  }
}

// Muestra un diálogo para recuperar la contraseña
void mostrarDialogoRecuperarContrasena(BuildContext context) {
  final TextEditingController controladorRut = TextEditingController();
  void alCambiarAplicarFormato2(String texto) {
    RUTValidator.formatFromTextController(controladorRut);
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Recuperar Contraseña'),
        content: TextField(
          controller: controladorRut,
          onChanged: alCambiarAplicarFormato2,
          decoration: const InputDecoration(
            labelText: 'Ingresa tu RUT',
            border: OutlineInputBorder(),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Enviar'),
            onPressed: () {
              solicitarRecuperacionContrasena(controladorRut.text).then((_) {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaginaRestablecerContrasena()),
                );
              });
            },
          ),
        ],
      );
    },
  );
}

// Solicita la recuperación de contraseña enviando el RUT al servidor
Future<void> solicitarRecuperacionContrasena(String rut) async {
  final url = 'https://appatec-back-3c17836d3790.herokuapp.com/request_reset';
  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({'rut': rut}),
  );

  if (response.statusCode == 200) {
    // Recuperación de contraseña exitosa
  } else {
    // Manejo de error
  }
}

// Muestra un diálogo para el contacto del administrador
void mostrarDialogoContactoAdmin(BuildContext context) {
  final TextEditingController controladorContrasenaAdmin =
      TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Ingresar Contraseña'),
        content: TextField(
          controller: controladorContrasenaAdmin,
          decoration: const InputDecoration(
            labelText: 'Ingresa tu Contraseña',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Aceptar'),
            onPressed: () {
              if (controladorContrasenaAdmin.text == 'Bmc1201*' ||
                  controladorContrasenaAdmin.text == 'Cyphound2257!' ||
                  controladorContrasenaAdmin.text == 'Rosut0' ||
                  controladorContrasenaAdmin.text == 'rhj1202@') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PantallaFormularioUsuario(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Contraseña incorrecta'),
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

// Inicia sesión enviando el RUT y la contraseña al servidor
Future<void> iniciarSesion(
    String rut, String contrasena, BuildContext context) async {
  final response = await http.post(
    Uri.parse('https://appatec-back-3c17836d3790.herokuapp.com/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'rut': rut,
      'password': contrasena,
    }),
  );

  if (response.statusCode == 200) {
    var datos = jsonDecode(response.body);
    var rol = datos['rol'];
    var nombre = datos['nombre'];
    var idUsuario = datos['id_usuario'];

    // Almacenamiento de los datos de sesión
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('rolUsuario', rol);
    await prefs.setString('nombreUsuario', nombre);
    await prefs.setString('idUsuario', idUsuario);

    switch (rol) {
      case 'Jefe de Recursos Humanos':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => InicioJefe()));
        break;
      case 'Gerente':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PaginaRevisarContrato()));
        break;
      case 'Gerente General':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PaginaGerente()));
        break;
      default:
        break;
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña incorrectos')));
  }
}
