import 'dart:convert';
import 'dart:typed_data';

import '../connection/connection_railway.dart';
import '../domain/prodotto.dart';

Map<String, List<Prodotto>> prodotti = {};

Future<void> loadProdotti() async {
  final conn = await connectToDatabase();

  // Esegue la query per ottenere i dati dal database
  var results = await conn.execute('SELECT * FROM tipo');
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
        bool isDaRicomprare = (prodotto.colAt(4) == 'true');
        bool? isPiaciuto;
        if (prodotto.colAt(5) != null) {
          isPiaciuto = (prodotto.colAt(5) == 'true');
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
