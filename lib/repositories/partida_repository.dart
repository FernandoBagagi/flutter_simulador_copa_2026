import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_simulador_copa_2026/models/partida.dart';

class PartidaRepository {
  Future<List<Partida>> findAll() async {
    final stringJsonPartidas = await rootBundle.loadString(
      'assets/partidas-grupos.json',
    );

    final jsonPartidas =
        json.decode(stringJsonPartidas) as Map<String, dynamic>;

    final partidas = jsonPartidas['partidas'] as List<dynamic>;

    return partidas
        .map((jsonItem) => Partida.fromJson(jsonItem as Map<String, dynamic>))
        .toList();
  }
}
