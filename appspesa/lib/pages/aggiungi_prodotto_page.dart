// ignore_for_file: unused_field, library_private_types_in_public_api, avoid_print

import 'dart:typed_data';

import 'package:appspesa/domain/prodotto.dart';
import 'package:appspesa/utilities/utilities.dart';
import 'package:appspesa/widgets/votazione_button.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

import '../data/data_dispatcher.dart';
import '../utilities/image_helper.dart';
import 'mytheme.dart';

class AggiungiProdottoPage extends StatefulWidget {
  const AggiungiProdottoPage({super.key});

  @override
  _AggiungiProdottoPageState createState() => _AggiungiProdottoPageState();
}

Prodotto? newProdotto;
final ImageHelper imageHelper = ImageHelper();

class _AggiungiProdottoPageState extends State<AggiungiProdottoPage> {
  final _formKey = GlobalKey<FormState>();
  final _marcaController = TextEditingController();
  final _tipoController = TextEditingController();
  final _nomeController = TextEditingController();
  bool? _selectedVote;
  List<String> _tipoSuggestions = [];
  List<String> _marcaSuggestions = [];
  Uint8List? _selectedImage;
  late File imageFile;

  @override
  void dispose() {
    _marcaController.dispose();
    _tipoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedImage = await imageHelper.pickImage(context: context);

    if (pickedImage != null) {
      final croppedFile = await imageHelper.crop(
          file: pickedImage, cropStyle: CropStyle.rectangle);
      if (croppedFile != null) {
        imageFile = File(croppedFile.path);

        final compressedImage = await imageHelper.compressImage(
          imageFile,
          600, // Larghezza massima
          600, // Altezza massima
          100, // Qualità della compressione
        );

        setState(() {
          _selectedImage = compressedImage;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = MyTheme.getThemeData().colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Aggiungi Prodotto'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Azione da eseguire quando viene premuto il tasto di ritorno
              Navigator.of(context).pop({
                'tipoAdded': newProdotto?.nomeTipo,
                'prodottoAdded': newProdotto,
              });
            },
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus(); // Chiude la tastiera
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Inserisci il nome del prodotto';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _marcaController,
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
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _marcaSuggestions.length,
                      itemBuilder: (BuildContext context, int index) {
                        final suggestion = _marcaSuggestions[index];
                        return ListTile(
                          title: Text(suggestion),
                          tileColor: index.isOdd ? oddItemColor : evenItemColor,
                          onTap: () {
                            _marcaController.text = suggestion;
                            if (_marcaController.text.isNotEmpty) {
                              _marcaController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: _marcaController.text.length),
                              );
                              FocusScope.of(context)
                                  .unfocus(); // Chiude la tastiera
                            }
                            setState(() {
                              _clearMarcaSuggestions();
                            });
                          },
                        );
                      },
                    ),
                    // Tipo di prodotto
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _tipoController,
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
                    ),
                    const SizedBox(height: 20.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _tipoSuggestions.length,
                      itemBuilder: (BuildContext context, int index) {
                        final suggestion = _tipoSuggestions[index];
                        return ListTile(
                          title: Text(suggestion),
                          tileColor: index.isOdd ? oddItemColor : evenItemColor,
                          onTap: () {
                            _tipoController.text = suggestion;
                            if (_tipoController.text.isNotEmpty) {
                              _tipoController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: _tipoController.text.length),
                              );
                            }
                            setState(() {
                              _clearTipoSuggestions();
                            });
                            FocusScope.of(context)
                                .unfocus(); // Chiude la tastiera
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: VotazioneButton(
                              onVoteSelected: (vote) {
                                setState(() {
                                  _selectedVote = vote;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    if (_selectedImage != null)
                      Image.memory(
                        _selectedImage!,
                        width: 200,
                        height: 200,
                      ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: const Text('Scegli Immagine'),
                        ),
                        if (_selectedImage != null) const SizedBox(width: 10.0),
                        if (_selectedImage != null)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedImage = null;
                              });
                            },
                            child: const Icon(Icons.delete),
                          ),
                      ],
                    ),

                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_selectedImage == null) {
                            // Mostra il messaggio di avviso
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Selezionare una foto')),
                            );
                          } else {
                            final nomeValue = _nomeController.text;
                            final nomeMarca = capitalizeFirstForEachWord(
                                _marcaController.text);
                            final nomeTipo =
                                capitalizeOnlyFirst(_tipoController.text);
                            bool isDaRicomprare = false;

                            final newProdotto = Prodotto(
                                id: null,
                                nome: nomeValue,
                                nomeMarca: nomeMarca,
                                nomeTipo: nomeTipo,
                                isDaRicomprare: isDaRicomprare,
                                isPiaciuto: _selectedVote,
                                immagine: _selectedImage,
                                isDaMostrare: true);

                            marcaTipoCheck(context, null, newProdotto);
                          }
                        }
                      },
                      child: const Text('Salva'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<void> _fetchTypeSuggestions(String input) async {
    Set<String> suggestions = {};

    if (input.isNotEmpty) {
      for (String tipo in prodotti.keys) {
        if (tipo.toLowerCase().contains(input.toLowerCase())) {
          suggestions.add(tipo);
        }
      }
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
    }
  }
}
