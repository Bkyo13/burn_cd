import 'package:flutter/material.dart';

import '../models/cancion.dart';
import '../utils/texto.dart';

/// Fuente de datos local (mock data). No usa APIs ni internet.
class CancionesDatasource {
  CancionesDatasource._();
  static final CancionesDatasource instancia = CancionesDatasource._();

  final List<Cancion> _canciones = [
    Cancion(
      id: 'bohemian',
      titulo: 'Bohemian Rhapsody',
      artista: 'Queen',
      anio: 1975,
      duracionSegundos: 355,
      genero: 'Rock',
      descripcion:
          'Balada, ópera y hard rock en una sola canción. Un clásico imposible de encasillar.',
      datoCurioso:
          'Freddie Mercury la compuso y Queen la grabó con muchísimas capas de voces superpuestas. Dura casi seis minutos y la disquera dudaba en sacarla como sencillo por ser demasiado larga para la radio de la época; aun así se volvió uno de sus mayores éxitos.',
      colorPrimario: const Color(0xFFB71C1C),
      colorSecundario: const Color(0xFFFFB300),
      icono: Icons.electric_bolt,
      similaresIds: ['hotel_california', 'sweet_child', 'imagine'],
    ),
    Cancion(
      id: 'teen_spirit',
      titulo: 'Smells Like Teen Spirit',
      artista: 'Nirvana',
      anio: 1991,
      duracionSegundos: 301,
      genero: 'Rock',
      descripcion:
          'El himno del grunge: riff simple, estrofas calmadas y coros explosivos.',
      datoCurioso:
          'El título nació de un grafiti que Kathleen Hanna (de Bikini Kill) escribió en la pared de Kurt Cobain: "Kurt smells like Teen Spirit". Teen Spirit era una marca de desodorante que usaba su pareja de entonces, pero Kurt lo leyó como una frase rebelde y se la quedó.',
      colorPrimario: const Color(0xFF1B5E20),
      colorSecundario: const Color(0xFFFDD835),
      icono: Icons.electric_bolt,
      similaresIds: ['sweet_child', 'bohemian', 'lose_yourself'],
    ),
    Cancion(
      id: 'sweet_child',
      titulo: "Sweet Child o' Mine",
      artista: "Guns N' Roses",
      anio: 1987,
      duracionSegundos: 356,
      genero: 'Rock',
      descripcion:
          'Uno de los riffs de guitarra más reconocibles de la historia del rock.',
      datoCurioso:
          'Nació como un ejercicio de calentamiento de Slash en la guitarra, medio de broma, y el resto de la banda armó la canción alrededor de ese riff. Axl Rose escribió la letra pensando en su novia de entonces, Erin Everly.',
      colorPrimario: const Color(0xFF4E342E),
      colorSecundario: const Color(0xFFFF8F00),
      icono: Icons.electric_bolt,
      similaresIds: ['teen_spirit', 'hotel_california', 'dont_stop'],
    ),
    Cancion(
      id: 'dont_stop',
      titulo: "Don't Stop Believin'",
      artista: 'Journey',
      anio: 1981,
      duracionSegundos: 251,
      genero: 'Rock',
      descripcion:
          'Rock melódico con un piano inconfundible y un coro para cantar a gritos.',
      datoCurioso:
          'El título de la canción no aparece en el coro hasta el final: se guarda la frase para el cierre. Jonathan Cain, uno de sus compositores, ha contado que viene de un consejo de su papá cuando se fue a Los Ángeles a buscar suerte como músico.',
      colorPrimario: const Color(0xFF0D47A1),
      colorSecundario: const Color(0xFF26C6DA),
      icono: Icons.electric_bolt,
      similaresIds: ['sweet_child', 'take_on_me', 'hotel_california'],
    ),
    Cancion(
      id: 'hotel_california',
      titulo: 'Hotel California',
      artista: 'Eagles',
      anio: 1976,
      duracionSegundos: 390,
      genero: 'Rock',
      descripcion:
          'Misteriosa y larga, con uno de los finales de guitarra más famosos.',
      datoCurioso:
          'El final es un dueto de guitarras entre Don Felder y Joe Walsh. Don Henley ha dicho que la letra habla de los excesos y el lado oscuro del sueño americano, usando un hotel como metáfora.',
      colorPrimario: const Color(0xFF6A1B9A),
      colorSecundario: const Color(0xFFFF7043),
      icono: Icons.electric_bolt,
      similaresIds: ['bohemian', 'sweet_child', 'imagine'],
    ),
    Cancion(
      id: 'billie_jean',
      titulo: 'Billie Jean',
      artista: 'Michael Jackson',
      anio: 1983,
      duracionSegundos: 294,
      genero: 'Pop',
      descripcion:
          'Una línea de bajo hipnótica que lo dice todo desde el primer segundo.',
      datoCurioso:
          'Michael Jackson la escribió inspirado en fans obsesivas que lo acusaban de ser el padre de sus hijos. Según Quincy Jones, el productor, él quería recortar la intro y Michael no lo permitió.',
      colorPrimario: const Color(0xFF212121),
      colorSecundario: const Color(0xFFFFD600),
      icono: Icons.star,
      similaresIds: ['take_on_me', 'lose_yourself', 'dont_stop'],
    ),
    Cancion(
      id: 'take_on_me',
      titulo: 'Take On Me',
      artista: 'a-ha',
      anio: 1985,
      duracionSegundos: 228,
      genero: 'Pop',
      descripcion:
          'Synth-pop ochentero con un falsete que se te queda pegado días.',
      datoCurioso:
          'Su video mezcla actores reales con dibujos hechos a mano mediante rotoscopia, y tardó meses en hacerse. La canción tuvo versiones previas antes de volverse el éxito mundial de 1985.',
      colorPrimario: const Color(0xFFE91E63),
      colorSecundario: const Color(0xFF3F51B5),
      icono: Icons.star,
      similaresIds: ['billie_jean', 'dont_stop', 'cruel_angel'],
    ),
    Cancion(
      id: 'imagine',
      titulo: 'Imagine',
      artista: 'John Lennon',
      anio: 1971,
      duracionSegundos: 187,
      genero: 'Pop',
      descripcion:
          'Piano sencillo y una letra sobre imaginar un mundo en paz.',
      datoCurioso:
          'Lennon se inspiró en "Grapefruit", el libro de poemas-instrucciones de Yoko Ono, y de ahí salió esta idea de pedirle al oyente que imagine. Por eso él mismo ha reconocido que Yoko merecía crédito en la canción.',
      colorPrimario: const Color(0xFF0288D1),
      colorSecundario: const Color(0xFFE1F5FE),
      icono: Icons.star,
      similaresIds: ['hotel_california', 'bohemian', 'dont_stop'],
    ),
    Cancion(
      id: 'lose_yourself',
      titulo: 'Lose Yourself',
      artista: 'Eminem',
      anio: 2002,
      duracionSegundos: 326,
      genero: 'Hip-Hop',
      descripcion:
          'Rap con ritmo intenso sobre tener una sola oportunidad.',
      datoCurioso:
          'Eminem escribió partes de la letra en los descansos del rodaje de "8 Mile". Fue el primer rap en ganar el Óscar a mejor canción original.',
      colorPrimario: const Color(0xFF37474F),
      colorSecundario: const Color(0xFFFF5252),
      icono: Icons.mic,
      similaresIds: ['billie_jean', 'megalovania', 'teen_spirit'],
    ),
    Cancion(
      id: 'la_bamba',
      titulo: 'La Bamba',
      artista: 'Ritchie Valens',
      anio: 1958,
      duracionSegundos: 126,
      genero: 'Latino',
      descripcion:
          'Rock and roll con raíces mexicanas, corta y llena de energía.',
      datoCurioso:
          'Ritchie Valens convirtió en rock un son jarocho tradicional de Veracruz. Fue un éxito en Estados Unidos aunque la cantó en español, algo muy poco común en esa época.',
      colorPrimario: const Color(0xFF2E7D32),
      colorSecundario: const Color(0xFFEF5350),
      icono: Icons.celebration,
      similaresIds: ['dont_stop', 'billie_jean', 'take_on_me'],
    ),
    Cancion(
      id: 'tank',
      titulo: 'Tank!',
      artista: 'The Seatbelts (Yoko Kanno)',
      anio: 1998,
      duracionSegundos: 206,
      genero: 'Anime',
      descripcion:
          'El opening de Cowboy Bebop: big band jazz a toda velocidad.',
      datoCurioso:
          'Yoko Kanno formó The Seatbelts para grabar la música de Cowboy Bebop. "Tank!" mezcla jazz de big band con una energía casi de persecución, justo lo que la serie necesitaba para abrir cada episodio.',
      colorPrimario: const Color(0xFF1565C0),
      colorSecundario: const Color(0xFFFFCA28),
      icono: Icons.auto_awesome,
      similaresIds: ['cruel_angel', 'mario_theme', 'bohemian'],
    ),
    Cancion(
      id: 'cruel_angel',
      titulo: "A Cruel Angel's Thesis",
      artista: 'Yoko Takahashi',
      anio: 1995,
      duracionSegundos: 245,
      genero: 'Anime',
      descripcion:
          'El opening de Neon Genesis Evangelion, un clásico absoluto del anime.',
      datoCurioso:
          'Fue el opening de Neon Genesis Evangelion y se volvió tan icónico que sigue siendo un clásico de karaoke y una referencia cultural constante, incluso para gente que nunca vio la serie.',
      colorPrimario: const Color(0xFF6A1B9A),
      colorSecundario: const Color(0xFF69F0AE),
      icono: Icons.auto_awesome,
      similaresIds: ['tank', 'take_on_me', 'megalovania'],
    ),
    Cancion(
      id: 'megalovania',
      titulo: 'Megalovania',
      artista: 'Toby Fox',
      anio: 2015,
      duracionSegundos: 156,
      genero: 'Videojuegos',
      descripcion:
          'El tema del combate más difícil de Undertale. Rápido, tenso y muy pegajoso.',
      datoCurioso:
          'Toby Fox la usó en Undertale (2015), pero la melodía ya existía de antes: apareció años atrás en un proyecto de fans basado en EarthBound. Con Undertale se volvió una de las piezas más famosas de los videojuegos indie.',
      colorPrimario: const Color(0xFF283593),
      colorSecundario: const Color(0xFFFF1744),
      icono: Icons.sports_esports,
      similaresIds: ['mario_theme', 'tank', 'lose_yourself'],
    ),
    Cancion(
      id: 'mario_theme',
      titulo: 'Super Mario Bros. Theme',
      artista: 'Koji Kondo',
      anio: 1985,
      duracionSegundos: 90,
      genero: 'Videojuegos',
      descripcion:
          'La música del nivel 1-1. Probablemente la melodía más reconocida del mundo gamer.',
      datoCurioso:
          'Koji Kondo la compuso con muy pocos canales de audio del NES, y aun así creó una melodía que casi todo el mundo reconoce al instante, juegue o no videojuegos.',
      colorPrimario: const Color(0xFFD32F2F),
      colorSecundario: const Color(0xFF42A5F5),
      icono: Icons.sports_esports,
      similaresIds: ['megalovania', 'tank', 'take_on_me'],
    ),
  ];

