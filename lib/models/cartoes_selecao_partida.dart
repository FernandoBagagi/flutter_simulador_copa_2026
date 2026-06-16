class CartoesSelecaoPartida {
  final int amarelo; // -1
  final int vermelhoIndireto; // -3
  final int vermelhoDireto; // -4
  final int amareloVermelhoDireto; // -5

  const CartoesSelecaoPartida({
    required this.amarelo,
    required this.vermelhoIndireto,
    required this.vermelhoDireto,
    required this.amareloVermelhoDireto,
  });

  factory CartoesSelecaoPartida.fromJson(Map<String, dynamic> json) {
    return CartoesSelecaoPartida(
      amarelo: json['amarelo'] as int? ?? 0,
      vermelhoIndireto: json['vermelhoIndireto'] as int? ?? 0,
      vermelhoDireto: json['vermelhoDireto'] as int? ?? 0,
      amareloVermelhoDireto: json['amareloVermelhoDireto'] as int? ?? 0,
    );
  }
}
