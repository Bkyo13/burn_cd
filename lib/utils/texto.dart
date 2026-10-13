/// Pasa a minúsculas, quita acentos y símbolos (para comparar textos).
String normalizar(String texto) {
  const origen = 'áàäâãéèëêíìïîóòöôõúùüûñ';
  const destino = 'aaaaaeeeeiiiiooooouuuun';
  var salida = texto.toLowerCase();
  for (var i = 0; i < origen.length; i++) {
    salida = salida.replaceAll(origen[i], destino[i]);
  }
  return salida.replaceAll(RegExp(r'[^a-z0-9]+'), ' ').trim();
}

/// Quita cosas como "(Remastered 2011)" o "- Live" del título de una canción.
String limpiarTitulo(String titulo) {
  var t = titulo.replaceAll(RegExp(r'\s*[\(\[].*?[\)\]]'), '');
  t = t.replaceAll(RegExp(r'\s+-\s+.*$'), '');
  return t.trim();
}
