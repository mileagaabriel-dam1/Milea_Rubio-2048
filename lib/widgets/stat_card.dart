import 'package:flutter/material.dart';

class StatCard extends StatelessWidget { // Tarjeta de una estadística
  final String titulo;
  final String valor;
  final IconData icono;
  const StatCard({super.key, required this.titulo, required this.valor, required this.icono});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icono),
        title: Text(titulo),
        trailing: Text(valor, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}