import 'package:flutter/material.dart';

class ConfermaMarca extends StatelessWidget {
  final String nomeMarca;

  const ConfermaMarca({super.key, required this.nomeMarca});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Conferma'),
      content: Text('Vuoi inserire la nuova marca "$nomeMarca" nel sistema?'),
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
