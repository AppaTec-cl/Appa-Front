import 'package:flutter/material.dart';
import 'package:ACG/presentation/screen/login.dart';
import 'package:intl/date_symbol_data_local.dart';

// Función principal que inicia la aplicación
void main() {
  // Inicializa la localización de fecha en español
  initializeDateFormatting('es_ES', null).then((_) {
    runApp(const MiAplicacion());
  });
}

// Clase principal de la aplicación que extiende StatefulWidget
class MiAplicacion extends StatefulWidget {
  const MiAplicacion({super.key});

  @override
  State<MiAplicacion> createState() => _EstadoMiAplicacion();
}

// Estado de la clase principal MiAplicacion
class _EstadoMiAplicacion extends State<MiAplicacion> {
  bool _modoOscuro =
      false; // Variable que indica si el modo oscuro está activado

  // Método para cambiar entre el modo oscuro y el modo claro
  void alternarTema() {
    setState(() {
      _modoOscuro = !_modoOscuro;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: _modoOscuro ? Brightness.dark : Brightness.light,
        useMaterial3: true,
        colorSchemeSeed: _modoOscuro ? Colors.grey : Colors.blue,
      ),
      home: PantallaInicioSesion(
          alternarTema: alternarTema, modoOscuro: _modoOscuro),
    );
  }
}
