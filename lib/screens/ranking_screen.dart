import 'package:flutter/material.dart';
import '../data/partida_dao.dart';
import '../models/estadisticas.dart';
import '../models/partida.dart';
import '../utils.dart';
import '../widgets/async_data_view.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/partida_list_item.dart';
import '../widgets/stat_card.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});
  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final _dao = PartidaDao();
  late Future<List<Object>> _datos = _consultar();

  Future<List<Object>> _consultar() async => [await _dao.ranking(), await _dao.estadisticas(), await _dao.porJugador()]; // Las 3 consultas

  Future<void> _recargar() async => setState(() => _datos = _consultar());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ranking')),
      body: AsyncDataView<List<Object>>(
        future: _datos,
        onReintentar: _recargar,
        builder: (d) {
          final top = d[0] as List<Partida>;
          final g = d[1] as EstadisticasGlobales;
          final jugadores = d[2] as List<EstadisticaJugador>;
          return RefreshIndicator( // Arrastrar hacia abajo
            onRefresh: _recargar,
            child: ListView(physics: const AlwaysScrollableScrollPhysics(), children: [
              if (top.isEmpty) const EmptyStateView(icono: Icons.leaderboard, mensaje: 'Sin partidas'),
              StatCard(titulo: 'Partidas', valor: '${g.total}', icono: Icons.games),
              StatCard(titulo: 'Máxima', valor: '${g.maxPuntos}', icono: Icons.star),
              StatCard(titulo: 'Media', valor: g.media.toStringAsFixed(0), icono: Icons.calculate),
              StatCard(titulo: 'Ficha máxima', valor: '${g.maxFicha}', icono: Icons.grid_view),
              StatCard(titulo: 'Tiempo total', valor: formatoTiempo(g.tiempoTotal), icono: Icons.timer),
              const ListTile(title: Text('Top 10')),
              for (var i = 0; i < top.length; i++) PartidaListItem(partida: top[i], posicion: i + 1),
              const ListTile(title: Text('Por jugador')),
              for (final j in jugadores) ListTile(title: Text(j.usuario), subtitle: Text('${j.partidas} partidas'), trailing: Text('${j.mejor}')),
            ]),
          );
        },
      ),
    );
  }
}