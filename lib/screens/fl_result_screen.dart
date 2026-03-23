import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResultScreen extends StatelessWidget {
  final String imagePath;
  final String operacion;
  final String resultado;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.operacion,
    required this.resultado,
  });

  Future<void> _cerrarSesion(BuildContext context) async {
    bool confirmar =
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Cerrar sesión'),
            content: const Text('¿Seguro que quieres cerrar sesión?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Sí'),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmar) {
      await FirebaseAuth.instance.signOut();

      if (!context.mounted) return;

      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Imagen capturada:', style: TextStyle(fontSize: 18)),

                const SizedBox(height: 20),

                Image.file(File(imagePath), height: 250, fit: BoxFit.contain),

                const SizedBox(height: 20),

                Text(
                  'Operación: $operacion',
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 10),

                Text(
                  'Resultado: $resultado',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Volver'),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () => _cerrarSesion(context),
                  child: const Text('Cerrar sesión'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
