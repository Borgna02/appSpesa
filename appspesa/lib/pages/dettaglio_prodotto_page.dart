import 'package:appspesa/widgets/dettagli_container.dart';
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
      _opacity = 1.0 - (_scrollController.offset / 450);
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
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.topCenter,
                child: Opacity(
                  opacity: _opacity,
                  child: Image.memory(
                    widget.prodotto.immagine!,
                    fit: BoxFit.none,
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height *
                      0.5), // Altezza iniziale in cui inizia lo scroll
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [DettagliContainer(prodotto: widget.prodotto)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
