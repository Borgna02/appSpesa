import 'package:appspesa/domain/prodotto.dart';
import 'package:flutter/material.dart';

class DettagliContainer extends StatelessWidget {
  final Prodotto prodotto;

  const DettagliContainer({Key? key, required this.prodotto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget piaciutoIcon;
    if (prodotto.isPiaciuto == true) {
      piaciutoIcon = const Icon(Icons.thumb_up, size: 16, color: Colors.green);
    } else if (prodotto.isPiaciuto == false) {
      piaciutoIcon = const Icon(Icons.thumb_down, size: 16, color: Colors.red);
    } else {
      piaciutoIcon =
          const Icon(Icons.watch_later, size: 16, color: Colors.grey);
    }

    return Container(
      height: 600, // Altezza del riquadro con i dettagli
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            prodotto.nome,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Divider(height: 20, thickness: 1), // Linea orizzontale
          const SizedBox(height: 10),
          Text(
            'Marca: ${prodotto.nomeMarca}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 5),
          Text(
            'Tipo: ${prodotto.nomeTipo}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Text(
                'Piaciuto: ',
                style: TextStyle(fontSize: 18),
              ),
              piaciutoIcon,
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              // Codice per la gestione del pulsante "Modifica"
            },
            icon: const Icon(Icons.edit),
            label: const Text('Modifica'),
          ),
        ],
      ),
    );
  }
}
