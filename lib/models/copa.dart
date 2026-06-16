import 'package:flutter_simulador_copa_2026/models/partida.dart';

class Copa {
  final Map<String, List<Partida>> faseGrupos;
  final List<Partida> desesseisAvos;
  final List<Partida> oitavas;
  final List<Partida> quartas;
  final List<Partida> semifinal;
  final Partida terceiroLugar;
  final Partida grandeFinal;

  Copa(List<Partida> partidasCopa)
    : faseGrupos = preencherFaseGrupos(partidasCopa),
      desesseisAvos = preencherDesesseisAvos(partidasCopa),
      oitavas = preencherOitavas(partidasCopa),
      quartas = preencherQuartas(partidasCopa),
      semifinal = preencherSemifinal(partidasCopa),
      terceiroLugar = preencherTerceiroLugar(partidasCopa),
      grandeFinal = preencherGrandeFinal(partidasCopa);

  static Map<String, List<Partida>> preencherFaseGrupos(List<Partida> partidasCopa) {
    //TODO: implemente este método
    throw UnimplementedError();
  }
  
  static List<Partida> preencherDesesseisAvos(List<Partida> partidasCopa) {
    //TODO: implemente este método
    throw UnimplementedError();
  }

  static List<Partida> preencherOitavas(List<Partida> partidasCopa) {
    //TODO: implemente este método
    throw UnimplementedError();
  }

  static List<Partida> preencherQuartas(List<Partida> partidasCopa) {
    //TODO: implemente este método
    throw UnimplementedError();
  }

  static List<Partida> preencherSemifinal(List<Partida> partidasCopa) {
    //TODO: implemente este método
    throw UnimplementedError();
  }

  static Partida preencherTerceiroLugar(List<Partida> partidasCopa) {
    //TODO: implemente este método
    throw UnimplementedError();
  }

  static Partida preencherGrandeFinal(List<Partida> partidasCopa) {
    //TODO: implemente este método
    throw UnimplementedError();
  }

}
