import 'package:flutter_simulador_copa_2026/models/partida.dart';

class EliminatoriasService {
  final _selecoesTabela = <String, SelecaoTabelaGrupo>{};

  List<Partida> gerarPartidas16Avos(List<Partida> partidasGrupos) {
    _selecoesTabela.clear();

    for (Partida partida in partidasGrupos) {
      final selecao1 = _selecoesTabela.putIfAbsent(
        partida.selecao1.trigrama,
        () => SelecaoTabelaGrupo(partida.selecao1.trigrama),
      );

      final selecao2 = _selecoesTabela.putIfAbsent(
        partida.selecao2.trigrama,
        () => SelecaoTabelaGrupo(partida.selecao1.trigrama),
      );

      final golsSelecao1 = partida.selecao1.golsMarcados;
      final golsSelecao2 = partida.selecao2.golsMarcados;

      if (golsSelecao1 < 0 || golsSelecao2 < 0) {
        continue;
      }

      if (golsSelecao1 > golsSelecao2) {
        selecao1.addVitoria();
        selecao2.addDerrota();
      } else if (golsSelecao1 == golsSelecao2) {
        selecao1.addEmpate();
        selecao2.addEmpate();
      } else {
        selecao1.addDerrota();
        selecao2.addVitoria();
      }

      selecao1.addPartidaDisputada();
      selecao1.addGolsMarcados(golsSelecao1);
      selecao1.addGolsSofridos(golsSelecao2);

      selecao2.addPartidaDisputada();
      selecao2.addGolsMarcados(golsSelecao2);
      selecao2.addGolsSofridos(golsSelecao1);
    }

    return [];
  }
}

class SelecaoTabelaGrupo {
  static final _pontosVitoria = 3;
  static final _pontosEmpate = 1;
  static final _pontosDerrota = 0;

  final String trigrama;
  int _partidasDisputadas; // J
  int _vitorias; // C
  int _empates; // E
  int _derrotas; // D
  int _golsMarcados; // M
  int _golsSofridos; // S

  SelecaoTabelaGrupo(this.trigrama)
    : _partidasDisputadas = 0,
      _vitorias = 0,
      _empates = 0,
      _derrotas = 0,
      _golsMarcados = 0,
      _golsSofridos = 0;

  int get partidasDisputadas => _partidasDisputadas;
  void addPartidaDisputada() {
    _partidasDisputadas++;
  }

  int get vitorias => _vitorias;
  void addVitoria() {
    _vitorias++;
  }

  int get empates => _empates;
  void addEmpate() {
    _empates++;
  }

  int get derrotas => _derrotas;
  void addDerrota() {
    _derrotas++;
  }

  int get golsMarcados => _golsMarcados;
  void addGolsMarcados(int gols) {
    _golsMarcados += gols;
  }

  int get golsSofridos => _golsSofridos;
  void addGolsSofridos(int gols) {
    _golsSofridos += gols;
  }

  int get saldoGols => _golsMarcados - _golsSofridos;

  int get pontos {
    return vitorias * _pontosVitoria +
        empates * _pontosEmpate +
        derrotas * _pontosDerrota;
  }
}
