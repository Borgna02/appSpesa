// ignore_for_file: avoid_print

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

  // Esegue la query per ottenere i dati dal database
  results = await conn.execute('SELECT * FROM tipo');
  // Map<String, List<Prodotto>> prodotti = {};
  for (var row in results.rows) {
    String? value = row.colAt(0);
    if (value != null) {
      List<Prodotto> prodottiList = [];
      var otherResult = await conn.execute(
          'SELECT * FROM prodotto WHERE nome_tipo = :tipo', {'tipo': value});

      for (var prodotto in otherResult.rows) {
        int idProdotto = int.parse(prodotto.colAt(0) as String);
        String nomeProdotto = prodotto.colAt(1) as String;
        String nomeMarca = prodotto.colAt(2) as String;
        String nomeTipo = value;
        bool isDaRicomprare = (prodotto.colAt(4) == '1');
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

        prodottiList.add(Prodotto(
            id: idProdotto,
            nome: nomeProdotto,
            nomeMarca: nomeMarca,
            nomeTipo: nomeTipo,
            isDaRicomprare: isDaRicomprare,
            isPiaciuto: isPiaciuto,
            immagine: immagine));
      }

      prodotti[value] = prodottiList;
    }
  }

  print("Disconnected from database");
  await conn.close();

  return;
}

void marcaTipoCheck(
    BuildContext context, Prodotto? vecchioProdotto, Prodotto nuovoProdotto) {
  if (!containsIgnoreCase(marche, nuovoProdotto.nomeMarca) ||
      !containsIgnoreCase(prodotti.keys, nuovoProdotto.nomeTipo)) {
    // se bisogna aggiungere uno tra tipo e marca
    if (!containsIgnoreCase(marche, nuovoProdotto.nomeMarca)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfermaMarca(nomeMarca: nuovoProdotto.nomeMarca);
        },
      ).then((value) {
        if (value == true) {
          insertMarca(nuovoProdotto.nomeMarca);
          if (!containsIgnoreCase(prodotti.keys, nuovoProdotto.nomeTipo)) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ConfermaTipo(nomeTipo: nuovoProdotto.nomeTipo);
                }).then((value) {
              if (value == true) {
                insertTipo(nuovoProdotto.nomeTipo);
                _insertOrUpdateProdotto(
                    context, vecchioProdotto, nuovoProdotto);
              }
            });
          } else {
            _insertOrUpdateProdotto(context, vecchioProdotto, nuovoProdotto);
          }
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
            insertTipo(nuovoProdotto.nomeTipo);
            _insertOrUpdateProdotto(context, vecchioProdotto, nuovoProdotto);
          }
        });
      }
    }
  } else {
    _insertOrUpdateProdotto(context, vecchioProdotto, nuovoProdotto);
  }
}

void _insertOrUpdateProdotto(
    BuildContext context, Prodotto? vecchioProdotto, Prodotto nuovoProdotto) {
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
    insertOrUpdateProdotto(vecchioProdotto, nuovoProdotto).then((_) {
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
