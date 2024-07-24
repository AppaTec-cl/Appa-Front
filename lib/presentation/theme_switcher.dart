import 'package:flutter/material.dart';

// Clase para alternar el tema de la aplicación
class AlternadorTema extends StatelessWidget {
  final Function alternarTema; // Función para alternar el tema
  final bool modoOscuro; // Indica si el modo oscuro está activado

  const AlternadorTema({
    super.key,
    required this.alternarTema,
    required this.modoOscuro,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => alternarTema(),
      child: Icon(
        modoOscuro
            ? Icons.mode_night
            : Icons.sunny, // Icono cambia según el estado del tema
      ),
    );
  }
}
