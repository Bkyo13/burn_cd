import 'dart:async';

import 'package:flutter/material.dart';

import '../models/cancion.dart';
import '../theme/app_tema.dart';
import 'disco_cd.dart';

/// Reproductor de mentiras: no reproduce audio (no hay APIs ni archivos),
/// solo avanza el tiempo para simular que suena la canción.
class ReproductorSimulado extends StatefulWidget {
  final Cancion cancion;

  /// Avisa cuando empieza (true) o se detiene (false) la reproducción.
  final ValueChanged<bool>? onReproduccionCambia;

  const ReproductorSimulado({
    super.key,
    required this.cancion,
    this.onReproduccionCambia,
  });

  @override
  State<ReproductorSimulado> createState() => _ReproductorSimuladoState();
}

class _ReproductorSimuladoState extends State<ReproductorSimulado> {
  Timer? _timer;
  int _segundos = 0;
  bool _reproduciendo = false;

  int get _total => widget.cancion.duracionSegundos;

  void _alternar() {
    if (_reproduciendo) {
      _detener();
    } else {
      _iniciar();
    }
  }

  void _iniciar() {
    if (_segundos >= _total) _segundos = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _segundos++);
      if (_segundos >= _total) _detener();
    });
    setState(() => _reproduciendo = true);
    widget.onReproduccionCambia?.call(true);
  }

  void _detener() {
    _timer?.cancel();
    if (!mounted) return;
    setState(() => _reproduciendo = false);
    widget.onReproduccionCambia?.call(false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTema.superficie,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          DiscoCd(tamano: 64, girando: _reproduciendo),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                Slider(
                  value: _segundos.clamp(0, _total).toDouble(),
                  min: 0,
                  max: _total.toDouble(),
                  activeColor: AppTema.acento,
                  onChanged: (v) => setState(() => _segundos = v.round()),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Cancion.formatear(_segundos),
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        Cancion.formatear(_total),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            iconSize: 44,
            color: AppTema.acento,
            onPressed: _alternar,
            icon: Icon(
              _reproduciendo ? Icons.pause_circle_filled : Icons.play_circle_fill,
            ),
          ),
        ],
      ),
    );
  }
}
