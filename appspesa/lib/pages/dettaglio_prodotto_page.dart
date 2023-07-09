// ignore_for_file: library_private_types_in_public_api

/* import 'package:flutter/material.dart';
import '../domain/prodotto.dart';

class DettaglioProdottoPage extends StatelessWidget {
  final Prodotto prodotto;

  const DettaglioProdottoPage({Key? key, required this.prodotto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio Prodotto'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome: ${prodotto.nome}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Marca: ${prodotto.nomeMarca}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Tipo: ${prodotto.nomeTipo}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Da Ricomprare: ${prodotto.isDaRicomprare}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Piaciuto: ${prodotto.isPiaciuto ?? false}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            if (prodotto.immagine != null)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageOverlayPage(
                        imageProvider: MemoryImage(prodotto.immagine!),
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'product_image',
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: MemoryImage(prodotto.immagine!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
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
      ),
    );
  }
}

 */

import 'package:flutter/material.dart';

import '../domain/prodotto.dart';

class DettaglioProdottoPage extends StatefulWidget {
  final Prodotto prodotto;
  const DettaglioProdottoPage({super.key, required this.prodotto});

  @override
  _DettaglioProdottoPageState createState() => _DettaglioProdottoPageState();
}

class _DettaglioProdottoPageState extends State<DettaglioProdottoPage> {
  late ScrollController _scrollController;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      // Calcola l'opacità in base alla posizione dello scroll
      _opacity = 1.0 - (_scrollController.offset / 200);
      if (_opacity < 0.0) {
        _opacity = 0.0;
      } else if (_opacity > 1.0) {
        _opacity = 1.0;
      }
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettaglio Prodotto'),
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: _opacity,
            child: Container(
              constraints: const BoxConstraints.expand(),
              child: Image.memory(
                widget.prodotto
                    .immagine!, // Inserisci il percorso dell'immagine a tutto schermo
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height *
                      0.6), // Altezza iniziale in cui inizia lo scroll
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                      height: 900, // Altezza del riquadro con i dettagli
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nome: ${widget.prodotto.nome}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Marca: ${widget.prodotto.nomeMarca}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Tipo: ${widget.prodotto.nomeTipo}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Da Ricomprare: ${widget.prodotto.isDaRicomprare}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Piaciuto: ${widget.prodotto.isPiaciuto ?? false}',
                              style: const TextStyle(fontSize: 16),
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
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
