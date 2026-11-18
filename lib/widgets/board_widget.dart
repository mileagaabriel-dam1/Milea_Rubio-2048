import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Teclado
import '../game/juego_2048.dart';
import '../theme/app_theme.dart';
import 'tile_widget.dart';

class BoardWidget extends StatefulWidget { // Tablero 4x4 + gestos + animaciones
  final List<Ficha> fichas;
  final void Function(Direccion) onMover; // Avisa a la pantalla
  const BoardWidget({super.key, required this.fichas, required this.onMover});

  @override
  State<BoardWidget> createState() => _BoardWidgetState();
}

class _BoardWidgetState extends State<BoardWidget> {
  Offset _arrastre = Offset.zero; // Cuánto se ha movido el dedo

  void _alSoltar() { // Al levantar el dedo decidimos la dirección
    final d = _arrastre;
    _arrastre = Offset.zero;
    if (d.distance < 30) return; // UMBRAL: ignora movimientos cortos
    if (d.dx.abs() > d.dy.abs()) {
      widget.onMover(d.dx > 0 ? Direccion.derecha : Direccion.izquierda); // Horizontal
    } else {
      widget.onMover(d.dy > 0 ? Direccion.abajo : Direccion.arriba); // Vertical
    }
  }

  KeyEventResult _tecla(FocusNode nodo, KeyEvent e) { // Flechas del teclado
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final dir = {
      LogicalKeyboardKey.arrowUp: Direccion.arriba,
      LogicalKeyboardKey.arrowDown: Direccion.abajo,
      LogicalKeyboardKey.arrowLeft: Direccion.izquierda,
      LogicalKeyboardKey.arrowRight: Direccion.derecha,
    }[e.logicalKey];
    if (dir == null) return KeyEventResult.ignored;
    widget.onMover(dir);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: _tecla,
      child: GestureDetector( // onPan: movimiento en 2D, elegimos nosotros el eje dominante
        onPanStart: (_) => _arrastre = Offset.zero,
        onPanUpdate: (d) => _arrastre += d.delta,
        onPanEnd: (_) => _alSoltar(),
        child: AspectRatio(
          aspectRatio: 1, // Cuadrado
          child: Container(
            decoration: BoxDecoration(color: AppTheme.colorTablero(context), borderRadius: BorderRadius.circular(AppTheme.radio)),
            child: LayoutBuilder(builder: (context, c) {
              const sep = AppTheme.separacion;
              final celda = (c.maxWidth - sep * 5) / 4; // Tamaño de cada casilla
              double x(int pos) => sep + (pos % 4) * (celda + sep); // Columna -> píxeles
              double y(int pos) => sep + (pos ~/ 4) * (celda + sep); // Fila -> píxeles
              final orden = [...widget.fichas.where((f) => f.eliminada), ...widget.fichas.where((f) => !f.eliminada)]; // Las que desaparecen, debajo
              return Stack(children: [
                for (var p = 0; p < 16; p++) // Casillas vacías de fondo
                  Positioned(left: x(p), top: y(p), width: celda, height: celda, child: const TileWidget(valor: 0)),
                for (final f in orden)
                  AnimatedPositioned( // ANIMACIÓN de movimiento: se desliza a su nueva casilla
                    key: ValueKey(f.id),
                    duration: AppTheme.animacion,
                    curve: Curves.easeInOut,
                    left: x(f.pos),
                    top: y(f.pos),
                    width: celda,
                    height: celda,
                    child: TileWidget(valor: f.valor, nueva: f.nueva, fusionada: f.fusionada),
                  ),
              ]);
            }),
          ),
        ),
      ),
    );
  }
}