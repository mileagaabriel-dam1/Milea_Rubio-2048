class Partida { // Una fila de la tabla partidas
  final int? id; // null hasta que se inserta
  final int usuarioId; // Clave foránea -> usuarios.id
  final String? usuario; // Nombre del jugador (viene del JOIN, no es columna)
  final int puntuacion; // Puntos
  final int fichaMaxima; // Ficha más alta
  final int movimientos; // Movimientos hechos
  final int duracionSegundos; // Duración
  final String fecha; // Fecha en texto ISO 8601
  final int tamanoTablero; // Columna añadida en la versión 2

  Partida({
    this.id,
    required this.usuarioId,
    this.usuario,
    required this.puntuacion,
    required this.fichaMaxima,
    required this.movimientos,
    required this.duracionSegundos,
    required this.fecha,
    this.tamanoTablero = 4, // Por defecto 4
  });

  Map<String, Object?> toMap() => { // Objeto -> BD (sin "usuario", no es columna)
    'id': id,
    'usuario_id': usuarioId,
    'puntuacion': puntuacion,
    'ficha_maxima': fichaMaxima,
    'movimientos': movimientos,
    'duracion_segundos': duracionSegundos,
    'fecha': fecha,
    'tamano_tablero': tamanoTablero,
  };

  factory Partida.fromMap(Map<String, Object?> m) => Partida( // BD -> objeto
    id: m['id'] as int,
    usuarioId: m['usuario_id'] as int,
    usuario: m['usuario'] as String?,
    puntuacion: m['puntuacion'] as int,
    fichaMaxima: m['ficha_maxima'] as int,
    movimientos: m['movimientos'] as int,
    duracionSegundos: m['duracion_segundos'] as int,
    fecha: m['fecha'] as String,
    tamanoTablero: m['tamano_tablero'] as int,
  );
}