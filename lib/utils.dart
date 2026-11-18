import 'dart:convert'; // utf8
import 'package:crypto/crypto.dart'; // sha256

String encriptar(String texto) => sha256.convert(utf8.encode(texto)).toString(); // Contraseña -> hash

String? validarEmail(String? v) => // null = correcto
(v == null || !v.contains('@') || !v.contains('.')) ? 'Email no válido' : null;

String? obligatorio(String? v) => (v == null || v.trim().isEmpty) ? 'Campo obligatorio' : null; // No vacío

String formatoTiempo(int s) => // 125 -> "02:05"
'${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

String formatoFecha(String iso) => iso.substring(0, 16).replaceFirst('T', ' '); // "2026-11-18 15:30"