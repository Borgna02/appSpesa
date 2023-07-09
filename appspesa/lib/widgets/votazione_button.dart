// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

import '../pages/mytheme.dart';

class VotazioneButton extends StatefulWidget {
  final void Function(bool?)? onVoteSelected;

  const VotazioneButton({Key? key, this.onVoteSelected}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VotazioneButtonState createState() => _VotazioneButtonState();
}

class _VotazioneButtonState extends State<VotazioneButton> {
  // in questo modo di default la selezione è impostata sull'orologio
  List<bool> _selections = [false, true, false];
  bool? isPiaciuto;

  void _setSelection(int index) {
    setState(() {
      _selections = List.generate(3, (i) => i == index);
      if (index == 0) {
        isPiaciuto = true;
      } else if (index == 1) {
        isPiaciuto = null;
      } else {
        isPiaciuto = false;
      }

      // Richiama la callback con il valore selezionato
      if (widget.onVoteSelected != null) {
        widget.onVoteSelected!(isPiaciuto);
      }
    });
  }

  // costruzione del button
  @override
  Widget build(BuildContext context) {
    final colorScheme = MyTheme.getThemeData().colorScheme;
    final accentColor = colorScheme
        .primary; // Usa il colore primario come colore di evidenziazione

    return ToggleButtons(
      children: const [
        Icon(Icons.thumb_up),
        Icon(Icons.watch_later),
        Icon(Icons.thumb_down),
      ],
      isSelected: _selections,
      onPressed: _setSelection,
      selectedColor: accentColor,
      borderRadius: BorderRadius.circular(8.0),
      borderWidth: 2.0,
    );
  }
}
