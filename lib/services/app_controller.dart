import 'package:flutter/material.dart'; // ChangeNotifier, ThemeMode

import '../models/usuario.dart'; // Usuario conectado
import 'preferencias_service.dart'; // Guardar preferencias

class AppController extends ChangeNotifier { // Estado global. Avisa a la app cuando cambia algo
  AppController._(); // Singleton
  static final instance = AppController._(); // Única instancia

  ThemeMode modoTema = ThemeMode.system; // Tema actual
  int colorIndice = 0; // Color de fichas actual
  Usuario? usuario; // Usuario que ha iniciado sesión

  Future<void> cargar() async { // Se llama ANTES de runApp
    modoTema = await PreferenciasService.leerModoTema();
    colorIndice = await PreferenciasService.leerColor();
  }

  void cambiarTema(ThemeMode modo) { // Cambiar tema
    modoTema = modo;
    notifyListeners(); // La app se redibuja al momento
    PreferenciasService.guardarModoTema(modo); // Y se guarda
  }

  void cambiarColor(int indice) { // Cambiar color de fichas
    colorIndice = indice;
    notifyListeners();
    PreferenciasService.guardarColor(indice);
  }
}