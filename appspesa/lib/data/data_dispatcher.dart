// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:appspesa/widgets/conferma_marca.dart';
import 'package:appspesa/widgets/conferma_tipo.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql_client/exception.dart';

import '../connection/connection_railway.dart';
import '../domain/prodotto.dart';
import '../utilities/utilities.dart';

Map<String, List<Prodotto>> prodotti = {};
List<String> marche = [];

Future<void> loadData() async {
  final conn = await connectToDatabase();

  var results = await conn.execute('SELECT * FROM marca');
  for (var row in results.rows) {
    marche.add(row.colAt(0)!);
  }
  print("Fine prima query");

  results = await conn.execute('SELECT * FROM tipo');
  for (var row in results.rows) {
    prodotti[row.colAt(0)!] = [];
  }
  print("Fine seconda query");

  // Esegue la query per ottenere i dati dal database
  results = await conn.execute('SELECT * FROM prodotto');
  print("Fine terza query");

  for (var prodotto in results.rows) {
    bool? isPiaciuto;

    if (prodotto.colAt(5) != null) {
      isPiaciuto = (prodotto.colAt(5) == "1");
    }
    Uint8List? immagine;
    if (prodotto.colAt(6) == null) {
      immagine = null;
    } else {
      immagine = base64
          .decode(prodotto.colAt(6) as String); // Valore BLOB come stringa
    }

    var nuovoProdotto = Prodotto(
        id: int.parse(prodotto.colAt(0) as String),
        nome: prodotto.colAt(1) as String,
        nomeMarca: prodotto.colAt(2) as String,
        nomeTipo: prodotto.colAt(3) as String,
        isDaRicomprare: (prodotto.colAt(4) == '1'),
        isPiaciuto: isPiaciuto,
        immagine: immagine);

    insertProdottoRAM(nuovoProdotto);
  }

  print("Disconnected from database");
  await conn.close();

  return;
}

Future<bool> marcaTipoCheck(BuildContext context, Prodotto? vecchioProdotto,
    Prodotto nuovoProdotto) async {
  Completer<bool> completer = Completer<bool>();

  if (!containsIgnoreCase(marche, nuovoProdotto.nomeMarca) ||
      !containsIgnoreCase(prodotti.keys, nuovoProdotto.nomeTipo)) {
    if (!containsIgnoreCase(marche, nuovoProdotto.nomeMarca)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfermaMarca(nomeMarca: nuovoProdotto.nomeMarca);
        },
      ).then((value) {
        if (value == true) {
          if (!containsIgnoreCase(prodotti.keys, nuovoProdotto.nomeTipo)) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return ConfermaTipo(nomeTipo: nuovoProdotto.nomeTipo);
              },
            ).then((value) {
              if (value == true) {
                _insertOrUpdateProdotto(
                        context, vecchioProdotto, nuovoProdotto, true, true)
                    .then((result) {
                  completer.complete(true);
                });
              } else {
                completer.complete(false);
              }
            });
          } else {
            for (String key in prodotti.keys) {
              if (key.toLowerCase() == nuovoProdotto.nomeTipo.toLowerCase()) {
                nuovoProdotto.nomeTipo = key;
              }
            }
            _insertOrUpdateProdotto(
                    context, vecchioProdotto, nuovoProdotto, false, true)
                .then((result) {
              completer.complete(true);
            });
          }
        } else {
          completer.complete(false);
        }
      });
    } else {
      if (!containsIgnoreCase(prodotti.keys, nuovoProdotto.nomeTipo)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ConfermaTipo(nomeTipo: nuovoProdotto.nomeTipo);
          },
        ).then((value) {
          if (value == true) {
            _insertOrUpdateProdotto(
                    context, vecchioProdotto, nuovoProdotto, true, false)
                .then((result) {
              completer.complete(true);
            });
          } else {
            completer.complete(false);
          }
        });
      } else {
        completer.complete(false);
      }
    }
  } else {
    for (String key in prodotti.keys) {
      if (key.toLowerCase() == nuovoProdotto.nomeTipo.toLowerCase()) {
        nuovoProdotto.nomeTipo = key;
      }
    }

    for (String marca in marche) {
      if (marca.toLowerCase() == nuovoProdotto.nomeMarca.toLowerCase()) {
        nuovoProdotto.nomeMarca = marca;
      }
    }

    _insertOrUpdateProdotto(
            context, vecchioProdotto, nuovoProdotto, false, false)
        .then((result) {
      completer.complete(true);
    });
  }

  return completer.future;
}

Future<void> _insertOrUpdateProdotto(
    BuildContext context,
    Prodotto? vecchioProdotto,
    Prodotto nuovoProdotto,
    bool addTipo,
    bool addMarca) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Inserimento in corso...'),
          ],
        ),
      );
    },
  );

  try {
    if (addTipo) {
      await insertTipo(nuovoProdotto.nomeTipo);
    }
    if (addMarca) {
      await insertMarca(nuovoProdotto.nomeMarca);
    }
    await insertOrUpdateProdotto(vecchioProdotto, nuovoProdotto).then((_) {
      Navigator.of(context)
          .pop(); // Chiude la AlertDialog del progress indicator

      Fluttertoast.showToast(
        msg: 'Prodotto inserito correttamente',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
      );

      Navigator.of(context).pop({
        'tipoAdded': nuovoProdotto.nomeTipo,
        'prodottoEdited': vecchioProdotto,
        'prodottoAdded': nuovoProdotto,
      });
    }).catchError((e) {
      Navigator.of(context)
          .pop(); // Chiude la AlertDialog del progress indicator

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
    Navigator.of(context).pop(); // Chiude la AlertDialog del progress indicator
    print('Errore: ${e.toString()}');
  }
}

void insertProdottoRAM(Prodotto nuovoProdotto) {
  if (prodotti.containsKey(nuovoProdotto.nomeTipo)) {
    // Se il tipo è già presente, aggiungo il prodotto alla lista corrispondente
    prodotti[nuovoProdotto.nomeTipo]?.add(nuovoProdotto);
  } else {
    // Se il tipo non è presente, creo una nuova lista con il prodotto e la aggiungo alla mappa
    insertKeyInAlphOrder(prodotti, nuovoProdotto.nomeTipo, nuovoProdotto);
    // prodotti[nuovoProdotto.nomeTipo] = [nuovoProdotto];
  }
}

void insertKeyInAlphOrder(
    Map<String, List<Prodotto>> map, String newKey, Prodotto value) {
  List<String> sortedKeys = map.keys.toList();
  sortedKeys.add(newKey);
  sortedKeys = mergeSortIgnoreCase(sortedKeys);

  for (String a in sortedKeys) {
    print(a);
  }

  Map<String, List<Prodotto>> newMap = {};
  for (String key in sortedKeys) {
    if (key == newKey) {
      newMap[key] = [value];
    } else {
      newMap[key] = map[key]!;
    }
  }

  prodotti = newMap;
}
