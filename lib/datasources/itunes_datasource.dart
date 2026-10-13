import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cancion.dart';
import '../utils/texto.dart';

/// Busca canciones en la API pública de iTunes (gratis, sin llave).
/// Devuelve vista previa de 30 s (previewUrl) y portada.
class ItunesDatasource {
  ItunesDatasource._();
  static final ItunesDatasource instancia = ItunesDatasource._();

  Future<List<Cancion>> buscar(String termino, {int limite = 25}) async {
    final uri = Uri.https('itunes.apple.com', '/search', {
      'term': termino,
      'media': 'music',
      'entity': 'song',
      'limit': '$limite',
    });

    final respuesta = await http.get(uri).timeout(const Duration(seconds: 10));
    if (respuesta.statusCode != 200) {
      throw Exception('iTunes respondió ${respuesta.statusCode}');
    }

    final datos = jsonDecode(utf8.decode(respuesta.bodyBytes))
        as Map<String, dynamic>;
    final lista = (datos['results'] as List?) ?? const [];

    final vistos = <int>{};
    return lista
        .whereType<Map<String, dynamic>>()
        .where((j) => j['previewUrl'] != null && j['trackId'] != null)
        .where((j) => vistos.add((j['trackId'] as num).toInt()))
        .map(Cancion.desdeItunes)
        .toList();
  }

  /// Busca la versión en iTunes de una canción que ya conocemos
  /// (para sacar su audio). Regresa null si no hay coincidencia clara.
  Future<Cancion?> mejorCoincidencia(String titulo, String artista) async {
    final resultados = await buscar('$titulo $artista', limite: 8);
    final t = normalizar(limpiarTitulo(titulo));
    final a = normalizar(artista.split('(').first);

    for (final r in resultados) {
      final tituloR = normalizar(limpiarTitulo(r.titulo));
      final artistaR = normalizar(r.artista);
      if (tituloR == t && artistaR.contains(a)) return r;
    }
    return null;
  }
}
