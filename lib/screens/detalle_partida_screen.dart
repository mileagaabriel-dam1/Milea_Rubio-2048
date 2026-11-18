import 'package:flutter/material.dart';
import '../data/partida_dao.dart';
import '../models/partida.dart';
import '../utils.dart';
import '../widgets/async_data_view.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/stat_card.dart';

class DetallePartidaScreen extends StatelessWidget {
  final int id; // Solo recibe el id
  const DetallePartidaScreen({super.key, required this.id});

  Future<void> _eliminar(BuildContext context) async {
    final r = await ConfirmDialog.mostrar(context, '¿Eliminar?', 'Se borrará la partida', ['Cancelar', 'Eliminar']);
    if (r != 'Eliminar') return;
    await PartidaDao().eliminar(id);
    if (context.mounted) Navigator.pop(context, true); // Devuelve true al historial
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle'), actions: [IconButton(icon: const Icon(Icons.delete), onPressed: () => _eliminar(context))]),
      body: AsyncDataView<Partida?>(
        future: PartidaDao().porId(id), // Consulta la BD con el id
        onReintentar: () {},
        builder: (p) => p == null
            ? const EmptyStateView(icono: Icons.search_off, mensaje: 'No existe')
            : ListView(children: [
          StatCard(titulo: 'Jugador', valor: '${p.usuario}', icono: Icons.person),
          StatCard(titulo: 'Puntuación', valor: '${p.puntuacion}', icono: Icons.star),
          StatCard(titulo: 'Ficha máxima', valor: '${p.fichaMaxima}', icono: Icons.grid_view),
          StatCard(titulo: 'Movimientos', valor: '${p.movimientos}', icono: Icons.swipe),
          StatCard(titulo: 'Duración', valor: formatoTiempo(p.duracionSegundos), icono: Icons.timer),
          StatCard(titulo: 'Fecha', valor: formatoFecha(p.fecha), icono: Icons.calendar_today),
        ]),
      ),
    );
  }
}