import 'package:flutter/material.dart';

import '../theme/app_theme.dart'; // Colores de las fichas

class TileWidget extends StatelessWidget { // Una ficha del tablero
  final int valor; // 0 = vacía
  const TileWidget({super.key, required this.valor});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer( // ANIMACIÓN: el color cambia suavemente al fusionar o aparecer
      duration: const Duration(milliseconds: 150),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppTheme.colorFicha(context, valor), // Color según el valor y el tema
        borderRadius: BorderRadius.circular(AppTheme.radio),
      ),
      child: valor == 0
          ? null // Vacía: sin texto
          : FittedBox( // El número se encoge si no cabe
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text('$valor',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.colorTexto(context, valor))),
        ),
      ),
    );
  }
}