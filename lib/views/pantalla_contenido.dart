import 'package:flutter/material.dart';

import '../controllers/seleccion_musical_controller.dart';
import '../datasources/canciones_datasource.dart';
import '../datasources/itunes_datasource.dart';
import '../datasources/wikipedia_datasource.dart';
import '../models/cancion.dart';
import '../models/dato_curioso.dart';
import '../widgets/portada_cancion.dart';
import '../widgets/reproductor_audio.dart';
import '../widgets/reproductor_simulado.dart';

/// Detalle de una canción: portada (Hero), info, reproductor, dato curioso
/// al darle play y canciones parecidas para expandir gustos.
class PantallaContenido extends StatefulWidget {
  final Cancion cancion;

  const PantallaContenido({super.key, required this.cancion});

  @override
  State<PantallaContenido> createState() => _PantallaContenidoState();
}

class _PantallaContenidoState extends State<PantallaContenido> {
  final _seleccion = SeleccionMusicalController.instancia;
  final _local = CancionesDatasource.instancia;
  final _itunes = ItunesDatasource.instancia;
  final _wikipedia = WikipediaDatasource.instancia;

  bool _datoRevelado = false;

  String? _urlAudio;
  bool _resolviendoAudio = false;

  DatoCurioso? _dato;
  bool _buscandoDato = false;

  List<Cancion> _similares = [];
  String _tituloSimilares = 'Si te gustó esta, prueba con...';

  @override
  void initState() {
    super.initState();
    _urlAudio = widget.cancion.urlAudio;
    _cargarAudio();
    _cargarDato();
    _cargarSimilares();
  }

  /// Si la canción es de la lista local, busca su audio real en iTunes.
  Future<void> _cargarAudio() async {
    if (_urlAudio != null) return;
    _resolviendoAudio = true;
    String? url;
    try {
      final c = widget.cancion;
      url = (await _itunes.mejorCoincidencia(c.titulo, c.artista))?.urlAudio;
    } catch (_) {
      url = null; // sin internet: se usa el reproductor simulado
    }
    if (!mounted) return;
    setState(() {
      _urlAudio = url;
      _resolviendoAudio = false;
    });
  }

  /// Primero usa la nota curada; si no hay, la busca en Wikipedia.
  Future<void> _cargarDato() async {
    final c = widget.cancion;
    final nota = _local.datoCuriosoLocalDe(c);
    if (nota != null) {
      _dato = DatoCurioso(texto: nota, fuente: 'Explorador de musica');
      return;
    }
    _buscandoDato = true;
    DatoCurioso? encontrado;
    try {
      encontrado = await _wikipedia.resumenCancion(
        titulo: c.titulo,
        artista: c.artista,
      );
    } catch (_) {
      encontrado = null;
    }
    if (!mounted) return;
    setState(() {
      _dato = encontrado;
      _buscandoDato = false;
    });
  }

  /// Locales: usa la lista de parecidas. En línea: más canciones del artista.
  Future<void> _cargarSimilares() async {
    final c = widget.cancion;
    final base = c.similaresIds.isNotEmpty
        ? c
        : _local.coincidenciaLocal(c.titulo, c.artista);
    if (base != null && base.similaresIds.isNotEmpty) {
      _similares = _local.similaresDe(base);
      return;
    }

    _tituloSimilares = 'Más de ${c.artista}';
    try {
      final resultados = await _itunes.buscar(c.artista, limite: 20);
      final vistos = <String>{};
      final otras = resultados.where((s) {
        final clave = s.titulo.toLowerCase();
        return s.id != c.id && vistos.add(clave) && clave != c.titulo.toLowerCase();
      }).take(6).toList();
      if (!mounted) return;
      setState(() => _similares = otras);
    } catch (_) {
      // Sin internet: simplemente no se muestran sugerencias.
    }
  }

  void _alCambiarReproduccion(bool reproduciendo) {
    if (reproduciendo && !_datoRevelado) {
      setState(() => _datoRevelado = true);
    }
  }

  void _alternarEnLista() {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    if (_seleccion.contiene(widget.cancion)) {
      _seleccion.quitar(widget.cancion);
      messenger.showSnackBar(const SnackBar(content: Text('Quitada de tu lista')));
    } else if (_seleccion.agregar(widget.cancion)) {
      messenger.showSnackBar(const SnackBar(content: Text('Agregada a tu lista')));
    }
  }

