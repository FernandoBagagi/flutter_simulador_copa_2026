import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_simulador_copa_2026/models/selecao.dart';

class SelecaoRepository {
  Future<List<Selecao>> findAll() async {
    final stringJsonSelecoes = await rootBundle.loadString(
      'assets/selecoes.json',
    );

    final jsonSelecoes =
        json.decode(stringJsonSelecoes) as Map<String, dynamic>;

    final selecoes = jsonSelecoes['selecoes'] as List<dynamic>;

    return selecoes
        .map((jsonItem) => Selecao.fromJson(jsonItem as Map<String, dynamic>))
        .toList();
  }
}
