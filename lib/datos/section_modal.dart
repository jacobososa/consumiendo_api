import 'package:flutter/material.dart';

class SectionModal extends StatelessWidget {
  final String title;

  const SectionModal({super.key, required this.title});

  Widget _buildContent() {
    switch (title) {
      case 'Informacion de soporte':
        return const Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('images/Stiven.jpeg'),
            ),
            Text('Nombre: Stiven'),
            Text('Apellidos: Sosa Villalobos'),
            Text('Teléfono: 3045580999'),
            Text('Correo: stsv2001@gmail.com'),
          ],
        );
      default:
        return const Text('Información no disponible.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildContent(),
        ],
      ),
    );
  }
}
