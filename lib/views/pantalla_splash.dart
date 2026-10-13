import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/disco_cd.dart';
import 'pantalla_principal.dart';

/// Pantalla de bienvenida: logo, animación de carga y paso automático
/// a la pantalla principal a los 3 segundos.
class PantallaSplash extends StatefulWidget {
  const PantallaSplash({super.key});

  @override
  State<PantallaSplash> createState() => _PantallaSplashState();
}

class _PantallaSplashState extends State<PantallaSplash> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PantallaPrincipal()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF07385B), Color(0xFF397EA0), Color(0xFF8AB7D7), Color(0xFF164D70)],
          ),
        ),
        child: Center(
          child: Container(
            width: 440,
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F2E9),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 24, offset: Offset(0, 16))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF17458E), Color(0xFF78A8E4)])),
                  child: const Text('Music Explorer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                ),
                const SizedBox(height: 28),
                const DiscoCd(tamano: 120, girando: true),
                const SizedBox(height: 20),
                const Text('MUSIC EXPLORER', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, letterSpacing: 2, color: Color(0xFF173B70), fontFamily: 'monospace')),
                const SizedBox(height: 8),
                const Text('Escucha música. Descubre sus historias.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF444444))),
                const SizedBox(height: 24),
                const SizedBox(width: 26, height: 26, child: CircularProgressIndicator(strokeWidth: 3, color: Color(0xFF17458E))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
