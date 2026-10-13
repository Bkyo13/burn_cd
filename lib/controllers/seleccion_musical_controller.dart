import 'package:flutter/foundation.dart';

import '../models/cancion.dart';

/// Lista de canciones seleccionadas por el usuario (en memoria).
class SeleccionMusicalController extends ChangeNotifier {
  SeleccionMusicalController._();
  static final SeleccionMusicalController instancia = SeleccionMusicalController._();

  final List<Cancion> _pistas = [];

  List<Cancion> get pistas => List.unmodifiable(_pistas);

  int get duracionTotal =>
      _pistas.fold(0, (suma, c) => suma + c.duracionSegundos);

  bool contiene(Cancion cancion) => _pistas.any((p) => p.id == cancion.id);

  /// Agrega una canción a la selección, evitando duplicados.
  bool agregar(Cancion cancion) {
    if (contiene(cancion)) return true;
    _pistas.add(cancion);
    notifyListeners();
    return true;
  }

  void quitar(Cancion cancion) {
    _pistas.removeWhere((p) => p.id == cancion.id);
    notifyListeners();
  }

  /// Recomienda canciones según las canciones seleccionadas:
  /// +2 puntos si es "similar" a alguna pista, +1 si comparte género.
  List<Cancion> sugerencias(List<Cancion> catalogo) {
    if (_pistas.isEmpty) return [];

    final puntajes = <MapEntry<Cancion, int>>[];
    for (final candidata in catalogo) {
      if (contiene(candidata)) continue;
      var puntos = 0;
      for (final pista in _pistas) {
        if (pista.similaresIds.contains(candidata.id)) puntos += 2;
        if (pista.genero == candidata.genero) puntos += 1;
      }
      if (puntos > 0) puntajes.add(MapEntry(candidata, puntos));
    }

    puntajes.sort((a, b) => b.value.compareTo(a.value));
    return puntajes.take(5).map((e) => e.key).toList();
  }
}
