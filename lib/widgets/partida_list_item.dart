import 'package:flutter/material.dart';

import '../models/partida.dart';
import '../utils.dart'; // formatoFecha

class PartidaListItem extends StatelessWidget { // Una partida en una lista
  final Partida partida;
  final int? posicion; // Puesto en el ranking (null en el historial)
  final VoidCallback? onTap; // Pulsación simple
  final VoidCallback? onLongPress; // Pulsación larga
  const PartidaListItem({super.key, required this.partida, this.posicion, this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: FittedBox(child: Text(posicion != null ? '#$posicion' : '${partida.fichaMaxima}'))),
      title: Text('${partida.puntuacion} puntos'),
      subtitle: Text('${partida.usuario} · ficha ${partida.fichaMaxima} · ${formatoFecha(partida.fecha)}'),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}