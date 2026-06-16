class Grupo {
  final String letra;
  final String trigramaSelecao1;
  final String trigramaSelecao2;
  final String trigramaSelecao3;
  final String trigramaSelecao4;

  const Grupo({
    required this.letra,
    required this.trigramaSelecao1,
    required this.trigramaSelecao2,
    required this.trigramaSelecao3,
    required this.trigramaSelecao4,
  });

  factory Grupo.fromJson(Map<String, dynamic> json) {
    return Grupo(
      letra: json['letra'] as String,
      trigramaSelecao1: json['trigramaSelecao1'] as String,
      trigramaSelecao2: json['trigramaSelecao2'] as String,
      trigramaSelecao3: json['trigramaSelecao3'] as String,
      trigramaSelecao4: json['trigramaSelecao4'] as String,
    );
  }
}
