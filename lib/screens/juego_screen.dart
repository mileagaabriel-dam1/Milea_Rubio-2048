import 'dart:async';
import 'package:flutter/material.dart';
import '../data/partida_dao.dart';
import '../data/partida_guardada_dao.dart';
import '../game/juego_2048.dart';
import '../models/partida.dart';
import '../models/partida_guardada.dart';
import '../services/app_controller.dart';
import '../utils.dart';
import '../widgets/board_widget.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/score_card.dart';

class JuegoScreen extends StatefulWidget {
  final bool continuar; // true = cargar partida guardada
  const JuegoScreen({super.key, required this.continuar});
  @override
  State<JuegoScreen> createState() => _JuegoScreenState();
}

class _JuegoScreenState extends State<JuegoScreen> with WidgetsBindingObserver { // Observer: segundo plano
  final _id = AppController.instance.usuario!.id!;
  Juego2048 _juego = Juego2048();
  int _segundos = 0, _mejor = 0;
  bool _verDetalles = true, _fin = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _iniciar();
  }

  Future<void> _iniciar() async {
    _mejor = await PartidaDao().mejorPuntuacion(_id);
    final g = widget.continuar ? await PartidaGuardadaDao().obtener(_id) : null;
    if (g != null) { // Continuar: estado recuperado de la BD
      _juego = Juego2048.cargar(g.tablero, g.puntuacion, g.movimientos);
      _segundos = g.segundos;
    }
    if (!mounted) return;
    setState(() {});
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _segundos++)); // Cronómetro
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) { // Guardado automático
    if (state == AppLifecycleState.paused && !_fin) _guardar();
  }

  Future<void> _guardar() => PartidaGuardadaDao().guardar(PartidaGuardada(
      usuarioId: _id, tablero: _juego.tablero, puntuacion: _juego.puntuacion, movimientos: _juego.movimientos, segundos: _segundos));

  void _mover(Direccion d) {
    if (_fin || !_juego.mover(d)) return;
    setState(() {});
    if (_juego.terminado) _terminar();
  }

  Future<void> _terminar() async { // Fin de partida
    _fin = true;
    _timer?.cancel();
    await PartidaDao().terminarPartida(Partida( // Transacción
        usuarioId: _id, puntuacion: _juego.puntuacion, fichaMaxima: _juego.fichaMaxima,
        movimientos: _juego.movimientos, duracionSegundos: _segundos, fecha: DateTime.now().toIso8601String()));
    if (!mounted) return;
    final r = await ConfirmDialog.mostrar(context, 'Fin', 'Puntuación: ${_juego.puntuacion}', ['Inicio', 'Jugar de nuevo']);
    if (!mounted) return;
    if (r == 'Jugar de nuevo') {
      _reiniciar();
    } else {
      Navigator.pop(context);
    }
  }

  void _reiniciar() {
    _timer?.cancel();
    setState(() { _juego = Juego2048(); _segundos = 0; _fin = false; });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _segundos++));
  }

  Future<void> _salir() async { // Botón atrás
    final r = await ConfirmDialog.mostrar(context, '¿Salir?', 'Partida en curso', ['Cancelar', 'Salir sin guardar', 'Guardar y salir']);
    if (r == null || r == 'Cancelar') return;
    if (r == 'Guardar y salir') await _guardar();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _fin, // Si hay partida en curso, no deja salir directamente
      onPopInvokedWithResult: (didPop, _) { if (!didPop) _salir(); },
      child: Scaffold(
        appBar: AppBar(title: const Text('2048'), actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _reiniciar)]),
        body: Column(children: [
          GestureDetector( // Doble toque: mostrar/ocultar detalles
            onDoubleTap: () => setState(() => _verDetalles = !_verDetalles),
            child: Row(children: [
              Expanded(child: ScoreCard(titulo: 'PUNTOS', valor: '${_juego.puntuacion}')),
              Expanded(child: ScoreCard(titulo: 'MEJOR', valor: '${_juego.puntuacion > _mejor ? _juego.puntuacion : _mejor}')),
            ]),
          ),
          if (_verDetalles) Text('Movimientos: ${_juego.movimientos}   Tiempo: ${formatoTiempo(_segundos)}'),
          Expanded(child: Center(child: BoardWidget(fichas: _juego.fichas, onMover: _mover))),
        ]),
      ),
    );
  }
}