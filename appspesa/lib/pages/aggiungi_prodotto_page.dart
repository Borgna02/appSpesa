// ignore_for_file: unused_field

import 'package:appspesa/widgets/votazione_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AggiungiProdottoPage extends StatefulWidget {
  @override
  _AggiungiProdottoPageState createState() => _AggiungiProdottoPageState();
}

class _AggiungiProdottoPageState extends State<AggiungiProdottoPage> {
  final _formKey = GlobalKey<FormState>();
  final _marcaController = TextEditingController();
  final _tipoController = TextEditingController();
  File? _selectedImage;

  @override
  void dispose() {
    _marcaController.dispose();
    _tipoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _selectedImage = File(pickedImage.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aggiungi Prodotto'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Inserisci il nome del prodotto';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _marcaController,
                  decoration: const InputDecoration(
                    labelText: 'Marca',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Inserisci la marca del prodotto';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _tipoController,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Inserisci il tipo del prodotto';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Scegli Immagine'),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [VotazioneButton()],
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Esegue l'azione di salvataggio dei dati
                    }
                  },
                  child: const Text('Salva'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
