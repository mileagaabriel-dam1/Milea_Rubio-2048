import 'package:flutter/material.dart';

class AsyncDataView<T> extends StatelessWidget { // Cargando / error / datos de un Future
  final Future<T> future; // La consulta a la BD
  final Widget Function(T datos) builder; // Qué dibujar con los datos
  final VoidCallback onReintentar; // Botón de reintentar
  const AsyncDataView({super.key, required this.future, required this.builder, required this.onReintentar});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, s) {
        if (s.hasError) { // ERROR
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Error: ${s.error}'),
                FilledButton(onPressed: onReintentar, child: const Text('Reintentar')),
              ],
            ),
          );
        }
        if (s.connectionState != ConnectionState.done) { // CARGANDO
          return const Center(child: CircularProgressIndicator());
        }
        return builder(s.data as T); // DATOS
      },
    );
  }
}