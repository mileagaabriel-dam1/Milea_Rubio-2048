import 'package:flutter/material.dart';
import '../data/usuario_dao.dart';
import '../routes.dart';
import '../services/app_controller.dart';
import '../utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>(); // Para validar
  final _usuario = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _registro = false; // false = login, true = registro

  Future<void> _enviar() async {
    if (!_form.currentState!.validate()) return;
    try {
      final u = _registro
          ? await UsuarioDao().registrar(_usuario.text, _email.text, _pass.text)
          : await UsuarioDao().login(_usuario.text, _pass.text);
      if (!mounted) return;
      if (u == null) {
        _aviso('Datos incorrectos');
        return;
      }
      AppController.instance.usuario = u; // Usuario conectado
      Navigator.pushReplacementNamed(context, Rutas.home);
    } catch (e) {
      if (mounted) _aviso('Ese usuario o email ya existe'); // Error UNIQUE
    }
  }

  void _aviso(String t) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_registro ? 'Registro' : 'Login')),
      body: Form(
        key: _form,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          TextFormField(controller: _usuario, decoration: const InputDecoration(labelText: 'Usuario'), validator: obligatorio),
          if (_registro) TextFormField(controller: _email, decoration: const InputDecoration(labelText: 'Email'), validator: validarEmail),
          TextFormField(controller: _pass, decoration: const InputDecoration(labelText: 'Contraseña'), obscureText: true, validator: obligatorio),
          FilledButton(onPressed: _enviar, child: Text(_registro ? 'Registrarse' : 'Entrar')),
          TextButton(
            onPressed: () => setState(() => _registro = !_registro), // Cambia entre login y registro
            child: Text(_registro ? 'Ya tengo cuenta' : 'Crear cuenta'),
          ),
        ]),
      ),
    );
  }
}