import 'package:appspesa/domain/prodotto.dart';
import 'package:appspesa/pages/mytheme.dart';
import 'package:flutter/material.dart';

class DettagliContainer extends StatefulWidget {
  final Prodotto prodotto;

  const DettagliContainer({Key? key, required this.prodotto}) : super(key: key);

  @override
  State<DettagliContainer> createState() => _DettagliContainerState();
}

class _DettagliContainerState extends State<DettagliContainer> {
  bool isModifying =
      false; // inizializzo il valore di isModifying a false ogni volta che accedo al widget

  @override
  Widget build(BuildContext context) {
    final colorScheme = MyTheme.getThemeData().colorScheme;
    final primary = colorScheme.primary;

    Widget piaciutoIcon;
    if (widget.prodotto.isPiaciuto == true) {
      piaciutoIcon = const Icon(Icons.thumb_up, size: 20, color: Colors.green);
    } else if (widget.prodotto.isPiaciuto == false) {
      piaciutoIcon = const Icon(Icons.thumb_down, size: 20, color: Colors.red);
    } else {
      piaciutoIcon =
          const Icon(Icons.watch_later, size: 20, color: Colors.grey);
    }

    Text isDaRicomprareText;
    if (widget.prodotto.isDaRicomprare) {
      isDaRicomprareText =
          const Text(" Sì ", style: TextStyle(color: Colors.red, fontSize: 18));
    } else {
      isDaRicomprareText = const Text(" No ",
          style: TextStyle(color: Colors.green, fontSize: 18));
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
            widget.prodotto.nome,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Divider(height: 20, thickness: 1), // Linea orizzontale
          const SizedBox(height: 10),
          Text(
            'Marca: ${widget.prodotto.nomeMarca}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 5),
          Text(
            'Tipo: ${widget.prodotto.nomeTipo}',
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
          const SizedBox(height: 5),
          Row(
            children: [
              const Text(
                'Da ricomprare?',
                style: TextStyle(fontSize: 18),
              ),
              isDaRicomprareText,
              ElevatedButton(
                onPressed: () {
                  // Modifica il valore di prodotto.isDaRicomprare
                  widget.prodotto.isDaRicomprare =
                      !widget.prodotto.isDaRicomprare;
                  setState(() {});
                },
                child: Icon(
                  widget.prodotto.isDaRicomprare
                      ? Icons.shopping_cart
                      : Icons.shopping_cart_outlined,
                  color: primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                isModifying = !isModifying;
              });
            },
            icon: isModifying ? const Icon(Icons.save) : const Icon(Icons.edit),
            label: isModifying ? const Text('Salva') : const Text('Modifica'),
          ),
        ],
      ),
    );
  }
}
