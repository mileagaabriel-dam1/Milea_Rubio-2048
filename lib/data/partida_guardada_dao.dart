import 'package:sqflite/sqflite.dart'; // Para usar la BD

import '../models/partida_guardada.dart'; // Modelo PartidaGuardada
import 'database_helper.dart'; // Para abrir la BD

class PartidaGuardadaDao { // SQL de la partida en curso
  Future<Database> get _db => DatabaseHelper.instance.database; // Atajo para la BD

  Future<void> guardar(PartidaGuardada p) async { // Guardar
    final db = await _db; // BD
    await db.insert('partida_guardada', p.toMap(), // INSERT...
        conflictAlgorithm: ConflictAlgorithm.replace); // ...y si ya existe, la reemplaza
  }

  Future<PartidaGuardada?> obtener(int usuarioId) async { // Recuperar
    final db = await _db; // BD
    final filas = await db.query('partida_guardada', where: 'usuario_id = ?', whereArgs: [usuarioId]);
    return filas.isEmpty ? null : PartidaGuardada.fromMap(filas.first); // null = no hay
  }

  Future<void> borrar() async { // Borrar
    final db = await _db; // BD
    await db.delete('partida_guardada'); // Solo hay una fila
  }
}