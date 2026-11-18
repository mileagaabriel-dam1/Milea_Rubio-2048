import 'package:flutter/material.dart';

import 'routes.dart';
import 'services/app_controller.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Obligatorio antes de usar plugins
  await AppController.instance.cargar(); // Lee las preferencias ANTES de runApp (sin parpadeo de tema)
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppController.instance;
    return ListenableBuilder( // Cuando cambia el tema o el color, se redibuja la app entera
      listenable: app,
      builder: (context, _) => MaterialApp(
        title: '2048',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.claro(app.colorIndice), // Tema claro
        darkTheme: AppTheme.oscuro(app.colorIndice), // Tema oscuro
        themeMode: app.modoTema, // Cuál usar
        initialRoute: Rutas.login,
        onGenerateRoute: Rutas.generar, // Rutas centralizadas
      ),
    );
  }
}