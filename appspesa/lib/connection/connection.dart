import 'package:mysql_client/mysql_client.dart';

import '../domain/prodotto.dart';

Future<MySQLConnection> connectToDatabase() async {
  print("Connecting to mysql server...");

  // create connection
  final conn = await MySQLConnection.createConnection(
    host: '10.0.2.2',
    port: 3306,
    userName: 'spesaUser',
    password: 'spesaPwd',
    databaseName: 'spesa',
  );

  await conn.connect();

  print("Connected");

  return conn;
}

Future<List<String>> fetchTypeSuggestions(String input) async {
  List<String> suggestions = [];
  if (input.isNotEmpty) {
    final conn = await connectToDatabase();

    var results = await conn.execute(
        '(SELECT nome FROM tipo WHERE nome LIKE "$input") UNION (SELECT nome FROM tipo WHERE nome LIKE CONCAT("%","$input","%")) UNION (SELECT nome FROM tipo WHERE soundex(soundex(nome)) = soundex(soundex("$input"))) LIMIT 5;');

    for (var row in results.rows) {
      suggestions.add(row.colByName("nome")!);
    }

    await conn.close();
    print("Disconnected from database");
  }

  return suggestions;
}

Future<void> insertProdotto(Prodotto prodotto) async {
  final conn = await connectToDatabase();

  var results = await conn.execute(
      'INSERT INTO prodotto (nome, nome_marca, nome_tipo, isDaRicomprare, isPiaciuto, Immagine) VALUES ("${prodotto.nome}", ${prodotto.nomeMarca}, ${prodotto.nomeTipo}, ${prodotto.isDaRicomprare}, ${prodotto.isPiaciuto}, ${prodotto.immagine}});');

  await conn.close();
  print("Disconnected from database");
}
