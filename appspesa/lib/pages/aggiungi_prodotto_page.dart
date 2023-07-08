// ignore_for_file: unused_field, library_private_types_in_public_api, avoid_print

import 'dart:typed_data';

import 'package:appspesa/domain/prodotto.dart';
import 'package:appspesa/widgets/votazione_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:mysql_client/exception.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../connection/connection_railway.dart';
import '../data/data_dispatcher.dart';
import 'mytheme.dart';

class AggiungiProdottoPage extends StatefulWidget {
  const AggiungiProdottoPage({super.key});

  @override
  _AggiungiProdottoPageState createState() => _AggiungiProdottoPageState();
}

class _AggiungiProdottoPageState extends State<AggiungiProdottoPage> {
  final _formKey = GlobalKey<FormState>();
  final _marcaController = TextEditingController();
  final _tipoController = TextEditingController();
  final _nomeController = TextEditingController();
  bool isTipoSuggestionSelected = false;
  bool isMarcaSuggestionSelected = false;
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
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      imageFile = File(pickedImage.path);

      final compressedImage = await compressImage(
        imageFile,
        200, // Larghezza massima
        200, // Altezza massima
        10, // Qualità della compressione
      );

      setState(() {
        _selectedImage = compressedImage;
      });
    }
  }

  Future<Uint8List> compressImage(
    File imageFile,
    int maxWidth,
    int maxHeight,
    int quality,
  ) async {
    final result = await FlutterImageCompress.compressWithFile(
      imageFile.path,
      minWidth: maxWidth,
      minHeight: maxHeight,
      quality: quality,
    );

    return result!;
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = MyTheme.getThemeData().colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aggiungi Prodotto'),
      ),
      body: SingleChildScrollView(
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
                        isMarcaSuggestionSelected = true;
                        _marcaController.text = suggestion;
                        if (_marcaController.text.isNotEmpty) {
                          _marcaController.selection =
                              TextSelection.fromPosition(
                            TextPosition(offset: _marcaController.text.length),
                          );
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
                    isTipoSuggestionSelected = false;
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
                        isTipoSuggestionSelected = true;
                        _tipoController.text = suggestion;
                        if (_tipoController.text.isNotEmpty) {
                          _tipoController.selection =
                              TextSelection.fromPosition(
                            TextPosition(offset: _tipoController.text.length),
                          );
                        }
                        setState(() {
                          _clearTipoSuggestions();
                        });
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
                              print(vote);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                if (_selectedImage != null)
                  Image.file(
                    imageFile,
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
                          const SnackBar(content: Text('Selezionare una foto')),
                        );
                      } else {
                        final nomeValue = _nomeController.text;
                        final nomeMarca = _marcaController.text;
                        final nomeTipo = _tipoController.text;
                        bool isDaRicomprare = false;

                        var newProdotto = Prodotto(
                            id: null,
                            nome: nomeValue,
                            nomeMarca: nomeMarca,
                            nomeTipo: nomeTipo,
                            isDaRicomprare: isDaRicomprare,
                            isPiaciuto: _selectedVote,
                            immagine: _selectedImage);

                        if (!containsIgnoreCase(marche, nomeMarca) ||
                            !containsIgnoreCase(prodotti.keys, nomeTipo)) {
                          // se bisogna aggiungere uno tra tipo e marca
                          if (!containsIgnoreCase(marche, nomeMarca)) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Conferma'),
                                  content: Text(
                                      'Vuoi inserire la nuova marca "$nomeMarca" nel sistema?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context,
                                            false); // Chiude il dialogo senza confermare
                                      },
                                      child: const Text('Annulla'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context,
                                            true); // Chiude il dialogo e conferma
                                      },
                                      child: const Text('Conferma'),
                                    ),
                                  ],
                                );
                              },
                            ).then((value) {
                              if (value == true) {
                                insertMarca(nomeMarca);
                                if (!containsIgnoreCase(
                                    prodotti.keys, nomeTipo)) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Conferma'),
                                        content: Text(
                                            'Vuoi inserire il nuovo tipo "$nomeTipo" nel sistema?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context,
                                                  false); // Chiude il dialogo senza confermare
                                            },
                                            child: const Text('Annulla'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context,
                                                  true); // Chiude il dialogo e conferma
                                            },
                                            child: const Text('Conferma'),
                                          ),
                                        ],
                                      );
                                    },
                                  ).then((value) {
                                    if (value == true) {
                                      insertTipo(nomeTipo);
                                      _insertProdotto(newProdotto);
                                      Fluttertoast.showToast(
                                        msg: 'Prodotto inserito correttamente',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 2,
                                      );
                                    }
                                  });
                                } else {
                                  _insertProdotto(newProdotto);
                                  Fluttertoast.showToast(
                                    msg: 'Prodotto inserito correttamente',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 2,
                                  );
                                }
                              }
                            });
                          } else {
                            if (!containsIgnoreCase(prodotti.keys, nomeTipo)) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Conferma'),
                                    content: Text(
                                        'Vuoi inserire il nuovo tipo "$nomeTipo" nel sistema?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context,
                                              false); // Chiude il dialogo senza confermare
                                        },
                                        child: const Text('Annulla'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context,
                                              true); // Chiude il dialogo e conferma
                                        },
                                        child: const Text('Conferma'),
                                      ),
                                    ],
                                  );
                                },
                              ).then((value) {
                                if (value == true) {
                                  insertTipo(nomeTipo);
                                  _insertProdotto(newProdotto);
                                }
                              });
                            }
                          }
                        } else {
                          _insertProdotto(newProdotto);
                        }
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

void _insertProdotto(Prodotto prodotto) {
  try {
    insertProdotto(prodotto).then((_) {
      Fluttertoast.showToast(
        msg: 'Prodotto inserito correttamente',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
      );
    }).catchError((e) {
      if (e is MySQLServerException && e.errorCode == 1062) {
        // Gestione specifica per l'eccezione Duplicate entry
        Fluttertoast.showToast(
          msg: 'Prodotto già presente nel sistema',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
        );
      } else {
        // Gestione generica per altre eccezioni
        print('Errore: ${e.toString()}');
      }
    });
  } catch (e) {
    print('Errore: ${e.toString()}');
  }
}

bool containsIgnoreCase(Iterable<String> set, String element) {
  for (String e in set) {
    if (e.toLowerCase() == element.toLowerCase()) return true;
  }
  return false;
}
