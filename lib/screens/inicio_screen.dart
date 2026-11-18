import 'package:flutter/material.dart';
import '../data/partida_dao.dart';
import '../data/partida_guardada_dao.dart';
import '../routes.dart';
import '../services/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/score_card.dart';

class InicioScreen extends StatefulWidget {
  final void Function(int) irA; // Cambiar de pestaña
  const InicioScreen({super.key, required this.irA});
  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  final _id = AppController.instance.usuario!.id!;
  int _mejor = 0;
  bool _hayGuardada = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async { // Lee mejor puntuación y si hay partida guardada
    final mejor = await PartidaDao().mejorPuntuacion(_id);
    final guardada = await PartidaGuardadaDao().obtener(_id);
    if (mounted) setState(() { _mejor = mejor; _hayGuardada = guardada != null; });
  }

  Future<void> _jugar(bool continuar) async {
    await Navigator.pushNamed(context, Rutas.juego, arguments: continuar);
    _cargar(); // Al volver, recarga
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('2048', style: AppTheme.titulo, textAlign: TextAlign.center),
        ScoreCard(titulo: 'MEJOR', valor: '$_mejor'),
        if (_hayGuardada) FilledButton(onPressed: () => _jugar(true), child: const Text('Continuar partida')),
        FilledButton(onPressed: () => _jugar(false), child: const Text('Nueva partida')),
        OutlinedButton(onPressed: () => widget.irA(1), child: const Text('Historial')),
        OutlinedButton(onPressed: () => widget.irA(2), child: const Text('Ranking')),
        OutlinedButton(onPressed: () => widget.irA(3), child: const Text('Ajustes')),
      ]),
    );
  }
}