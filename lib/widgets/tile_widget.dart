import 'dart:math'; // sin, pi
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class TileWidget extends StatelessWidget { // Una ficha
  final int valor; // 0 = casilla vacía
  final bool nueva; // Animación de aparecer
  final bool fusionada; // Animación "pop"
  const TileWidget({super.key, required this.valor, this.nueva = false, this.fusionada = false});

  @override
  Widget build(BuildContext context) {
    final ficha = Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppTheme.colorFicha(context, valor),
        borderRadius: BorderRadius.circular(AppTheme.radio),
        boxShadow: valor == 0 ? null : const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))], // Sombra
      ),
      child: valor == 0
          ? null
          : FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Text('$valor', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.colorTexto(context, valor))),
        ),
      ),
    );
    if (!nueva && !fusionada) return ficha; // Ficha normal: sin animación

    return TweenAnimationBuilder<double>( // ANIMACIÓN: t va de 0 a 1
      key: ValueKey('$valor$nueva'), // Si cambia el valor, vuelve a empezar
      tween: Tween(begin: 0.0, end: 1.0),
      duration: AppTheme.animacion * 2,
      curve: const Interval(0.5, 1.0), // Espera a que termine el deslizamiento
      builder: (context, t, child) => Transform.scale(
        scale: nueva ? Curves.easeOutBack.transform(t) : 1 + 0.2 * sin(t * pi), // Nueva: crece | Fusionada: 1 -> 1.2 -> 1 (pop)
        child: child,
      ),
      child: ficha,
    );
  }
}