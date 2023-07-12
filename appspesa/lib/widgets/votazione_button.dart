// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

import '../pages/mytheme.dart';

class VotazioneButton extends StatefulWidget {
  final bool? defaultVote;
  final void Function(bool?)? onVoteSelected;

  const VotazioneButton({Key? key, this.onVoteSelected, this.defaultVote})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VotazioneButtonState createState() => _VotazioneButtonState();
}

class _VotazioneButtonState extends State<VotazioneButton> {
  late List<bool> _selections;
  @override
  initState() {
    super.initState();
    if (widget.defaultVote == null) {
      _selections = [false, true, false];
    } else if (widget.defaultVote == true) {
      _selections = [true, false, false];
    } else {
      _selections = [false, false, true];
    }
  }

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
