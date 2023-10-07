// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:mysql_client/mysql_client.dart';
import '../data/data_dispatcher.dart';
import '../domain/prodotto.dart';

Future<MySQLConnection> connectToDatabase() async {
  print("Connecting to mysql server...");

  // create connection
  // create connection
  final conn = await MySQLConnection.createConnection(
    // host: 'localhost',
    host: '10.0.2.2',
    port: 3306,
    userName: 'spesaUser',
    password: 'spesaPwd',
    databaseName: 'appSpesaDB',
    // secure: false
  );

  await conn.connect();

  print("Connected");

  return conn;
}

Future<void> insertMarca(String marca) async {
  final conn = await connectToDatabase();

  await conn.execute('INSERT INTO marca VALUE ("$marca")');
  marche.add(marca);

  await conn.close();
  print("Disconnected from database");
}

Future<void> insertTipo(String tipo) async {
  final conn = await connectToDatabase();
  print("In insert tipo");

  await conn.execute('INSERT INTO tipo VALUE ("$tipo")');

  await conn.close();
  print("Disconnected from database");
}

Future<void> updateProdotto(
    Prodotto vecchioProdotto, Prodotto nuovoProdotto) async {
  final conn = await connectToDatabase();
  print("In update prodotto");

  try {
    await conn.execute(
      'UPDATE prodotto SET nome = :nome, nome_marca = :nomeMarca, nome_tipo = :nomeTipo, isDaRicomprare = :isDaRicomprare, isPiaciuto = :isPiaciuto WHERE id = :id;',
      {
        'id': nuovoProdotto.id,
        'nome': nuovoProdotto.nome,
        'nomeMarca': nuovoProdotto.nomeMarca,
        'nomeTipo': nuovoProdotto.nomeTipo,
        'isDaRicomprare': nuovoProdotto.isDaRicomprare,
        'isPiaciuto': nuovoProdotto.isPiaciuto,
      },
    );

    prodotti[vecchioProdotto.nomeTipo]?.remove(vecchioProdotto);

    // Controllo se il tipo del prodotto è già presente nella mappa prodotti
    insertProdottoRAM(nuovoProdotto);
  } on Exception {
    rethrow;
  }

  await conn.close();
  print("Disconnected from database");
}

Future<void> insertOrUpdateProdotto(
    Prodotto? vecchioProdotto, Prodotto nuovoProdotto) async {
  if (vecchioProdotto == null) {
    try {
      await insertProdotto(nuovoProdotto);
    } catch (e) {
      print("Exception in insertOrUpdateProdotto");
      rethrow;
    }
  } else {
    try {
      await updateProdotto(vecchioProdotto, nuovoProdotto);
    } on Exception {
      rethrow;
    }
  }
}

Future<void> insertProdotto(
  Prodotto prodotto,
) async {
  final conn = await connectToDatabase();
  print("In insert prodotto");

  String immagineString = base64.encode(prodotto.immagine!);
  try {
    var result = await conn.execute(
      'INSERT INTO prodotto (nome, nome_marca, nome_tipo, isDaRicomprare, isPiaciuto, immagine) VALUES (:nome, :nomeMarca, :nomeTipo, :isDaRicomprare, :isPiaciuto, :immagine);',
      {
        'nome': prodotto.nome,
        'nomeMarca': prodotto.nomeMarca,
        'nomeTipo': prodotto.nomeTipo,
        'isDaRicomprare': prodotto.isDaRicomprare,
        'isPiaciuto': prodotto.isPiaciuto,
        'immagine': immagineString,
      },
    );

    prodotto.id = result.lastInsertID.toInt();

    insertProdottoRAM(prodotto);
  } catch (e) {
    print("Errore");
    rethrow;
  }
  await conn.close();
  print("Disconnected from database");
}
