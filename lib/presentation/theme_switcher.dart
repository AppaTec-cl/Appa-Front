import 'package:flutter/material.dart';

class ThemeSwitcher extends StatelessWidget {
  final Function toggleTheme;
  final bool isDarkMode;

  const ThemeSwitcher({
    super.key,
    required this.toggleTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => toggleTheme(),
      child: Icon(
        isDarkMode
            ? Icons.mode_night
            : Icons.sunny, // Icono cambia según el estado del tema
      ),
    );
  }
}
