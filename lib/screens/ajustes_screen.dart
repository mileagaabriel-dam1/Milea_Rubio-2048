import 'package:flutter/material.dart';
import '../data/partida_dao.dart';
import '../routes.dart';
import '../services/app_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/confirm_dialog.dart';

class AjustesScreen extends StatelessWidget {
  const AjustesScreen({super.key});

  Future<void> _borrarTodo(BuildContext context) async {
    final r = await ConfirmDialog.mostrar(context, '¿Borrar historial?', 'Se borrarán todas las partidas', ['Cancelar', 'Borrar']);
    if (r != 'Borrar') return;
    await PartidaDao().eliminarTodo();
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Historial borrado')));
  }

  @override
  Widget build(BuildContext context) {
    final app = AppController.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListenableBuilder( // Se actualiza al cambiar tema/color
        listenable: app,
        builder: (context, _) => ListView(padding: const EdgeInsets.all(16), children: [
          SegmentedButton<ThemeMode>( // Tema
            segments: const [
              ButtonSegment(value: ThemeMode.light, label: Text('Claro')),
              ButtonSegment(value: ThemeMode.dark, label: Text('Oscuro')),
              ButtonSegment(value: ThemeMode.system, label: Text('Sistema')),
            ],
            selected: {app.modoTema},
            onSelectionChanged: (s) => app.cambiarTema(s.first),
          ),
          Wrap(children: [ // Color de fichas
            for (var i = 0; i < AppTheme.colores.length; i++)
              ChoiceChip(label: Text(AppTheme.nombresColores[i]), selected: app.colorIndice == i, onSelected: (_) => app.cambiarColor(i)),
          ]),
          ListTile(title: const Text('Borrar historial'), leading: const Icon(Icons.delete), onTap: () => _borrarTodo(context)),
          ListTile(title: const Text('Cerrar sesión'), leading: const Icon(Icons.logout),
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, Rutas.login, (_) => false)),
        ]),
      ),
    );
  }
}