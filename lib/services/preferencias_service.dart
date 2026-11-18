import 'package:flutter/material.dart'; // ThemeMode
import 'package:shared_preferences/shared_preferences.dart'; // Guardar clave-valor

class PreferenciasService { // Todo el acceso a SharedPreferences está aquí
  static const String claveTema = 'modo_tema'; // Claves como constantes
  static const String claveColor = 'color_fichas';

  static Future<void> guardarModoTema(ThemeMode modo) async { // Guardar tema
    final prefs = await SharedPreferences.getInstance(); // Abrir preferencias
    await prefs.setString(claveTema, modo.name); // Guarda "light", "dark" o "system"
  }

  static Future<ThemeMode> leerModoTema() async { // Leer tema
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(claveTema); // null si nunca se guardó
    return ThemeMode.values.firstWhere((m) => m.name == texto, orElse: () => ThemeMode.system); // Por defecto: sistema
  }

  static Future<void> guardarColor(int indice) async { // Guardar color de fichas
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(claveColor, indice); // Posición en la lista de colores
  }

  static Future<int> leerColor() async { // Leer color de fichas
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(claveColor) ?? 0; // Por defecto el primero
  }
}