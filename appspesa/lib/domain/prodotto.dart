class Prodotto {
  int id;
  String nome;
  String nomeMarca;
  String nomeTipo;
  bool isDaRicomprare;
  bool? isPiaciuto;
  String? nota;

  Prodotto({
    required this.id,
    required this.nome,
    required this.nomeMarca,
    required this.nomeTipo,
    required this.isDaRicomprare,
    this.isPiaciuto,
    this.nota,
  });
}
