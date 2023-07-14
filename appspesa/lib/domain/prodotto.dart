import 'dart:typed_data';

class Prodotto {
  int? id;
  String nome;
  String nomeMarca;
  String nomeTipo;
  bool isDaRicomprare;
  bool? isPiaciuto;
  Uint8List? immagine;
  bool isDaMostrare;

  Prodotto({
    this.id,
    required this.nome,
    required this.nomeMarca,
    required this.nomeTipo,
    required this.isDaRicomprare,
    this.isPiaciuto,
    this.immagine,
    required this.isDaMostrare,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Prodotto &&
        runtimeType == other.runtimeType &&
        nome == other.nome &&
        nomeMarca.toLowerCase() == other.nomeMarca.toLowerCase() &&
        nomeTipo.toLowerCase() == other.nomeTipo.toLowerCase() &&
        isDaRicomprare == other.isDaRicomprare &&
        isPiaciuto == other.isPiaciuto;
  }

  @override
  int get hashCode {
    return nome.hashCode ^
        nomeMarca.hashCode ^
        nomeTipo.hashCode ^
        isDaRicomprare.hashCode ^
        isPiaciuto.hashCode;
  }

  @override
  String toString() {
    return 'Prodotto(id: $id, nome: $nome, nomeMarca: $nomeMarca, nomeTipo: $nomeTipo, isDaRicomprare: $isDaRicomprare, isPiaciuto: $isPiaciuto)';
  }
}
