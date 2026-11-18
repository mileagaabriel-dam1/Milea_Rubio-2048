import 'dart:convert'; // jsonEncode / jsonDecode

class PartidaGuardada { // La partida en curso (siempre id = 1)
  final int usuarioId; // De quién es
  final List<int> tablero; // 16 casillas (0 = vacía)
  final int puntuacion; // Puntos
  final int movimientos; // Movimientos
  final int segundos; // Tiempo jugado

  PartidaGuardada({required this.usuarioId, required this.tablero, required this.puntuacion, required this.movimientos, required this.segundos});

  Map<String, Object?> toMap() => { // Objeto -> BD
    'id': 1, // Siempre 1: solo hay una partida guardada
    'usuario_id': usuarioId,
    'tablero': jsonEncode(tablero), // Lista -> texto "[2,0,4,...]"
    'puntuacion': puntuacion,
    'movimientos': movimientos,
    'segundos_transcurridos': segundos,
  };

  factory PartidaGuardada.fromMap(Map<String, Object?> m) => PartidaGuardada( // BD -> objeto
    usuarioId: m['usuario_id'] as int,
    tablero: List<int>.from(jsonDecode(m['tablero'] as String)), // Texto -> lista
    puntuacion: m['puntuacion'] as int,
    movimientos: m['movimientos'] as int,
    segundos: m['segundos_transcurridos'] as int,
  );
}