import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class ScoreCard extends StatelessWidget { // Etiqueta + valor: "PUNTOS 1234"
  final String titulo;
  final String valor;
  const ScoreCard({super.key, required this.titulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Card(
      color: tema.colorScheme.primaryContainer, // Color del tema activo
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.espacio / 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(titulo, style: tema.textTheme.labelSmall),
            Text(valor, style: tema.textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}