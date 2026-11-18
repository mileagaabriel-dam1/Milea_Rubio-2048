import 'dart:math'; // log()
import 'package:flutter/material.dart';

class AppTheme { // Colores, tamaños y estilos de toda la app
  static const double espacio = 16; // Espaciado general
  static const double radio = 8; // Esquinas redondeadas
  static const TextStyle titulo = TextStyle(fontSize: 56, fontWeight: FontWeight.bold); // Título "2048"

  static const List<Color> colores = [Colors.orange, Colors.blue, Colors.green, Colors.purple]; // Colores a elegir
  static const List<String> nombresColores = ['Naranja', 'Azul', 'Verde', 'Morado'];

  static ThemeData claro(int color) => ThemeData(colorSchemeSeed: colores[color], brightness: Brightness.light); // Tema claro
  static ThemeData oscuro(int color) => ThemeData(colorSchemeSeed: colores[color], brightness: Brightness.dark); // Tema oscuro

  static Color colorFicha(BuildContext context, int valor) { // Color de una ficha según su valor
    final esquema = Theme.of(context).colorScheme; // Colores del tema ACTIVO (claro u oscuro)
    if (valor == 0) return esquema.surface; // Casilla vacía
    final paso = log(valor) / log(2); // 2->1, 4->2 ... 2048->11
    return Color.lerp(esquema.primaryContainer, esquema.primary, paso / 11)!; // De suave a intenso
  }

  static Color colorTexto(BuildContext context, int valor) => // Texto legible sobre la ficha
  colorFicha(context, valor).computeLuminance() > 0.4 ? Colors.black87 : Colors.white;

  static Color colorTablero(BuildContext context) => Theme.of(context).colorScheme.outlineVariant; // Fondo del tablero
}