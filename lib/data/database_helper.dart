import 'package:path/path.dart'; // Trae join() para construir la ruta del archivo .db
import 'package:sqflite/sqflite.dart'; // Trae Database, openDatabase, getDatabasesPath...

// Clase que abre la base de datos y crea las tablas.
// Es un SINGLETON: solo existe UNA instancia en toda la app.
class DatabaseHelper { // Declaramos la clase
  DatabaseHelper._(); // Constructor privado (el _ lo hace privado): nadie puede hacer DatabaseHelper() desde fuera
  static final DatabaseHelper instance = DatabaseHelper._(); // La ÚNICA instancia. Se usa así: DatabaseHelper.instance

  static const String nombreBD = 'game2048.db'; // Nombre del archivo de la base de datos
  static const int version = 2; // Versión del esquema. Empezó en 1; al añadir tamano_tablero subió a 2

  static const String tUsuarios = 'usuarios'; // Nombre de la tabla usuarios (constante para no repetir el texto)
  static const String tPartidas = 'partidas'; // Nombre de la tabla partidas
  static const String tPartidaGuardada = 'partida_guardada'; // Nombre de la tabla partida_guardada

  Database? _db; // Aquí guardamos la BD abierta. ? = al principio es null (aún no se ha abierto)

  Future<Database> get database async { // Getter: cuando alguien pide DatabaseHelper.instance.database...
    _db ??= await _abrir(); // ??= significa: si _db es null, ábrela; si ya está abierta, no hagas nada
    return _db!; // Devolvemos la BD. El ! le dice a Dart "aquí ya no es null"
  } // Fin del getter

  Future<Database> _abrir() async { // Método privado que abre (o crea) el archivo .db
    final ruta = join(await getDatabasesPath(), nombreBD); // Carpeta de BDs del móvil + "game2048.db"
    return openDatabase( // Abre la BD. Si no existe, la crea
      ruta, // Dónde está el archivo
      version: version, // Versión que queremos (2)
      onConfigure: _onConfigure, // Se ejecuta SIEMPRE al abrir
      onCreate: _onCreate, // Se ejecuta solo la PRIMERA vez (el archivo no existía)
      onUpgrade: _onUpgrade, // Se ejecuta si el móvil tenía una versión MÁS ANTIGUA
    ); // Fin de openDatabase
  } // Fin de _abrir

  Future<void> _onConfigure(Database db) async { // Configuración al abrir
    await db.execute('PRAGMA foreign_keys = ON'); // SQLite trae las claves foráneas APAGADAS: las encendemos
  } // Fin de _onConfigure

  Future<void> _onCreate(Database db, int version) async { // Primera vez que se abre la app
    await _crearTablasV1(db); // Crea las tablas como eran en la versión 1
    await _onUpgrade(db, 1, version); // Y aplica las migraciones hasta la versión actual (1 -> 2)
  } // Así un móvil nuevo y uno que actualiza acaban con las MISMAS tablas

  Future<void> _onUpgrade(Database db, int versionVieja, int versionNueva) async { // Actualizar la BD
    if (versionVieja < 2) { // Si el móvil tenía la versión 1...
      await _migrarAV2(db); // ...aplicamos la migración a la versión 2
    } // Si un día hay versión 3: if (versionVieja < 3) await _migrarAV3(db);
  } // Fin de _onUpgrade

  Future<void> _crearTablasV1(Database db) async { // Crea las 3 tablas de la versión 1
    await db.execute('''
      CREATE TABLE $tUsuarios (
        id             INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario        TEXT NOT NULL UNIQUE,
        email          TEXT NOT NULL UNIQUE,
        contrasena     TEXT NOT NULL,
        sal            TEXT NOT NULL,
        fecha_registro TEXT NOT NULL
      )
    '''); // Tabla usuarios. UNIQUE = no puede haber dos usuarios o emails iguales

    await db.execute('''
      CREATE TABLE $tPartidas (
        id                INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id        INTEGER NOT NULL,
        puntuacion        INTEGER NOT NULL,
        ficha_maxima      INTEGER NOT NULL,
        movimientos       INTEGER NOT NULL,
        duracion_segundos INTEGER NOT NULL,
        fecha             TEXT NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES $tUsuarios(id) ON DELETE CASCADE
      )
    '''); // Tabla partidas. FOREIGN KEY = usuario_id apunta a usuarios.id. CASCADE = si borras el usuario, se borran sus partidas

    await db.execute('''
      CREATE TABLE $tPartidaGuardada (
        id                     INTEGER PRIMARY KEY CHECK (id = 1),
        usuario_id             INTEGER NOT NULL,
        tablero                TEXT NOT NULL,
        puntuacion             INTEGER NOT NULL,
        movimientos            INTEGER NOT NULL,
        segundos_transcurridos INTEGER NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES $tUsuarios(id) ON DELETE CASCADE
      )
    '''); // Tabla partida_guardada. CHECK (id = 1) = la BD solo deja que exista la fila con id 1
  } // Fin de _crearTablasV1

  Future<void> _migrarAV2(Database db) async { // MIGRACIÓN de la versión 1 a la 2
    await db.execute( // Ejecuta SQL
      'ALTER TABLE $tPartidas ADD COLUMN tamano_tablero INTEGER NOT NULL DEFAULT 4', // Añade una columna nueva
    ); // Las partidas que ya existían reciben 4 automáticamente: NO se pierde ningún dato
  } // Fin de _migrarAV2
} // Fin de la clase