import 'package:sqflite/sqflite.dart'; // Para usar la BD

import '../models/usuario.dart'; // Modelo Usuario
import '../utils.dart'; // encriptar()
import 'database_helper.dart'; // Para abrir la BD

class UsuarioDao { // SQL de la tabla usuarios
  Future<Database> get _db => DatabaseHelper.instance.database; // Atajo para la BD

  Future<Usuario> registrar(String usuario, String email, String contrasena) async { // INSERT
    final db = await _db; // BD
    final nuevo = Usuario(
      usuario: usuario.trim(),
      email: email.trim(),
      contrasena: encriptar(contrasena), // Se guarda encriptada
      fechaRegistro: DateTime.now().toIso8601String(), // Fecha ISO 8601
    );
    final id = await db.insert('usuarios', nuevo.toMap()); // Si el usuario/email ya existe, lanza error (UNIQUE)
    return Usuario(id: id, usuario: nuevo.usuario, email: nuevo.email, contrasena: nuevo.contrasena, fechaRegistro: nuevo.fechaRegistro);
  }

  Future<Usuario?> login(String usuario, String contrasena) async { // SELECT
    final db = await _db; // BD
    final filas = await db.query(
      'usuarios',
      where: 'usuario = ? AND contrasena = ?', // ? = parámetros (nunca concatenar)
      whereArgs: [usuario.trim(), encriptar(contrasena)], // Comparamos con la contraseña encriptada
    );
    return filas.isEmpty ? null : Usuario.fromMap(filas.first); // null = datos incorrectos
  }
}