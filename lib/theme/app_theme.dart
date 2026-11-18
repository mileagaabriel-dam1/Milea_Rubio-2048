import 'dart:math'; // log, min
import 'package:flutter/material.dart';

class ColoresFichas extends ThemeExtension<ColoresFichas> { // Los colores de las fichas viajan DENTRO del tema
  final List<Color> colores;
  const ColoresFichas(this.colores);
  @override
  ColoresFichas copyWith({List<Color>? colores}) => ColoresFichas(colores ?? this.colores);
  @override
  ColoresFichas lerp(ColoresFichas? other, double t) => other ?? this;
}

class AppTheme { // Colores, tamaños y estilos de toda la app
  static const double espacio = 16; // Espaciado
  static const double radio = 8; // Esquinas
  static const double separacion = 8; // Hueco entre fichas
  static const Duration animacion = Duration(milliseconds: 120); // Velocidad del deslizamiento
  static const TextStyle titulo = TextStyle(fontSize: 56, fontWeight: FontWeight.bold);

  static const List<String> nombresColores = ['Multicolor', 'Pastel', 'Neón'];
  static const List<List<Color>> paletas = [ // Un color por ficha: 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048
    [Color(0xFF1E88E5), Color(0xFFE65100), Color(0xFF43A047), Color(0xFF8E24AA), Color(0xFFE53935), Color(0xFF00897B),
      Color(0xFFD81B60), Color(0xFFFFA000), Color(0xFF3949AB), Color(0xFF00ACC1), Color(0xFFFFD600)], // Azul, naranja oscuro, verde...
    [Color(0xFF90CAF9), Color(0xFFFFCC80), Color(0xFFA5D6A7), Color(0xFFCE93D8), Color(0xFFEF9A9A), Color(0xFF80CBC4),
      Color(0xFFF48FB1), Color(0xFFFFE082), Color(0xFF9FA8DA), Color(0xFF80DEEA), Color(0xFFFFF59D)],
    [Color(0xFF00E5FF), Color(0xFFFF6D00), Color(0xFF76FF03), Color(0xFFD500F9), Color(0xFFFF1744), Color(0xFF1DE9B6),
      Color(0xFFF50057), Color(0xFFFFC400), Color(0xFF651FFF), Color(0xFF00B0FF), Color(0xFFFFEA00)],
  ];

  static ThemeData _tema(int p, Brightness brillo) {
    final paleta = paletas[p % paletas.length]; // % por si había guardado un índice antiguo
    return ThemeData(colorSchemeSeed: paleta[0], brightness: brillo, extensions: [ColoresFichas(paleta)]);
  }

  static ThemeData claro(int p) => _tema(p, Brightness.light); // Tema claro
  static ThemeData oscuro(int p) => _tema(p, Brightness.dark); // Tema oscuro

  static Color colorFicha(BuildContext context, int valor) { // Color de una ficha
    final tema = Theme.of(context); // Tema ACTIVO
    if (valor == 0) return tema.colorScheme.surface; // Casilla vacía
    final colores = tema.extension<ColoresFichas>()!.colores;
    final i = (log(valor) / log(2)).round() - 1; // 2->0, 4->1 ... 2048->10
    return colores[min(i, colores.length - 1)];
  }

  static Color colorTexto(BuildContext context, int valor) => // Texto legible encima
  colorFicha(context, valor).computeLuminance() > 0.5 ? Colors.black87 : Colors.white;

  static Color colorTablero(BuildContext context) => Theme.of(context).colorScheme.outlineVariant; // Fondo del tablero
}