// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

import '../pages/mytheme.dart';

class SiNoButton extends StatefulWidget {
  final void Function(bool?)? onVoteSelected;
  final bool defaultIsDaRicomprare;

  const SiNoButton({Key? key, this.onVoteSelected, required this.defaultIsDaRicomprare})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SiNoButtonState createState() => _SiNoButtonState();
}

class _SiNoButtonState extends State<SiNoButton> {
  // in questo modo di default la selezione è impostata sull'orologio
  late List<bool> _selections;
  @override
  initState() {
    super.initState();
    if (widget.defaultIsDaRicomprare) {
      _selections = [true, false];
    } else {
      _selections = [false, true];
    }
  }

  bool? isDaRicomprare;

  void _setSelection(int index) {
    setState(() {
      _selections = List.generate(2, (i) => i == index);
      if (index == 0) {
        isDaRicomprare = true;
      } else {
        isDaRicomprare = false;
      }

      // Richiama la callback con il valore selezionato
      if (widget.onVoteSelected != null) {
        widget.onVoteSelected!(isDaRicomprare);
      }
    });
    FocusScope.of(context).unfocus(); // Chiude la tastiera
  }

  // costruzione del button
  @override
  Widget build(BuildContext context) {
    final colorScheme = MyTheme.getThemeData().colorScheme;
    final accentColor = colorScheme
        .primary; // Usa il colore primario come colore di evidenziazione

    return ToggleButtons(
      children: const [
        Text("Sì", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text("No", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
      isSelected: _selections,
      onPressed: _setSelection,
      selectedColor: accentColor,
      borderRadius: BorderRadius.circular(8.0),
      borderWidth: 2.0,
    );
  }
}
