import 'package:flutter/material.dart';

/// Modelo de datos de una canción (de la lista local o de la búsqueda en línea).
class Cancion {
  final String id;
  final String titulo;
  final String artista;
  final int anio;
  final int duracionSegundos;
  final String genero;
  final String descripcion;
  final Color colorPrimario;
  final Color colorSecundario;
  final IconData icono;

  /// Nota curada a mano (solo las canciones de la lista local la tienen).
  final String? datoCurioso;

  /// Vista previa de audio y portada reales (vienen de la API).
  final String? urlAudio;
  final String? urlPortada;

  /// Ids de canciones parecidas (sirven para "expandir tus gustos").
  final List<String> similaresIds;

  const Cancion({
    required this.id,
    required this.titulo,
    required this.artista,
    required this.anio,
    required this.duracionSegundos,
    required this.genero,
    required this.descripcion,
    required this.colorPrimario,
    required this.colorSecundario,
    required this.icono,
    this.datoCurioso,
    this.urlAudio,
    this.urlPortada,
    this.similaresIds = const [],
  });

  String get anioTexto => anio > 0 ? '$anio' : '—';

  String get duracionTexto =>
      duracionSegundos > 0 ? formatear(duracionSegundos) : '--:--';

  /// Convierte segundos a formato m:ss.
  static String formatear(int segundos) {
    final m = segundos ~/ 60;
    final s = (segundos % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  static const List<List<Color>> _paletas = [
    [Color(0xFF6A1B9A), Color(0xFFFF7043)],
    [Color(0xFF0D47A1), Color(0xFF26C6DA)],
    [Color(0xFFB71C1C), Color(0xFFFFB300)],
    [Color(0xFF1B5E20), Color(0xFFFDD835)],
    [Color(0xFF283593), Color(0xFFFF1744)],
    [Color(0xFF37474F), Color(0xFF69F0AE)],
  ];

  static IconData _iconoParaGenero(String genero) {
    final g = genero.toLowerCase();
    if (g.contains('rock') || g.contains('metal')) return Icons.electric_bolt;
    if (g.contains('pop')) return Icons.star;
    if (g.contains('hip') || g.contains('rap')) return Icons.mic;
    if (g.contains('latin') || g.contains('reggaeton')) return Icons.celebration;
    if (g.contains('anime') || g.contains('j-pop')) return Icons.auto_awesome;
    if (g.contains('sound') || g.contains('game')) return Icons.sports_esports;
    return Icons.music_note;
  }

  /// Crea una canción a partir de un resultado de la API de iTunes.
  factory Cancion.desdeItunes(Map<String, dynamic> json) {
    final trackId = (json['trackId'] as num).toInt();
    final milisegundos = (json['trackTimeMillis'] as num?)?.toInt() ?? 0;
    final fecha = json['releaseDate'] as String?;
    final anio = (fecha != null && fecha.length >= 4)
        ? int.tryParse(fecha.substring(0, 4)) ?? 0
        : 0;
    final genero = (json['primaryGenreName'] as String?) ?? 'Música';
    final album = json['collectionName'] as String?;
    final portada100 = json['artworkUrl100'] as String?;
    final paleta = _paletas[trackId % _paletas.length];

    return Cancion(
      id: 'it_$trackId',
      titulo: (json['trackName'] as String?) ?? 'Sin título',
      artista: (json['artistName'] as String?) ?? 'Artista desconocido',
      anio: anio,
      duracionSegundos: milisegundos ~/ 1000,
      genero: genero,
      descripcion: album != null ? 'Álbum: $album' : 'Resultado de la búsqueda',
      colorPrimario: paleta[0],
      colorSecundario: paleta[1],
      icono: _iconoParaGenero(genero),
      urlAudio: json['previewUrl'] as String?,
      urlPortada: portada100?.replaceAll('100x100bb', '600x600bb'),
    );
  }
}
