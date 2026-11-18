import 'package:flutter/material.dart';
import 'ajustes_screen.dart';
import 'historial_screen.dart';
import 'inicio_screen.dart';
import 'ranking_screen.dart';

class HomeShell extends StatefulWidget { // Navegación principal con barra inferior
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _i = 0; // Pestaña actual

  @override
  Widget build(BuildContext context) {
    final pantallas = [InicioScreen(irA: (i) => setState(() => _i = i)), const HistorialScreen(), const RankingScreen(), const AjustesScreen()];
    return Scaffold(
      body: pantallas[_i],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _i,
        onDestinationSelected: (i) => setState(() => _i = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Historial'),
          NavigationDestination(icon: Icon(Icons.leaderboard), label: 'Ranking'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
      ),
    );
  }
}