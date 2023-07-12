import 'package:appspesa/data/data_dispatcher.dart';
import 'package:appspesa/domain/prodotto.dart';
import 'package:appspesa/pages/mytheme.dart';
import 'package:appspesa/utilities/utilities.dart';
import 'package:appspesa/widgets/si_no_button.dart';
import 'package:appspesa/widgets/votazione_button.dart';
import 'package:flutter/material.dart';

class DettagliContainer extends StatefulWidget {
  final Prodotto vecchioProdotto;

  const DettagliContainer({Key? key, required this.vecchioProdotto})
      : super(key: key);

  @override
  State<DettagliContainer> createState() => _DettagliContainerState();
}

class _DettagliContainerState extends State<DettagliContainer> {
  // inizializzo il valore di isModifying a false ogni volta che accedo al widget
  bool isModifying = false;
  List<String> _tipoSuggestions = [];
  List<String> _marcaSuggestions = [];
  Prodotto? nuovoProdotto;

  final _formKey = GlobalKey<FormState>();

  var nomeController = TextEditingController();
  var marcaController = TextEditingController();
  var tipoController = TextEditingController();
  bool? selectedIsPiaciuto;
  bool selectedIsDaRicomprare = false;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.vecchioProdotto.nome);
    marcaController =
        TextEditingController(text: widget.vecchioProdotto.nomeMarca);
    tipoController =
        TextEditingController(text: widget.vecchioProdotto.nomeTipo);
    selectedIsDaRicomprare = widget.vecchioProdotto.isDaRicomprare;

    nuovoProdotto = Prodotto(
        nome: widget.vecchioProdotto.nome,
        nomeMarca: widget.vecchioProdotto.nomeMarca,
        nomeTipo: widget.vecchioProdotto.nomeTipo,
        isDaRicomprare: widget.vecchioProdotto.isDaRicomprare,
        isPiaciuto: widget.vecchioProdotto.isPiaciuto,
        immagine: widget.vecchioProdotto.immagine);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = MyTheme.getThemeData().colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    Widget piaciutoIcon;
    if (widget.vecchioProdotto.isPiaciuto == true) {
      piaciutoIcon = const Icon(Icons.thumb_up, size: 20, color: Colors.green);
    } else if (widget.vecchioProdotto.isPiaciuto == false) {
      piaciutoIcon = const Icon(Icons.thumb_down, size: 20, color: Colors.red);
    } else {
      piaciutoIcon =
          const Icon(Icons.watch_later, size: 20, color: Colors.grey);
    }

    Text isDaRicomprareText;
    if (widget.vecchioProdotto.isDaRicomprare) {
      isDaRicomprareText =
          const Text(" Sì ", style: TextStyle(color: Colors.red, fontSize: 18));
    } else {
      isDaRicomprareText = const Text(" No ",
          style: TextStyle(color: Colors.green, fontSize: 18));
    }

    return Container(
      height: 1500, // Altezza del riquadro con i dettagli
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            // Sezione relativa al nome del prodotto
            isModifying
                ? TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Inserisci il nome del prodotto';
                      }
                      return null;
                    },
                    onTap: () {
                      _clearMarcaSuggestions();
                      _clearTipoSuggestions();
                    })
                : Text(
                    nuovoProdotto!.nome,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
            const SizedBox(height: 10),
            const Divider(height: 20, thickness: 1), // Linea orizzontale
            const SizedBox(height: 10),
            // Sezione relativa alla marca del prodotto
            isModifying
                ? TextFormField(
                    controller: marcaController,
                    onChanged: (value) {
                      setState(() {
                        _fetchMarcheSuggestions(value);
                      });
                    },
                    onTap: () {
                      _clearTipoSuggestions();
                    },
                    decoration: const InputDecoration(
                      labelText: 'Marca',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Inserisci la marca del prodotto';
                      }
                      return null;
                    },
                  )
                : Text(
                    'Marca: ${nuovoProdotto!.nomeMarca}',
                    style: const TextStyle(fontSize: 18),
                  ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _marcaSuggestions.length,
              itemBuilder: (BuildContext context, int index) {
                final suggestion = _marcaSuggestions[index];
                return Container(
                    color: index.isOdd ? oddItemColor : evenItemColor,
                    child: ListTile(
                      title: Text(suggestion),
                      onTap: () {
                        marcaController.text = suggestion;
                        if (marcaController.text.isNotEmpty) {
                          marcaController.selection =
                              TextSelection.fromPosition(
                            TextPosition(offset: marcaController.text.length),
                          );
                          FocusScope.of(context)
                              .unfocus(); // Chiude la tastiera
                        }
                        setState(() {
                          _clearMarcaSuggestions();
                        });
                      },
                    ));
              },
            ),
            const SizedBox(height: 5),

            // Sezione relativa al tipo
            isModifying
                ? TextFormField(
                    controller: tipoController,
                    onChanged: (value) {
                      setState(() {
                        _fetchTypeSuggestions(value);
                      });
                    },
                    onTap: () {
                      _clearMarcaSuggestions();
                    },
                    decoration: const InputDecoration(
                      labelText: 'Tipo',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Inserisci il tipo del prodotto';
                      }
                      return null;
                    },
                  )
                : Text(
                    'Tipo: ${nuovoProdotto!.nomeTipo}',
                    style: const TextStyle(fontSize: 18),
                  ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _tipoSuggestions.length,
              itemBuilder: (BuildContext context, int index) {
                final suggestion = _tipoSuggestions[index];
                return Container(
                    color: index.isOdd ? oddItemColor : evenItemColor,
                    child: ListTile(
                      title: Text(suggestion),
                      onTap: () {
                        tipoController.text = suggestion;
                        if (tipoController.text.isNotEmpty) {
                          tipoController.selection = TextSelection.fromPosition(
                            TextPosition(offset: tipoController.text.length),
                          );
                        }
                        setState(() {
                          _clearTipoSuggestions();
                        });
                        FocusScope.of(context).unfocus(); // Chiude la tastiera
                      },
                    ));
              },
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Text(
                  'Piaciuto? ',
                  style: TextStyle(fontSize: 18),
                ),
                isModifying
                    ? Column(
                        children: [
                          const SizedBox(height: 20),
                          VotazioneButton(
                              onVoteSelected: (vote) {
                                // Al nuovo prodotto viene assegnato il nuovo valore scelto
                                selectedIsPiaciuto = vote;

                                _clearMarcaSuggestions();
                                _clearTipoSuggestions();
                              },
                              defaultVote: widget.vecchioProdotto.isPiaciuto),
                          const SizedBox(height: 20),
                        ],
                      )
                    : piaciutoIcon
              ],
            ),
            const SizedBox(height: 5),
            Row(children: [
              const Text('Da ricomprare? ', style: TextStyle(fontSize: 18)),
              isModifying
                  ? Column(children: [
                      const SizedBox(height: 20),
                      SiNoButton(
                          onVoteSelected: (vote) {
                            selectedIsDaRicomprare = vote!;

                            _clearTipoSuggestions();
                            _clearMarcaSuggestions();
                          },
                          defaultIsDaRicomprare:
                              widget.vecchioProdotto.isDaRicomprare),
                      const SizedBox(height: 20),
                    ])
                  : isDaRicomprareText
            ]),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                _clearMarcaSuggestions();
                _clearTipoSuggestions();
                if (isModifying) {
                  if (_formKey.currentState!.validate()) {
                    final nomeValue = nomeController.text;
                    final nomeMarca =
                        capitalizeFirstForEachWord(marcaController.text);
                    final nomeTipo = capitalizeOnlyFirst(tipoController.text);

                    nuovoProdotto = Prodotto(
                      id: widget.vecchioProdotto.id,
                      nome: nomeValue,
                      nomeMarca: nomeMarca,
                      nomeTipo: nomeTipo,
                      isDaRicomprare: selectedIsDaRicomprare,
                      isPiaciuto: selectedIsPiaciuto,
                      immagine: widget.vecchioProdotto.immagine,
                    );

                    if (nuovoProdotto != widget.vecchioProdotto) {
                      bool result = false;
                      try {
                        result = await marcaTipoCheck(
                            context, widget.vecchioProdotto, nuovoProdotto!);
                      } catch (error) {
                        // Gestisci l'errore se si verifica durante marcaTipoCheck
                      } finally {
                        if (!result) {
                          // se non ho salvato le modifiche ripristino il vecchio prodotto
                          nuovoProdotto = widget.vecchioProdotto;
                          setState(() {});
                        } else {
                          setState(() {
                            isModifying = !isModifying;
                          });
                        }
                      }
                    } else {
                      setState(() {
                        isModifying = !isModifying;
                      });
                    }
                  }
                } else {
                  setState(() {
                    isModifying = !isModifying;
                  });
                }
              },
              icon:
                  isModifying ? const Icon(Icons.save) : const Icon(Icons.edit),
              label: isModifying ? const Text('Salva') : const Text('Modifica'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchTypeSuggestions(String input) async {
    Set<String> suggestions = {};

    if (input.isNotEmpty) {
      for (String tipo in prodotti.keys) {
        if (tipo.toLowerCase().contains(input.toLowerCase())) {
          suggestions.add(tipo);
        }
      }
    } else {
      _tipoSuggestions.clear();
    }
    setState(() {
      _tipoSuggestions = suggestions.toList();
    });
  }

  void _clearTipoSuggestions() {
    setState(() {
      _tipoSuggestions.clear();
    });
  }

  void _clearMarcaSuggestions() {
    setState(() {
      _marcaSuggestions.clear();
    });
  }

  void _fetchMarcheSuggestions(String input) {
    Set<String> suggestions = {};

    if (input.isNotEmpty) {
      for (String marca in marche) {
        if (marca.toLowerCase().contains(input.toLowerCase())) {
          suggestions.add(marca);
        }
      }
      setState(() {
        _marcaSuggestions = suggestions.toList();
      });
    } else {
      _marcaSuggestions.clear();
    }
  }
}
