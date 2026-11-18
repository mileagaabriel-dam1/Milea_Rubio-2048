class EstadisticasGlobales { // Resultado de COUNT, MAX, AVG, SUM
  final int total; // Partidas jugadas
  final int maxPuntos; // Mejor puntuación
  final double media; // Puntuación media
  final int maxFicha; // Ficha más alta
  final int tiempoTotal; // Segundos jugados en total

  EstadisticasGlobales.fromMap(Map<String, Object?> m) // Si no hay partidas vienen null -> 0
      : total = m['total'] as int? ?? 0,
        maxPuntos = m['max_puntos'] as int? ?? 0,
        media = (m['media_puntos'] as num? ?? 0).toDouble(),
        maxFicha = m['max_ficha'] as int? ?? 0,
        tiempoTotal = m['tiempo_total'] as int? ?? 0;
}

class EstadisticaJugador { // Una fila del GROUP BY
  final String usuario; // Nombre
  final int mejor; // Su mejor puntuación
  final int partidas; // Cuántas ha jugado

  EstadisticaJugador.fromMap(Map<String, Object?> m)
      : usuario = m['usuario'] as String,
        mejor = m['mejor'] as int,
        partidas = m['num_partidas'] as int;
}