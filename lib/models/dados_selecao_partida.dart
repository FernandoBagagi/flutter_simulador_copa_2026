import 'package:flutter_simulador_copa_2026/models/cartoes_selecao_partida.dart';

class DadosSelecaoPartida {
  final String trigrama;
  final int golsMarcados;
  final CartoesSelecaoPartida cartoes;

  const DadosSelecaoPartida({
    required this.trigrama,
    required this.golsMarcados,
    required this.cartoes,
  });

  factory DadosSelecaoPartida.fromJson(Map<String, dynamic> json) {
    return DadosSelecaoPartida(
      trigrama: json['trigrama'] as String,
      golsMarcados: json['golsMarcados'] as int,
      cartoes: CartoesSelecaoPartida.fromJson(
        json['cartoes'] as Map<String, dynamic>,
      ),
    );
  }
}
