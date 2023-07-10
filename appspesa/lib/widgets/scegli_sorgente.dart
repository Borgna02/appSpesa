import 'package:appspesa/pages/mytheme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SorgenteChoiceBox extends StatelessWidget {
  const SorgenteChoiceBox({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = MyTheme.getThemeData().colorScheme;
    final primary = colorScheme
        .primary; // Usa il colore primario come colore di evidenziazione
    return AlertDialog(
      title: const Text('Scegli la sorgente'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            GestureDetector(
              child: Column(
                children: [
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Text('Camera'),
                      const SizedBox(width: 8.0),
                      Icon(Icons.photo_camera, color: primary),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
              onTap: () {
                Navigator.of(context).pop(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 16),
            GestureDetector(
              child: Column(
                children: [
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      const Text('Galleria'),
                      const SizedBox(width: 8.0),
                      Icon(
                        Icons.photo_library,
                        color: primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
              onTap: () {
                Navigator.of(context).pop(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }
}
