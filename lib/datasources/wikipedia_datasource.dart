import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/dato_curioso.dart';
import '../utils/texto.dart';

/// Busca en Wikipedia (gratis, sin llave) la historia de una canción.
/// Primero en español y, si no hay nada claro, en inglés.
class WikipediaDatasource {
  WikipediaDatasource._();
  static final WikipediaDatasource instancia = WikipediaDatasource._();

  static final RegExp _paginasDescartadas = RegExp(
    r'\((film|pel[ií]cula|movie|album|[aá]lbum|tv|series|serie|videojuego|video game)',
    caseSensitive: false,
  );

  Future<DatoCurioso?> resumenCancion({
    required String titulo,
    required String artista,
  }) async {
    final limpio = limpiarTitulo(titulo);
    for (final idioma in ['es', 'en']) {
      try {
        final resultado = await _buscarEn(idioma, limpio, artista);
        if (resultado != null) return resultado;
      } catch (_) {
        // Si falla un idioma, se intenta con el siguiente.
      }
    }
    return null;
  }

  Future<DatoCurioso?> _buscarEn(
    String idioma,
    String titulo,
    String artista,
  ) async {
    final busqueda = Uri.https('$idioma.wikipedia.org', '/w/api.php', {
      'action': 'query',
      'list': 'search',
      'srsearch': '$titulo $artista',
      'srlimit': '5',
      'format': 'json',
      'origin': '*',
    });

    final respuesta = await http.get(busqueda).timeout(const Duration(seconds: 10));
    if (respuesta.statusCode != 200) return null;

    final datos = jsonDecode(utf8.decode(respuesta.bodyBytes))
        as Map<String, dynamic>;
    final encontrados = (datos['query']?['search'] as List?) ?? const [];

    for (final item in encontrados) {
      final tituloPagina = item['title'] as String?;
      if (tituloPagina == null || _paginasDescartadas.hasMatch(tituloPagina)) {
        continue;
      }
      final resumen = await _resumen(idioma, tituloPagina);
      if (resumen == null) continue;

      final extracto = resumen['extract'] as String? ?? '';
      if (_esRelevante(tituloPagina, extracto, titulo, artista)) {
        return DatoCurioso(
          texto: _recortar(extracto),
          fuente: 'Wikipedia (${idioma.toUpperCase()}) · $tituloPagina',
        );
      }
    }
    return null;
  }

  Future<Map<String, dynamic>?> _resumen(String idioma, String tituloPagina) async {
    final pagina = Uri.encodeComponent(tituloPagina.replaceAll(' ', '_'));
    final uri = Uri.parse(
      'https://$idioma.wikipedia.org/api/rest_v1/page/summary/$pagina',
    );
    final respuesta = await http.get(uri).timeout(const Duration(seconds: 10));
    if (respuesta.statusCode != 200) return null;

    final datos = jsonDecode(utf8.decode(respuesta.bodyBytes))
        as Map<String, dynamic>;
    if (datos['type'] == 'disambiguation') return null;
    final extracto = datos['extract'] as String?;
    if (extracto == null || extracto.trim().isEmpty) return null;
    return datos;
  }

  /// Solo aceptamos la página si habla de la canción (evita datos de otra cosa).
  bool _esRelevante(String tituloPagina, String extracto, String titulo, String artista) {
    final t = normalizar(titulo);
    final a = normalizar(artista);
    if (t.isEmpty) return false;
    final pagina = normalizar(tituloPagina);
    final texto = normalizar(extracto);
    return pagina.contains(t) && (texto.contains(a) || texto.contains(t));
  }

  String _recortar(String texto, {int maximo = 520}) {
    if (texto.length <= maximo) return texto;
    final corte = texto.lastIndexOf('. ', maximo);
    if (corte > 150) return texto.substring(0, corte + 1);
    return '${texto.substring(0, maximo)}…';
  }
}