  List<Cancion> obtenerTodas() => List.unmodifiable(_canciones);

  Cancion? porId(String id) {
    for (final c in _canciones) {
      if (c.id == id) return c;
    }
    return null;
  }

  /// Géneros disponibles, en el orden en que aparecen.
  List<String> generos() {
    final lista = <String>[];
    for (final c in _canciones) {
      if (!lista.contains(c.genero)) lista.add(c.genero);
    }
    return lista;
  }

  /// Canciones parecidas a [cancion] (según la lista de similares).
  List<Cancion> similaresDe(Cancion cancion) {
    return cancion.similaresIds
        .map(porId)
        .whereType<Cancion>()
        .toList();
  }

  /// Busca si una canción (por ejemplo, de la búsqueda en línea) ya está en
  /// nuestra lista curada, comparando título y artista.
  Cancion? coincidenciaLocal(String titulo, String artista) {
    final t = normalizar(limpiarTitulo(titulo));
    final a = normalizar(artista);
    for (final c in _canciones) {
      final tituloLocal = normalizar(c.titulo);
      final artistaLocal = normalizar(c.artista.split('(').first);
      if (t == tituloLocal && a.contains(artistaLocal)) return c;
    }
    return null;
  }

  /// Nota curada de una canción, si existe (de ella misma o de su gemela local).
  String? datoCuriosoLocalDe(Cancion cancion) {
    if (cancion.datoCurioso != null) return cancion.datoCurioso;
    return coincidenciaLocal(cancion.titulo, cancion.artista)?.datoCurioso;
  }
}
