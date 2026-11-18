import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget { // Diálogo genérico con los botones que quieras
  final String titulo;
  final String mensaje;
  final List<String> opciones; // Texto de cada botón
  const ConfirmDialog({super.key, required this.titulo, required this.mensaje, required this.opciones});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titulo),
      content: Text(mensaje),
      actions: [
        for (final o in opciones) TextButton(onPressed: () => Navigator.pop(context, o), child: Text(o)), // Devuelve el texto pulsado
      ],
    );
  }

  // Muestra el diálogo y devuelve el botón pulsado (null si se cierra tocando fuera)
  static Future<String?> mostrar(BuildContext context, String titulo, String mensaje, List<String> opciones) {
    return showDialog<String>(
      context: context,
      builder: (_) => ConfirmDialog(titulo: titulo, mensaje: mensaje, opciones: opciones),
    );
  }
}