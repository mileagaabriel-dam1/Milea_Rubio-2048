import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Teclas del teclado

import '../game/juego_2048.dart'; // Direccion
import '../theme/app_theme.dart';
import 'tile_widget.dart';

class BoardWidget extends StatefulWidget { // El tablero 4x4 + los gestos
  final List<int> valores; // Las 16 fichas
  final void Function(Direccion) onMover; // Avisa a la pantalla de hacia dónde mover
  const BoardWidget({super.key, required this.valores, required this.onMover});

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> { // Stateful: necesita recordar cuánto se ha arrastrado
  Offset _arrastre = Offset.zero; // Distancia recorrida por el dedo

  void _alSoltar() { // Al levantar el dedo decidimos la dirección
    final d = _arrastre;
    _arrastre = Offset.zero;
    if (d.distance < 30) return; // UMBRAL: ignora deslizamientos muy cortos
    if (d.dx.abs() > d.dy.abs()) { // Dirección dominante: horizontal
      widget.onMover(d.dx > 0 ? Direccion.derecha : Direccion.izquierda);
    } else { // Dirección dominante: vertical
      widget.onMover(d.dy > 0 ? Direccion.abajo : Direccion.arriba);
    }
  }

  KeyEventResult _alPulsarTecla(FocusNode nodo, KeyEvent e) { // Flechas del teclado (alternativa accesible)
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final teclas = {
      LogicalKeyboardKey.arrowUp: Direccion.arriba,
      LogicalKeyboardKey.arrowDown: Direccion.abajo,
      LogicalKeyboardKey.arrowLeft: Direccion.izquierda,
      LogicalKeyboardKey.arrowRight: Direccion.derecha,
    };
    final dir = teclas[e.logicalKey];
    if (dir == null) return KeyEventResult.ignored; // Otra tecla
    widget.onMover(dir);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    return Focus( // Para recibir el teclado
      autofocus: true,
      onKeyEvent: _alPulsarTecla,
      child: GestureDetector( // onPan* = movimiento libre en 2D; así elegimos nosotros el eje dominante
        onPanStart: (_) => _arrastre = Offset.zero,
        onPanUpdate: (d) => _arrastre += d.delta, // Vamos sumando el movimiento
        onPanEnd: (_) => _alSoltar(),
        child: AspectRatio( // Siempre cuadrado
          aspectRatio: 1,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppTheme.colorTablero(context),
              borderRadius: BorderRadius.circular(AppTheme.radio),
            ),
            child: GridView.count( // Cuadrícula de 4 columnas
              crossAxisCount: 4,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              physics: const NeverScrollableScrollPhysics(), // Que no haga scroll
              children: [for (final v in widget.valores) TileWidget(valor: v)],
            ),
          ),
        ),
      ),
    );
  }
}