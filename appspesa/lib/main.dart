import 'package:appspesa/data/data_dispatcher.dart';
import 'package:appspesa/pages/mytheme.dart';
import 'package:flutter/material.dart';

import 'pages/home.dart';

void main() => runApp(const AppBarApp());

class AppBarApp extends StatelessWidget {
  const AppBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: loadProdotti(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            theme: MyTheme.getThemeData(),
            home: const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
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
          return MaterialApp(
            theme: MyTheme.getThemeData(),
            home: const Home(),
          );
        }
      },
    );
  }
}
