import 'package:flutter/material.dart';

import 'theme/app_tema.dart';
import 'views/pantalla_splash.dart';

void main() {
  runApp(const MusicExplorerApp());
}

class MusicExplorerApp extends StatelessWidget {
  const MusicExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Explorer',
      debugShowCheckedModeBanner: false,
      theme: AppTema.oscuro,
      home: const PantallaSplash(),
    );
  }
}
