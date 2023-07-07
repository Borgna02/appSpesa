import 'package:mysql_client/mysql_client.dart';

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
