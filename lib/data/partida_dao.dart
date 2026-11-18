import 'package:sqflite/sqflite.dart'; // Para usar la BD

import '../models/estadisticas.dart'; // Modelos de estadísticas
import '../models/partida.dart'; // Modelo Partida
import 'database_helper.dart'; // Para abrir la BD

class PartidaDao { // Todo el SQL de la tabla partidas
  Future<Database> get _db => DatabaseHelper.instance.database; // Atajo para la BD

  // SQL que se repite: partidas + nombre del jugador (JOIN)
  static const _select = 'SELECT p.*, u.usuario FROM partidas p JOIN usuarios u ON p.usuario_id = u.id';

  Future<int> insertar(Partida p) async { // INSERT
    final db = await _db; // BD
    return db.insert('partidas', p.toMap()); // Devuelve el id nuevo
  }

  Future<List<Partida>> historial({String jugador = '', int fichaMinima = 0}) async { // Historial con filtros
    final db = await _db; // BD
    final filas = await db.rawQuery( // SELECT con JOIN
      '$_select WHERE u.usuario LIKE ? AND p.ficha_maxima >= ? ORDER BY p.fecha DESC', // Filtros + orden
      ['%$jugador%', fichaMinima], // Si jugador = '' y ficha = 0, salen todas
    );
    return filas.map(Partida.fromMap).toList(); // Filas -> objetos
  }

  Future<Partida?> porId(int id) async { // Detalle de una partida
    final db = await _db; // BD
    final filas = await db.rawQuery('$_select WHERE p.id = ?', [id]); // Busca por id
    return filas.isEmpty ? null : Partida.fromMap(filas.first); // null si no existe
  }

  Future<void> eliminar(int id) async { // DELETE de una
    final db = await _db; // BD
    await db.delete('partidas', where: 'id = ?', whereArgs: [id]); // Solo la de ese id
  }

  Future<void> eliminarTodo() async { // DELETE de todas
    final db = await _db; // BD
    await db.delete('partidas'); // Sin where = todas
  }

  Future<List<Partida>> ranking() async { // Top 10
    final db = await _db; // BD
    final filas = await db.rawQuery('$_select ORDER BY p.puntuacion DESC LIMIT 10'); // ORDER BY + LIMIT
    return filas.map(Partida.fromMap).toList(); // Filas -> objetos
  }

  Future<EstadisticasGlobales> estadisticas() async { // COUNT, MAX, AVG, SUM
    final db = await _db; // BD
    final filas = await db.rawQuery(
      'SELECT COUNT(*) AS total, MAX(puntuacion) AS max_puntos, AVG(puntuacion) AS media_puntos, '
          'MAX(ficha_maxima) AS max_ficha, SUM(duracion_segundos) AS tiempo_total FROM partidas',
    ); // AS = nombre con el que lo leemos en fromMap
    return EstadisticasGlobales.fromMap(filas.first); // Una sola fila
  }

  Future<List<EstadisticaJugador>> porJugador() async { // GROUP BY
    final db = await _db; // BD
    final filas = await db.rawQuery(
      'SELECT u.usuario, MAX(p.puntuacion) AS mejor, COUNT(*) AS num_partidas '
          'FROM partidas p JOIN usuarios u ON p.usuario_id = u.id '
          'GROUP BY u.id ORDER BY mejor DESC',
    ); // Una fila por jugador
    return filas.map(EstadisticaJugador.fromMap).toList(); // Filas -> objetos
  }

  Future<int> mejorPuntuacion(int usuarioId) async { // Récord de un jugador
    final db = await _db; // BD
    final filas = await db.rawQuery('SELECT MAX(puntuacion) FROM partidas WHERE usuario_id = ?', [usuarioId]);
    return Sqflite.firstIntValue(filas) ?? 0; // Primer número de la consulta, o 0
  }

  Future<void> terminarPartida(Partida p) async { // TRANSACCIÓN: o se hace todo o nada
    final db = await _db; // BD
    await db.transaction((txn) async { // Dentro se usa txn, no db
      await txn.insert('partidas', p.toMap()); // 1) Guarda en el historial
      await txn.delete('partida_guardada'); // 2) Borra la partida en curso
    });
  }
}