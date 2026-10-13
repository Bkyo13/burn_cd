import 'package:flutter/material.dart';
import '../controllers/seleccion_musical_controller.dart';
import '../datasources/canciones_datasource.dart';
import '../models/cancion.dart';
import '../widgets/disco_cd.dart';
import 'pantalla_busqueda.dart';
import 'pantalla_contenido.dart';

/// Explorador musical con interfaz clásica inspirada en Windows.
class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final _datasource = CancionesDatasource.instancia;
  final _seleccion = SeleccionMusicalController.instancia;
  final _busqueda = TextEditingController();
  String _consulta = '';

  List<Cancion> get _resultados {
    final q = _consulta.trim().toLowerCase();
    return _datasource.obtenerTodas().where((c) {
      return q.isEmpty ||
          c.titulo.toLowerCase().contains(q) ||
          c.artista.toLowerCase().contains(q) ||
          c.genero.toLowerCase().contains(q);
    }).toList();
  }

  void _buscarOnline() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PantallaBusqueda(consultaInicial: _consulta),
    ));
  }

  void _abrirDetalle(Cancion cancion) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PantallaContenido(cancion: cancion)),
    );
  }

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF07385B),
              Color(0xFF397EA0),
              Color(0xFF8AB7D7),
              Color(0xFF164D70),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              left: -70,
              child: _orb(300, const Color(0x334AC6D8)),
            ),
            Positioned(
              bottom: -100,
              right: -50,
              child: _orb(360, const Color(0x3347D4CF)),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 940,
                    maxHeight: 650,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F2E9),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 24,
                          offset: Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _barraTitulo(),
                        Expanded(
                          child: Row(
                            children: [
                              _panelPasos(),
                              Expanded(child: _contenidoPrincipal()),
                            ],
                          ),
                        ),
                        _barraInferior(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _barraTitulo() {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF17458E), Color(0xFF78A8E4)],
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.album, color: Color(0xFFFFE7A1), size: 19),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Explorador de musica jeje',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
                fontSize: 14,
              ),
            ),
          ),
          InkWell(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 24,
              height: 23,
              alignment: Alignment.center,
              color: const Color(0xFFECE9D8),
              child: const Text(
                '×',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _panelPasos() {
    return Container(
      width: 160,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF102D70), Color(0xFF326FC1), Color(0xFFA7C9ED)],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 22),
          const DiscoCd(tamano: 62),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'LIBRERIA DE MUSICA',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFDBE6FA),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              'Puedes buscar una cancion de tu agrado y descubre que puede tener datos curiosos mientras la escuchas!!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFDBE6FA), fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contenidoPrincipal() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Explorador de musica',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Puedes buscar una cancion de tu agrado y descubre que puede tener datos curiosos mientras la escuchas!!',
            style: TextStyle(
              color: Color(0xFF333333),
              fontSize: 13,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 16),
          _filaBusqueda(),
          const SizedBox(height: 10),
          Expanded(flex: 5, child: _panelResultados()),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'mi playlist :)(${_seleccion.pistas.length})',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'monospace',
                ),
              ),
              const Spacer(),
              Text(
                'Duration: ${Cancion.formatear(_seleccion.duracionTotal)}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.black87,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(flex: 3, child: _panelPistasSeleccionadas()),
        ],
      ),
    );
  }

  Widget _filaBusqueda() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 31,
            child: TextField(
              controller: _busqueda,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _buscarOnline(),
              onChanged: (v) => setState(() => _consulta = v),
              style: const TextStyle(color: Colors.black, fontSize: 13),
              decoration: const InputDecoration(
                hintText: 'Busca canciones online!',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Color(0xFF8C8C8C)),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _classicButton('Search', _buscarOnline),
      ],
    );
  }

  Widget _panelResultados() {
    Widget contenido;
    if (_resultados.isEmpty) {
        contenido = const Center(
          child: Text('No se encontraron canciones papoi...', style: TextStyle(color: Colors.grey)),
        );
      } else {
        contenido = ListView.builder(
          itemCount: _resultados.length,
          itemBuilder: (context, i) {
            final cancion = _resultados[i];
            final agregado = _seleccion.pistas.any((p) => p.id == cancion.id);
            return ListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              leading: Icon(cancion.icono, color: const Color(0xFF315FA3), size: 19),
              title: Text(
                cancion.titulo,
                style: const TextStyle(color: Colors.black, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${cancion.artista} · ${cancion.duracionTexto}',
                style: const TextStyle(color: Colors.black54, fontSize: 11),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Escuchar vista previa y ver datos curiosos',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.play_circle_outline, size: 20),
                    color: const Color(0xFF315FA3),
                    onPressed: () => _abrirDetalle(cancion),
                  ),
                  TextButton(
                    onPressed: agregado
                        ? null
                        : () {
                            setState(() => _seleccion.agregar(cancion));
                          },
                    child: Text(
                      agregado ? 'Added' : 'Add',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
              onTap: () => _abrirDetalle(cancion),
            );
          },
        );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFAAA69A)),
      ),
      child: contenido,
    );
  }

  Widget _panelPistasSeleccionadas() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFAAA69A)),
      ),
      child: AnimatedBuilder(
        animation: _seleccion,
        builder: (context, _) {
          if (_seleccion.pistas.isEmpty) {
            return const Center(
              child: Text(
                'Aun no hay musica en tu lista...',
                style: TextStyle(color: Colors.grey, fontFamily: 'monospace', fontSize: 12),
              ),
            );
          }
          return ListView.builder(
            itemCount: _seleccion.pistas.length,
            itemBuilder: (context, i) {
              final cancion = _seleccion.pistas[i];
              return ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: Text('${i + 1}.', style: const TextStyle(color: Colors.black54)),
                title: Text(
                  cancion.titulo,
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(cancion.artista, style: const TextStyle(color: Colors.black54, fontSize: 11)),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 16, color: Colors.black54),
                  onPressed: () => setState(() => _seleccion.quitar(cancion)),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _barraInferior() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        color: Color(0xFFECE9D8),
        border: Border(top: BorderSide(color: Color(0xFFB8B5AA))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _classicButton('Close', () => Navigator.maybePop(context)),
        ],
      ),
    );
  }

  Widget _orb(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );

  Widget _classicButton(String text, VoidCallback onPressed, {bool enabled = true}) {
    return SizedBox(
      height: 31,
      child: OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFECE9D8),
          foregroundColor: Colors.black,
          disabledForegroundColor: Colors.grey,
          side: const BorderSide(color: Color(0xFFB8B5AA)),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: const EdgeInsets.symmetric(horizontal: 17),
        ),
        child: Text(
          text,
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
