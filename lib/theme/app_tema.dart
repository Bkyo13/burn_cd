import 'package:flutter/material.dart';

/// Tema claro retro inspirado en los asistentes de Windows XP.
class AppTema {
  static const Color fondo = Color(0xFF28658A);
  static const Color superficie = Color(0xFFF4F2E9);
  static const Color acento = Color(0xFF2D64A8);
  static const Color acentoSecundario = Color(0xFF17458E);

  static ThemeData get oscuro => ThemeData(
        useMaterial3: false,
        brightness: Brightness.light,
        scaffoldBackgroundColor: fondo,
        colorScheme: const ColorScheme.light(
          primary: acentoSecundario,
          secondary: acento,
          surface: superficie,
          onSurface: Color(0xFF222222),
        ),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: const Color(0xFF222222),
          displayColor: const Color(0xFF222222),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF17458E),
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
            color: Colors.white,
            fontFamily: 'monospace',
          ),
        ),
      );
}
