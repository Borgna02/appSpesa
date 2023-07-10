import 'package:flutter/material.dart';

class ConfermaTipo extends StatelessWidget {
  final String nomeTipo;

  const ConfermaTipo({super.key, required this.nomeTipo});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Conferma'),
      content: Text('Vuoi inserire il nuovo tipo "$nomeTipo" nel sistema?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false); // Chiude il dialogo senza confermare
          },
          child: const Text('Annulla'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true); // Chiude il dialogo e conferma
          },
          child: const Text('Conferma'),
        ),
      ],
    );
  }
}