  void _compartir() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Compartir "${widget.cancion.titulo}" (función de ejemplo)'),
      ),
    );
  }

  Widget _construirReproductor() {
    if (_resolviendoAudio) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFE4E1D6),
          borderRadius: BorderRadius.zero,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Buscando el audio...'),
          ],
        ),
      );
    }

    if (_urlAudio != null) {
      return ReproductorAudio(
        key: ValueKey(_urlAudio),
        url: _urlAudio!,
        onReproduccionCambia: _alCambiarReproduccion,
      );
    }

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'No hay audio disponible (¿sin internet?). Reproducción simulada.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
          ),
        ),
        ReproductorSimulado(
          cancion: widget.cancion,
          onReproduccionCambia: _alCambiarReproduccion,
        ),
      ],
    );
  }

  Widget _construirDato() {
    if (!_datoRevelado) {
      return const _TarjetaDato(
        key: ValueKey('bloqueado'),
        icono: Icons.lock_outline,
        titulo: 'Dato curioso bloqueado',
        texto: 'Dale play a la canción para descubrir la historia detrás de ella.',
        color: Color(0xFF666666),
      );
    }
    if (_dato != null) {
      return _TarjetaDato(
        key: const ValueKey('dato'),
        icono: Icons.lightbulb,
        titulo: 'Dato curioso',
        texto: _dato!.texto,
        pie: 'Fuente: ${_dato!.fuente}',
        color: Color(0xFF17458E),
      );
    }
    if (_buscandoDato) {
      return const _TarjetaDato(
        key: ValueKey('buscando'),
        icono: Icons.search,
        titulo: 'Buscando la historia...',
        texto: 'Estamos revisando de dónde salió esta canción.',
        color: Color(0xFF17458E),
        cargando: true,
      );
    }
    return const _TarjetaDato(
      key: ValueKey('sin_dato'),
      icono: Icons.info_outline,
      titulo: 'Sin nota por ahora',
      texto:
          'No encontramos una nota confiable sobre esta canción. Puede que no tenga artículo en Wikipedia.',
      color: Color(0xFF666666),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cancion = widget.cancion;
    final ancho = MediaQuery.of(context).size.width;
    final tamanoPortada = (ancho * 0.6).clamp(180.0, 300.0).toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFF28658A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF17458E),
        foregroundColor: _seleccion.contiene(cancion) ? const Color(0xFF222222) : Colors.white,
        elevation: 0,
        title: Text(
          cancion.titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            tooltip: 'Compartir',
            onPressed: _compartir,
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF07385B), Color(0xFF397EA0), Color(0xFF8AB7D7)],
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 940),
            child: Container(
              margin: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F2E9),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 18, offset: Offset(0, 8))],
              ),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF17458E), Color(0xFF78A8E4)])),
                    child: const Text('SONG DETAILS', style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 14),
          Center(
            child: Hero(
              tag: 'portada_${cancion.id}',
              child: PortadaCancion(
                cancion: cancion,
                tamano: tamanoPortada,
                radio: 24,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            cancion.titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            cancion.artista,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Color(0xFF17458E)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _DatoInfo(
                icono: Icons.calendar_today,
                etiqueta: 'Año',
                valor: cancion.anioTexto,
              ),
              _DatoInfo(
                icono: Icons.timer,
                etiqueta: 'Duración',
                valor: cancion.duracionTexto,
              ),
              _DatoInfo(
                icono: cancion.icono,
                etiqueta: 'Género',
                valor: cancion.genero,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            cancion.descripcion,
            style: const TextStyle(fontSize: 15, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 16),
          _construirReproductor(),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: _construirDato(),
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: _seleccion,
            builder: (context, _) {
              final enLista = _seleccion.contiene(cancion);
              return ElevatedButton.icon(
                onPressed: _alternarEnLista,
                icon: Icon(enLista ? Icons.check : Icons.playlist_add),
                label: Text(enLista ? 'En mi lista (tocar para quitar)' : 'Agregar a mi lista'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: enLista ? const Color(0xFFD6E4F5) : const Color(0xFF2D64A8),
                  foregroundColor: enLista ? const Color(0xFF222222) : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              );
            },
          ),
          if (_similares.isNotEmpty) ...[
            const SizedBox(height: 28),
            Text(
              _tituloSimilares,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            for (final s in _similares)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: PortadaCancion(cancion: s, tamano: 48, radio: 10),
                title: Text(s.titulo, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(s.artista, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => PantallaContenido(cancion: s)),
                ),
              ),
          ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DatoInfo extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String valor;

  const _DatoInfo({
    required this.icono,
    required this.etiqueta,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icono, color: Color(0xFF17458E)),
          const SizedBox(height: 4),
          Text(etiqueta, style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
          Text(
            valor,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _TarjetaDato extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String texto;
  final String? pie;
  final Color color;
  final bool cargando;

  const _TarjetaDato({
    super.key,
    required this.icono,
    required this.titulo,
    required this.texto,
    required this.color,
    this.pie,
    this.cargando = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE4E1D6),
        borderRadius: BorderRadius.zero,
        border: Border.all(color: const Color(0xFFAAA69A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cargando
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2, color: color),
                )
              : Icon(icono, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
                const SizedBox(height: 6),
                Text(texto, style: const TextStyle(height: 1.4)),
                if (pie != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    pie!,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
