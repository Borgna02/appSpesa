import 'package:flutter/material.dart';

class AggiungiProdottoPage extends StatelessWidget {
  const AggiungiProdottoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aggiungi Prodotto'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Aggiungi il form per l'aggiunta di un nuovo prodotto
              // Includi campi per nome, marca, tipo, ecc.
            ],
          ),
        ),
      ),
    );
  }
}
