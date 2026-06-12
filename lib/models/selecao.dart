class Selecao {
  final String trigrama;
  final String codigoPais;
  final String nome;

  const Selecao({
    required this.trigrama,
    required this.codigoPais,
    required this.nome,
  });

  String get pathBandeira => 'assets/bandeiras/$codigoPais.svg';

  factory Selecao.fromJson(Map<String, dynamic> json) {
    return Selecao(
      trigrama: json['trigrama'] as String,
      codigoPais: json['codigo_pais'] as String,
      nome: json['pt_BR'] as String,
    );
  }
}
