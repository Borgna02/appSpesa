import 'dart:typed_data';

class Prodotto {
  int? id;
  String nome;
  String nomeMarca;
  String nomeTipo;
  bool isDaRicomprare;
  bool? isPiaciuto;
  Uint8List? immagine;

  Prodotto({
    this.id,
    required this.nome,
    required this.nomeMarca,
    required this.nomeTipo,
    required this.isDaRicomprare,
    this.isPiaciuto,
    this.immagine,
  });
}
