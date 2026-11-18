import 'package:flutter/material.dart';

class EmptyStateView extends StatelessWidget { // "No hay datos"
  final IconData icono;
  final String mensaje;
  const EmptyStateView({super.key, required this.icono, required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 64),
          Text(mensaje),
        ],
      ),
    );
  }
}