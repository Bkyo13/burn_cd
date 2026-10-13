import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../models/cancion.dart';
import '../theme/app_tema.dart';
import 'disco_cd.dart';

/// Reproductor real: reproduce la vista previa (30 s) que da la API.
class ReproductorAudio extends StatefulWidget {
  final String url;

  /// Avisa cuando empieza (true) o se detiene (false) la reproducción.
  final ValueChanged<bool>? onReproduccionCambia;

  const ReproductorAudio({
    super.key,
    required this.url,
    this.onReproduccionCambia,
  });

  @override
  State<ReproductorAudio> createState() => _ReproductorAudioState();
}

class _ReproductorAudioState extends State<ReproductorAudio> {
  final AudioPlayer _player = AudioPlayer();
  final List<StreamSubscription<dynamic>> _suscripciones = [];

  Duration _posicion = Duration.zero;
  Duration _duracion = Duration.zero;
  bool _reproduciendo = false;
  bool _cargando = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _suscripciones.add(_player.positionStream.listen((p) {
      if (mounted) setState(() => _posicion = p);
    }));
    _suscripciones.add(_player.durationStream.listen((d) {
      if (mounted && d != null) setState(() => _duracion = d);
    }));
    _suscripciones.add(_player.playerStateStream.listen(_alCambiarEstado));
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      await _player.setUrl(widget.url);
      if (mounted) setState(() => _cargando = false);
    } catch (_) {
      if (mounted) {
        setState(() {
          _cargando = false;
          _error = true;
        });
      }
    }
  }

  void _alCambiarEstado(PlayerState estado) {
    if (estado.processingState == ProcessingState.completed) {
      _player.pause();
      _player.seek(Duration.zero);
    }
    final suena =
        estado.playing && estado.processingState != ProcessingState.completed;
    if (suena != _reproduciendo && mounted) {
      setState(() => _reproduciendo = suena);
      widget.onReproduccionCambia?.call(suena);
    }
  }

  void _alternar() {
    if (_reproduciendo) {
      _player.pause();
    } else {
      unawaited(_player.play());
    }
  }

  @override
  void dispose() {
    for (final s in _suscripciones) {
      s.cancel();
    }
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maximo = _duracion.inMilliseconds > 0
        ? _duracion.inMilliseconds.toDouble()
        : 1.0;
    final valor = _posicion.inMilliseconds.clamp(0, maximo.toInt()).toDouble();
    final bloqueado = _cargando || _error;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTema.superficie,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              DiscoCd(tamano: 64, girando: _reproduciendo),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    Slider(
                      value: valor,
                      min: 0,
                      max: maximo,
                      activeColor: AppTema.acento,
                      onChanged: bloqueado
                          ? null
                          : (v) => _player.seek(Duration(milliseconds: v.round())),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Cancion.formatear(_posicion.inSeconds),
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            Cancion.formatear(_duracion.inSeconds),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (_cargando)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                )
              else
                IconButton(
                  iconSize: 44,
                  color: AppTema.acento,
                  onPressed: _error ? null : _alternar,
                  icon: Icon(
                    _reproduciendo
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _error
                ? 'No se pudo cargar el audio.'
                : 'Vista previa de 30 s (iTunes)',
            style: const TextStyle(fontSize: 11, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
