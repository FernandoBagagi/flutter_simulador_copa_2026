import 'package:flutter/material.dart';
import 'package:flutter_simulador_copa_2026/models/partida.dart';
import 'package:flutter_simulador_copa_2026/models/selecao.dart';

class PartidaWidgetContoller extends ChangeNotifier {
  final Partida partida;
  final Selecao selecao1;
  final Selecao selecao2;

  PartidaWidgetContoller({
    required this.partida,
    required this.selecao1,
    required this.selecao2,
  });
}
