import 'package:appspesa/pages/home_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  bloccaRotazione();
  runApp(const AppSpesa());
}

class AppSpesa extends StatelessWidget {
  const AppSpesa({super.key});

  @override
  Widget build(BuildContext context) {
    return loadHome();
  }
}

void bloccaRotazione() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

// TODO aggiungere tasto elimina tipo quando un tipo non ha prodotti associati
// TODO ordinare le chiavi della mappa prodotti ignorando il case
// TODO aggiungere circularProgressIndicator anche durante l'aggiunta del tipo (unire aggiunta tipo e prodotto in un unico metodo)