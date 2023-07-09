import 'package:appspesa/data/data_dispatcher.dart';
import 'package:appspesa/pages/mytheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // blocco la rotazione schermo
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const AppBarApp());
}

class AppBarApp extends StatelessWidget {
  const AppBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: loadData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        // se la richiesta non è ancora eseguita
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            theme: MyTheme.getThemeData(),
            home: const Scaffold(
              body: Center(
                // mostro la rotella di caricamento
                child: CircularProgressIndicator(),
              ),
            ),
          );
          // se la richiesta è stata eseguita con un errore
        } else if (snapshot.hasError) {
          return MaterialApp(
            theme: MyTheme.getThemeData(),
            home: const Scaffold(
              body: Center(
                child: Text('Error loading data'),
              ),
            ),
          );
        } else {
          // se la richiesta è stata eseguita con successo
          return MaterialApp(
            // imposto il tema dalla classe MyTheme
            theme: MyTheme.getThemeData(),
            // apro la schermata home
            home: const Home(),
          );
        }
      },
    );
  }
}
