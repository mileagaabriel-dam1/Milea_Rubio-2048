import 'dart:math'; // Random, max

enum Direccion { arriba, abajo, izquierda, derecha } // Las 4 direcciones

class Ficha { // Una ficha con identidad propia (así podemos animar su movimiento)
  final int id; // Identificador único
  int valor; // 2, 4, 8...
  int pos; // Casilla donde está (0-15)
  bool nueva = true; // Acaba de aparecer -> animación de aparecer
  bool fusionada = false; // Acaba de fusionarse -> animación "pop"
  bool eliminada = false; // Se ha juntado con otra: se desliza y desaparece
  Ficha(this.id, this.valor, this.pos);
}

class Juego2048 { // Lógica del juego (sin nada de pantalla)
  static int _siguienteId = 0; // static: ids únicos aunque se reinicie la partida
  final fichas = <Ficha>[]; // Fichas del tablero
  int puntuacion = 0;
  int movimientos = 0;
  final _random = Random();

  Juego2048() { // Partida nueva: 2 fichas
    _nuevaFicha();
    _nuevaFicha();
  }

  Juego2048.cargar(List<int> tablero, this.puntuacion, this.movimientos) { // Partida guardada
    for (var i = 0; i < 16; i++) {
      if (tablero[i] != 0) fichas.add(Ficha(_siguienteId++, tablero[i], i));
    }
  }

  List<int> get tablero { // Las 16 casillas como números (para guardar en la BD)
    final t = List.filled(16, 0);
    for (final f in fichas) {
      if (!f.eliminada) t[f.pos] = f.valor;
    }
    return t;
  }

  int get fichaMaxima => tablero.reduce(max); // Ficha más alta

  void _nuevaFicha() { // Un 2 (90%) o un 4 (10%) en una casilla vacía
    final t = tablero;
    final vacias = [for (var i = 0; i < 16; i++) if (t[i] == 0) i];
    if (vacias.isEmpty) return;
    fichas.add(Ficha(_siguienteId++, _random.nextInt(10) == 0 ? 4 : 2, vacias[_random.nextInt(vacias.length)]));
  }

  List<int> _linea(int n, Direccion d) { // Las 4 casillas de una fila/columna, en el orden del movimiento
    switch (d) {
      case Direccion.izquierda: return [n * 4, n * 4 + 1, n * 4 + 2, n * 4 + 3];
      case Direccion.derecha: return [n * 4 + 3, n * 4 + 2, n * 4 + 1, n * 4];
      case Direccion.arriba: return [n, n + 4, n + 8, n + 12];
      case Direccion.abajo: return [n + 12, n + 8, n + 4, n];
    }
  }

  bool mover(Direccion d) { // Devuelve true si algo ha cambiado
    fichas.removeWhere((f) => f.eliminada); // Quitamos las que desaparecieron en el movimiento anterior
    for (final f in fichas) { f.nueva = false; f.fusionada = false; } // Reseteamos las animaciones
    final antes = tablero.join(',');
    for (var n = 0; n < 4; n++) { // Cada fila o columna
      final pos = _linea(n, d);
      final enLinea = [for (final p in pos) ...fichas.where((f) => f.pos == p)]; // Sus fichas, en orden
      var destino = 0; // Siguiente casilla libre
      for (var i = 0; i < enLinea.length; i++) {
        final f = enLinea[i];
        f.pos = pos[destino]; // La ficha se desliza hasta aquí
        if (i + 1 < enLinea.length && enLinea[i + 1].valor == f.valor) { // Dos iguales seguidas
          final otra = enLinea[i + 1];
          otra.pos = pos[destino]; // La otra va a la misma casilla...
          otra.eliminada = true; // ...y desaparece
          f.valor *= 2; // Esta se queda con el doble
          f.fusionada = true; // -> animación pop
          puntuacion += f.valor;
          i++; // Saltamos la otra
        }
        destino++;
      }
    }
    final cambiado = antes != tablero.join(','); // ¿Ha cambiado algo?
    if (cambiado) { movimientos++; _nuevaFicha(); }
    return cambiado;
  }

  bool get terminado { // No hay huecos ni fusiones posibles
    final t = tablero;
    if (t.contains(0)) return false;
    for (var i = 0; i < 16; i++) {
      if (i % 4 < 3 && t[i] == t[i + 1]) return false; // Igual a la derecha
      if (i < 12 && t[i] == t[i + 4]) return false; // Igual abajo
    }
    return true;
  }
}