import 'package:flutter/material.dart';
import '../domain/prodotto.dart';

class DettaglioProdottoPage extends StatelessWidget {
  final Prodotto prodotto;

  const DettaglioProdottoPage({super.key, required this.prodotto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio Prodotto'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Nome: ${prodotto.nome}'),
            Text('Marca: ${prodotto.nomeMarca}'),
            Text('Tipo: ${prodotto.nomeTipo}'),
            Text('Da Ricomprare: ${prodotto.isDaRicomprare}'),
            Text('Piaciuto: ${prodotto.isPiaciuto}'),
            // Image('Immagine: ${prodotto.immagine}'),
          ],
        ),
      ),
    );
  }
}
