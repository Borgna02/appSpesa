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
