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
        () => SelecaoTabelaGrupo(partida.selecao2.trigrama),
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

    final tabelasGrupo = {
      'A': TabelaGrupo('A'),
      'B': TabelaGrupo('B'),
      'C': TabelaGrupo('C'),
      'D': TabelaGrupo('D'),
      'E': TabelaGrupo('E'),
      'F': TabelaGrupo('F'),
      'G': TabelaGrupo('G'),
      'H': TabelaGrupo('H'),
      'I': TabelaGrupo('I'),
      'J': TabelaGrupo('J'),
      'K': TabelaGrupo('K'),
      'L': TabelaGrupo('L'),
    };

    final grupos = {
      'A': ['mex', 'rsa', 'kor', 'cze'],
      'B': ['sui', 'can', 'bih', 'qat'],
      'C': ['bra', 'mar', 'sco', 'hai'],
      'D': ['usa', 'aus', 'par', 'tur'],
      'E': ['ger', 'civ', 'ecu', 'cuw'],
      'F': ['ned', 'jpn', 'swe', 'tun'],
      'G': ['egy', 'irn', 'bel', 'nzl'],
      'H': ['esp', 'uru', 'cpv', 'ksa'],
      'I': ['fra', 'nor', 'sen', 'irq'],
      'J': ['arg', 'aut', 'alg', 'jor'],
      'K': ['col', 'por', 'cod', 'uzb'],
      'L': ['eng', 'gha', 'cro', 'pan'],
    };

    for (final grupo in grupos.entries) {
      for (final trigrama in grupo.value) {
        tabelasGrupo[grupo.key]!.addSelecao(
          _selecoesTabela[trigrama.toUpperCase()]!,
        );
      }
    }

    tabelasGrupo.values.forEach(print);

    final tabelaTerceiroLugar = TabelaGrupo('Terceiro lugar');

    for (final tabela in tabelasGrupo.values) {
      tabelaTerceiroLugar.addSelecao(tabela.terceiro);
    }

    print(tabelaTerceiroLugar);
    
    return [];
  }
}

class SelecaoTabelaGrupo implements Comparable<SelecaoTabelaGrupo> {
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

  int get fairPlay {
    //TODO:
    throw UnimplementedError();
  }

  int get rankFifa {
    //TODO:
    throw UnimplementedError();
  }

  // Fonte: https://ge.globo.com/futebol/copa-do-mundo/noticia/2026/06/24/criterios-de-desempate-na-copa-do-mundo-entenda-as-regras-para-a-ultima-rodada-da-fase-de-grupos.ghtml
  @override
  int compareTo(SelecaoTabelaGrupo other) {
    if (pontos != other.pontos) {
      return other.pontos.compareTo(pontos);
    }
    if (saldoGols != other.saldoGols) {
      return other.saldoGols.compareTo(saldoGols);
    }
    if (golsMarcados != other.golsMarcados) {
      return other.golsMarcados.compareTo(golsMarcados);
    }
    if (fairPlay != other.fairPlay) {
      //TODO: Verificar se não é o contrário
      return fairPlay.compareTo(other.fairPlay);
    }
    return rankFifa.compareTo(other.rankFifa);
  }
}

class TabelaGrupo {
  final String letra;
  final List<SelecaoTabelaGrupo> _selecoes;

  TabelaGrupo(this.letra) : _selecoes = [];

  void addSelecao(SelecaoTabelaGrupo selecao) {
    _selecoes.add(selecao);
    _selecoes.sort();
  }

  SelecaoTabelaGrupo get terceiro => _selecoes.elementAt(2);

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Grupo ${letra.toUpperCase()}');
    buffer.writeln('Equipe  Pts  V  E  D  GM  GS  SG');

    for (int i = 0; i < _selecoes.length; i++) {
      final selecao = _selecoes.elementAt(i);
      if (i + 1 < 10) {
        buffer.write(' ');
      }
      buffer.write(i + 1);
      buffer.write(' ');
      buffer.write(selecao.trigrama);
      buffer.write('   ');
      buffer.write(selecao.pontos);
      buffer.write('   ');
      buffer.write(selecao.vitorias);
      buffer.write('  ');
      buffer.write(selecao.empates);
      buffer.write('  ');
      buffer.write(selecao.derrotas);
      buffer.write('  ');
      if (selecao.golsMarcados < 10) {
        buffer.write(' ');
      }
      buffer.write(selecao.golsMarcados);
      buffer.write('  ');
      if (selecao.golsSofridos < 10) {
        buffer.write(' ');
      }
      buffer.write(selecao.golsSofridos);
      buffer.write(' ');
      if (selecao.saldoGols >= 10) {
        buffer.write(' ');
      } else if (selecao.saldoGols >= 0) {
        buffer.write('  ');
      } else if (selecao.saldoGols > -10) {
        buffer.write(' ');
      }
      buffer.writeln(selecao.saldoGols);
    }

    return buffer.toString();
  }
}
