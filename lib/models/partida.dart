import 'package:flutter_simulador_copa_2026/models/dados_selecao_partida.dart';

class Partida {
  final int numero;
  final DateTime dataHora;
  final String local;
  final DadosSelecaoPartida selecao1;
  final DadosSelecaoPartida selecao2;

  const Partida({
    required this.numero,
    required this.dataHora,
    required this.local,
    required this.selecao1,
    required this.selecao2,
  });

  factory Partida.fromJson(Map<String, dynamic> json) {
    return Partida(
      numero: json['numero'] as int,
      dataHora: json['dataHora'] as DateTime,
      local: json['local'] as String,
      selecao1: DadosSelecaoPartida.fromJson(
        json['selecao1'] as Map<String, dynamic>,
      ),
      selecao2: DadosSelecaoPartida.fromJson(
        json['selecao2'] as Map<String, dynamic>,
      ),
    );
  }
}
