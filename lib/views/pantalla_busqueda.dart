import 'dart:async';

import 'package:flutter/material.dart';

import '../datasources/itunes_datasource.dart';
import '../models/cancion.dart';
import '../widgets/tarjeta_cancion.dart';
import 'pantalla_contenido.dart';

enum _Estado { inicial, cargando, listo, error }

/// Busca cualquier canción en línea (API de iTunes) y abre su detalle.
class PantallaBusqueda extends StatefulWidget {
  final String consultaInicial;

  const PantallaBusqueda({super.key, this.consultaInicial = ''});

  @override
  State<PantallaBusqueda> createState() => _PantallaBusquedaState();
}

class _PantallaBusquedaState extends State<PantallaBusqueda> {
  final _itunes = ItunesDatasource.instancia;
  late final TextEditingController _controlador;
  Timer? _debounce;

  _Estado _estado = _Estado.inicial;
  List<Cancion> _resultados = [];

  @override
  void initState() {
    super.initState();
    _controlador = TextEditingController(text: widget.consultaInicial);
    if (widget.consultaInicial.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _buscar(widget.consultaInicial),
      );
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controlador.dispose();
    super.dispose();
  }

  void _alEscribir(String texto) {
    _debounce?.cancel();
    if (texto.trim().isEmpty) {
      setState(() {
        _estado = _Estado.inicial;
        _resultados = [];
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 500), () => _buscar(texto));
  }

  Future<void> _buscar(String texto) async {
    final termino = texto.trim();
    if (termino.isEmpty) return;
    setState(() => _estado = _Estado.cargando);

    try {
      final resultados = await _itunes.buscar(termino);
      // Si el usuario siguió escribiendo, ignoramos esta respuesta vieja.
      if (!mounted || _controlador.text.trim() != termino) return;
      setState(() {
        _resultados = resultados;
        _estado = _Estado.listo;
      });
    } catch (_) {
      if (!mounted || _controlador.text.trim() != termino) return;
      setState(() => _estado = _Estado.error);
    }
  }

  void _abrirDetalle(Cancion cancion) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PantallaContenido(cancion: cancion)),
    );
  }

  Widget _mensaje(IconData icono, String texto, {Widget? accion}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 48, color: const Color(0xFF6685AC)),
            const SizedBox(height: 12),
            Text(
              texto,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF555555), fontFamily: 'monospace'),
            ),
            if (accion != null) ...[const SizedBox(height: 12), accion],
          ],
        ),
      ),
    );
  }

  Widget _contenido() {
    switch (_estado) {
      case _Estado.inicial:
        return _mensaje(
          Icons.travel_explore,
          'Escribe el nombre de una canción o artista y toca para escucharla.',
        );
      case _Estado.cargando:
        return const Center(
          child: CircularProgressIndicator(color: const Color(0xFF17458E)),
        );
      case _Estado.error:
        return _mensaje(
          Icons.wifi_off,
          'No se pudo conectar. Revisa tu internet e intenta de nuevo.',
          accion: OutlinedButton(
            onPressed: () => _buscar(_controlador.text),
            child: const Text('Reintentar'),
          ),
        );
      case _Estado.listo:
        if (_resultados.isEmpty) {
          return _mensaje(Icons.search_off, 'No encontramos resultados.');
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          itemCount: _resultados.length,
          itemBuilder: (context, i) => TarjetaCancion(
            cancion: _resultados[i],
            onTap: () => _abrirDetalle(_resultados[i]),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF28658A),
      appBar: AppBar(
        title: const Text('Music Explorer - Buscar música'),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF17458E),
        elevation: 0,
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
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4F2E9),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 18, offset: Offset(0, 8))],
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFF17458E), Color(0xFF78A8E4)]),
                    ),
                    child: const Text('SEARCH MUSIC ONLINE', style: TextStyle(color: Colors.white, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
                    child: TextField(
              controller: _controlador,
              autofocus: widget.consultaInicial.isEmpty,
              textInputAction: TextInputAction.search,
              onChanged: _alEscribir,
              onSubmitted: _buscar,
              decoration: InputDecoration(
                hintText: 'Canción o artista...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF17458E)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Color(0xFF8A877B)),
                ),
              ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: const Color(0xFFAAA69A))),
                      child: Theme(
                        data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Color(0xFF17458E))),
                        child: _contenido(),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Vistas previas y portadas: iTunes Search API', style: TextStyle(fontSize: 11, color: Color(0xFF555555), fontFamily: 'monospace')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
