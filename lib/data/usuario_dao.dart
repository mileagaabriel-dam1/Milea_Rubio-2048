class Usuario { // Una fila de la tabla usuarios
  final int? id; // null hasta que se inserta
  final String usuario; // Nombre
  final String email; // Email
  final String contrasena; // Contraseña YA encriptada (hash)
  final String fechaRegistro; // Fecha en texto ISO 8601

  Usuario({this.id, required this.usuario, required this.email, required this.contrasena, required this.fechaRegistro});

  Map<String, Object?> toMap() => { // Objeto -> BD (guardar)
    'id': id,
    'usuario': usuario,
    'email': email,
    'contrasena': contrasena,
    'fecha_registro': fechaRegistro,
  };

  factory Usuario.fromMap(Map<String, Object?> m) => Usuario( // BD -> objeto (leer)
    id: m['id'] as int,
    usuario: m['usuario'] as String,
    email: m['email'] as String,
    contrasena: m['contrasena'] as String,
    fechaRegistro: m['fecha_registro'] as String,
  );
}