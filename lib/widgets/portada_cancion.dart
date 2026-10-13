import 'package:flutter/material.dart';

import '../models/cancion.dart';

/// Portada de la canción. Si viene con imagen real (API) la muestra; si no,
/// o mientras carga o si falla, usa un degradado con icono.
class PortadaCancion extends StatelessWidget {
  final Cancion cancion;
  final double tamano;
  final double radio;

  const PortadaCancion({
    super.key,
    required this.cancion,
    required this.tamano,
    this.radio = 14,
  });

  Widget _degradado() {
    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radio),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cancion.colorPrimario, cancion.colorSecundario],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: tamano * 0.7,
            height: tamano * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withAlpha(60), width: 2),
            ),
          ),
          Icon(
            cancion.icono,
            size: tamano * 0.38,
            color: Colors.white.withAlpha(230),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = cancion.urlPortada;

    return Container(
      width: tamano,
      height: tamano,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radio),
        boxShadow: [
          BoxShadow(
            color: cancion.colorPrimario.withAlpha(110),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: url == null
          ? _degradado()
          : ClipRRect(
              borderRadius: BorderRadius.circular(radio),
              child: Image.network(
                url,
                width: tamano,
                height: tamano,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _degradado(),
                loadingBuilder: (_, child, progreso) =>
                    progreso == null ? child : _degradado(),
              ),
            ),
    );
  }
}
