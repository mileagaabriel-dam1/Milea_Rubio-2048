import 'package:flutter/material.dart';

import 'screens/detalle_partida_screen.dart';
import 'screens/home_shell.dart';
import 'screens/juego_screen.dart';
import 'screens/login_screen.dart';

class Rutas { // TODAS las rutas de la app en un solo sitio
  static const login = '/';
  static const home = '/home';
  static const juego = '/juego';
  static const detalle = '/detalle';

  static Route<dynamic> generar(RouteSettings s) { // Crea la pantalla según el nombre
    switch (s.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeShell());
      case juego:
        return MaterialPageRoute(builder: (_) => JuegoScreen(continuar: s.arguments as bool)); // Recibe si continuar
      case detalle:
        return MaterialPageRoute(builder: (_) => DetallePartidaScreen(id: s.arguments as int)); // Recibe el id
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}