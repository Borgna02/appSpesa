import 'package:appspesa/pages/mytheme.dart';
import 'package:flutter/material.dart';

import 'pages/home.dart';

void main() => runApp(const AppBarApp());

class AppBarApp extends StatelessWidget {
  const AppBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: MyTheme.getThemeData(),
      home: const Home(),
    );
  }
}
