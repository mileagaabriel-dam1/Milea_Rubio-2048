import 'package:flutter/material.dart';
import '../data/partida_dao.dart';
import '../models/partida.dart';
import '../routes.dart';
import '../widgets/async_data_view.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/partida_list_item.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});
  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  final _dao = PartidaDao();
  String _jugador = ''; // Filtro por nombre
  int _ficha = 0; // Filtro por ficha mínima
  late Future<List<Partida>> _datos = _consultar();

  Future<List<Partida>> _consultar() => _dao.historial(jugador: _jugador, fichaMinima: _ficha);

  Future<void> _recargar() async => setState(() => _datos = _consultar());

  Future<void> _borrar(Partida p) async { // Borrar + Deshacer
    await _dao.eliminar(p.id!);
    _recargar();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Partida eliminada'),
      action: SnackBarAction(label: 'Deshacer', onPressed: () async { await _dao.insertar(p); _recargar(); }),
    ));
  }

  Future<void> _detalle(Partida p) async { // Pasa el id y espera el resultado
    final borrada = await Navigator.pushNamed(context, Rutas.detalle, arguments: p.id);
    if (borrada == true) _recargar();
  }

  void _menu(Partida p) => showModalBottomSheet( // Pulsación larga
    context: context,
    builder: (c) => Wrap(children: [
      ListTile(title: const Text('Ver detalle'), onTap: () { Navigator.pop(c); _detalle(p); }),
      ListTile(title: const Text('Eliminar'), onTap: () { Navigator.pop(c); _borrar(p); }),
    ]),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: Column(children: [
        Row(children: [ // Filtros
          Expanded(child: TextField(decoration: const InputDecoration(labelText: 'Jugador'), onChanged: (t) { _jugador = t; _recargar(); })),
          DropdownButton<int>(
            value: _ficha,
            items: [for (final f in [0, 512, 1024, 2048]) DropdownMenuItem(value: f, child: Text(f == 0 ? 'Todas' : '≥ $f'))],
            onChanged: (f) { _ficha = f!; _recargar(); },
          ),
        ]),
        Expanded(
          child: AsyncDataView<List<Partida>>(
            future: _datos,
            onReintentar: _recargar,
            builder: (lista) => RefreshIndicator( // Arrastrar hacia abajo
              onRefresh: _recargar,
              child: lista.isEmpty
                  ? ListView(physics: const AlwaysScrollableScrollPhysics(), children: const [EmptyStateView(icono: Icons.history, mensaje: 'Sin partidas')])
                  : ListView(physics: const AlwaysScrollableScrollPhysics(), children: [
                for (final p in lista)
                  Dismissible( // Deslizar para borrar
                    key: ValueKey(p.id),
                    onDismissed: (_) {
                      setState(() => lista.remove(p)); // Se quita de la lista al momento
                      _borrar(p);
                    },
                    child: PartidaListItem(partida: p, onTap: () => _detalle(p), onLongPress: () => _menu(p)),
                  ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}