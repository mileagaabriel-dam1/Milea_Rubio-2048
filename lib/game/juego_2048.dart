import 'dart:math'; // Random

enum Direccion { arriba, abajo, izquierda, derecha } // Las 4 direcciones posibles

class Juego2048 { // Lógica del juego (sin nada de pantalla)
  List<int> tablero = List.filled(16, 0); // 16 casillas, 0 = vacía
  int puntuacion = 0; // Puntos
  int movimientos = 0; // Movimientos válidos hechos
  final _random = Random(); // Para elegir casilla y valor al azar

  Juego2048() { // Partida nueva
    _nuevaFicha(); // Empieza con
    _nuevaFicha(); // dos fichas
  }

  Juego2048.cargar(this.tablero, this.puntuacion, this.movimientos); // Partida guardada

  int get fichaMaxima => tablero.reduce(max); // La ficha más alta del tablero

  void _nuevaFicha() { // Pone un 2 (90%) o un 4 (10%) en una casilla vacía
    final vacias = [for (var i = 0; i < 16; i++) if (tablero[i] == 0) i]; // Posiciones libres
    if (vacias.isEmpty) return; // Tablero lleno
    tablero[vacias[_random.nextInt(vacias.length)]] = _random.nextInt(10) == 0 ? 4 : 2;
  }

  List<int> _linea(int n, Direccion d) { // Las 4 posiciones de una fila/columna, en el orden del movimiento
    switch (d) {
      case Direccion.izquierda: return [n * 4, n * 4 + 1, n * 4 + 2, n * 4 + 3]; // Fila n, de izq a der
      case Direccion.derecha: return [n * 4 + 3, n * 4 + 2, n * 4 + 1, n * 4]; // Fila n, de der a izq
      case Direccion.arriba: return [n, n + 4, n + 8, n + 12]; // Columna n, de arriba a abajo
      case Direccion.abajo: return [n + 12, n + 8, n + 4, n]; // Columna n, de abajo a arriba
    }
  }

  bool mover(Direccion d) { // Mueve las fichas. Devuelve true si algo ha cambiado
    final antes = List.of(tablero); // Copia para saber si cambió
    for (var n = 0; n < 4; n++) { // Para cada fila o columna
      final pos = _linea(n, d); // Sus 4 posiciones
      final valores = [for (final p in pos) if (tablero[p] != 0) tablero[p]]; // Fichas sin huecos
      final resultado = <int>[]; // La línea ya movida
      for (var i = 0; i < valores.length; i++) {
        if (i + 1 < valores.length && valores[i] == valores[i + 1]) { // Dos iguales seguidas
          resultado.add(valores[i] * 2); // Se fusionan
          puntuacion += valores[i] * 2; // Y suman puntos
          i++; // Saltamos la segunda
        } else {
          resultado.add(valores[i]); // Se queda igual
        }
      }
      while (resultado.length < 4) { resultado.add(0); } // Rellenamos con huecos
      for (var i = 0; i < 4; i++) { tablero[pos[i]] = resultado[i]; } // Escribimos en el tablero
    }
    final cambiado = antes.join() != tablero.join(); // ¿Ha cambiado algo?
    if (cambiado) { movimientos++; _nuevaFicha(); } // Si sí: cuenta el movimiento y sale ficha nueva
    return cambiado;
  }

  bool get terminado { // Fin de partida: no quedan huecos ni fusiones posibles
    if (tablero.contains(0)) return false; // Hay hueco = se puede mover
    for (var i = 0; i < 16; i++) {
      if (i % 4 < 3 && tablero[i] == tablero[i + 1]) return false; // Igual a la derecha
      if (i < 12 && tablero[i] == tablero[i + 4]) return false; // Igual abajo
    }
    return true; // No hay movimientos
  }
}