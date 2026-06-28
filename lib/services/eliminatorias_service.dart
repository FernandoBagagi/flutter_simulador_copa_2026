import 'package:flutter_simulador_copa_2026/models/dados_selecao_partida.dart';
import 'package:flutter_simulador_copa_2026/models/partida.dart';
import 'package:flutter_simulador_copa_2026/repositories/combinacoes_melhores_terceiros_repository.dart';
import 'package:flutter_simulador_copa_2026/services/selecao_tabela_grupo.dart';
import 'package:flutter_simulador_copa_2026/services/tabela_grupo.dart';

class EliminatoriasService {
  static final grupos = {
    'A': ['MEX', 'RSA', 'KOR', 'CZE'],
    'B': ['SUI', 'CAN', 'BIH', 'QAT'],
    'C': ['BRA', 'MAR', 'SCO', 'HAI'],
    'D': ['USA', 'AUS', 'PAR', 'TUR'],
    'E': ['GER', 'CIV', 'ECU', 'CUW'],
    'F': ['NED', 'JPN', 'SWE', 'TUN'],
    'G': ['EGY', 'IRN', 'BEL', 'NZL'],
    'H': ['ESP', 'URU', 'CPV', 'KSA'],
    'I': ['FRA', 'NOR', 'SEN', 'IRQ'],
    'J': ['ARG', 'AUT', 'ALG', 'JOR'],
    'K': ['COL', 'POR', 'COD', 'UZB'],
    'L': ['ENG', 'GHA', 'CRO', 'PAN'],
  };

  final CombinacoesMelhoresTerceirosRepository combinacoesRepository;

  EliminatoriasService(this.combinacoesRepository);

  Future<List<Partida>> gerarPartidas16Avos(
    List<Partida> partidasGrupos,
  ) async {
    final selecoesTabela = <String, SelecaoTabelaGrupo>{};

    for (Partida partida in partidasGrupos) {
      final selecao1 = selecoesTabela.putIfAbsent(
        partida.selecao1.trigrama,
        () {
          return SelecaoTabelaGrupo(
            trigrama: partida.selecao1.trigrama,
            rankFifa: partida.selecao1.rankFifa,
          );
        },
      );

      final selecao2 = selecoesTabela.putIfAbsent(
        partida.selecao2.trigrama,
        () {
          return SelecaoTabelaGrupo(
            trigrama: partida.selecao2.trigrama,
            rankFifa: partida.selecao2.rankFifa,
          );
        },
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
      selecao1.addCartoesAmarelo(partida.selecao1.cartoes.amarelo);
      selecao1.addCartoesVermelho(partida.selecao1.cartoes.vermelhoDireto);

      selecao2.addPartidaDisputada();
      selecao2.addGolsMarcados(golsSelecao2);
      selecao2.addGolsSofridos(golsSelecao1);
      selecao2.addCartoesAmarelo(partida.selecao2.cartoes.amarelo);
      selecao2.addCartoesVermelho(partida.selecao2.cartoes.vermelhoDireto);
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

    for (final grupo in grupos.entries) {
      final tabelaGrupo = tabelasGrupo[grupo.key]!;
      for (final trigrama in grupo.value) {
        tabelaGrupo.addSelecao(selecoesTabela[trigrama]!);
      }
    }

    final tabelaTerceiroLugar = TabelaGrupo('Terceiro lugar');

    for (final tabela in tabelasGrupo.values) {
      tabelaTerceiroLugar.addSelecao(tabela.terceiro);
    }

    tabelasGrupo['Terceiro lugar'] = tabelaTerceiroLugar;

    //tabelasGrupo.values.forEach(print);

    final terceirosLugares = await getListaTerceiros(tabelaTerceiroLugar);

    final a = tabelasGrupo['A']!;
    final b = tabelasGrupo['B']!;
    final c = tabelasGrupo['C']!;
    final d = tabelasGrupo['D']!;
    final e = tabelasGrupo['E']!;
    final f = tabelasGrupo['F']!;
    final g = tabelasGrupo['G']!;
    final h = tabelasGrupo['H']!;
    final i = tabelasGrupo['I']!;
    final j = tabelasGrupo['J']!;
    final k = tabelasGrupo['K']!;
    final l = tabelasGrupo['L']!;

    final selecoes16Avos = [
      e.primeiro, // 1E
      terceirosLugares.elementAt(3), // T4

      i.primeiro, // 1I
      terceirosLugares.elementAt(5), // T6

      a.segundo, // 2A
      b.segundo, // 2B

      f.primeiro, // 1F
      c.segundo, // 2C

      k.segundo, // 2K
      l.segundo, // 2L

      h.primeiro, // 1H
      j.segundo, // 2J

      d.primeiro, // 1D
      terceirosLugares.elementAt(2), // T3

      g.primeiro, // 1G
      terceirosLugares.elementAt(4), // T5

      c.primeiro, // 1C
      f.segundo, // 2F

      e.segundo, // 2E
      i.segundo, // 2I

      a.primeiro, // 1A
      terceirosLugares.elementAt(0), // T1

      l.primeiro, // 1L
      terceirosLugares.elementAt(7), // T8

      j.primeiro, // 1J
      h.segundo, // 2H

      d.segundo, // 2D
      g.segundo, // 2G

      b.primeiro, // 1B
      terceirosLugares.elementAt(1), // T2

      k.primeiro, // 1K
      terceirosLugares.elementAt(6), // T7
    ];

    //print(selecoes16Avos);

    return [
      Partida(
        numero: 73,
        dataHora: DateTime.parse('2026-06-28T12:00:00-03:00'),
        local: 'Los Angeles, nos EUA',
        selecao1: DadosSelecaoPartida.fromSelecao(a.segundo),
        selecao2: DadosSelecaoPartida.fromSelecao(b.segundo),
      ),
      Partida(
        numero: 74,
        dataHora: DateTime.parse('2026-06-29T12:00:00-03:00'),
        local: 'Boston, nos EUA',
        selecao1: DadosSelecaoPartida.fromSelecao(e.primeiro),
        selecao2: DadosSelecaoPartida.fromSelecao(
          terceirosLugares.elementAt(3),
        ),
      ),
      Partida(
        numero: 75,
        dataHora: DateTime.parse('2026-06-29T12:00:00-03:00'),
        local: 'Monterrey, no México',
        selecao1: DadosSelecaoPartida.fromSelecao(f.primeiro),
        selecao2: DadosSelecaoPartida.fromSelecao(c.segundo),
      ),
      Partida(
        numero: 76,
        dataHora: DateTime.parse('2026-06-29T12:00:00-03:00'),
        local: 'Houston, nos EUA',
        selecao1: DadosSelecaoPartida.fromSelecao(c.primeiro),
        selecao2: DadosSelecaoPartida.fromSelecao(f.segundo),
      ),
      Partida(
        numero: 77,
        dataHora: DateTime.parse('2026-06-30T12:00:00-03:00'),
        local: 'Nova York/Nova Jersey, nos EUA',
        selecao1: DadosSelecaoPartida.fromSelecao(i.primeiro),
        selecao2: DadosSelecaoPartida.fromSelecao(
          terceirosLugares.elementAt(5),
        ),
      ),
      Partida(
        numero: 78,
        dataHora: DateTime.parse('2026-06-30T12:00:00-03:00'),
        local: 'Dallas, nos EUA',
        selecao1: DadosSelecaoPartida.fromSelecao(e.segundo),
        selecao2: DadosSelecaoPartida.fromSelecao(i.segundo),
      ),
      Partida(
        numero: 79,
        dataHora: DateTime.parse('2026-06-30T12:00:00-03:00'),
        local: 'Cidade do México, no México',
        selecao1: DadosSelecaoPartida.fromSelecao(a.primeiro),
        selecao2: DadosSelecaoPartida.fromSelecao(
          terceirosLugares.elementAt(0),
        ),
      ),
      Partida(
        numero: 80,
        dataHora: DateTime.parse('2026-07-01T12:00:00-03:00'),
        local: 'Atlanta, nos EUA',
        selecao1: DadosSelecaoPartida.fromSelecao(l.primeiro),
        selecao2: DadosSelecaoPartida.fromSelecao(
          terceirosLugares.elementAt(7),
        ),
      ),
      Partida(
        numero: 81,
        dataHora: DateTime.parse('2026-07-01T12:00:00-03:00'),
        local: 'Santa Clara, nos EUA',
        selecao1: DadosSelecaoPartida.fromSelecao(d.primeiro),
        selecao2: DadosSelecaoPartida.fromSelecao(
          terceirosLugares.elementAt(2),
        ),
      ),
      Partida(
        numero: 82,
        dataHora: DateTime.parse('2026-07-01T12:00:00-03:00'),
        local: 'Seattle, nos EUA',
        selecao1: DadosSelecaoPartida.fromSelecao(g.primeiro),
        selecao2: DadosSelecaoPartida.fromSelecao(
          terceirosLugares.elementAt(4),
        ),
      ),
      Partida(
        numero: 83,
        dataHora: DateTime.parse('2026-07-02T12:00:00-03:00'),
        local: 'Toronto, no Canadá',
        selecao1: DadosSelecaoPartida.fromSelecao(k.segundo),
        selecao2: DadosSelecaoPartida.fromSelecao(l.segundo),
      ),
      Partida(
        numero: 84,
        dataHora: DateTime.parse('2026-07-02T12:00:00-03:00'),
        local: 'Los Angeles, nos EUA',
        selecao1: DadosSelecaoPartida.fromSelecao(h.primeiro),
        selecao2: DadosSelecaoPartida.fromSelecao(j.segundo),
      ),
      Partida(
        numero: 85,
        dataHora: DateTime.parse('2026-07-02T12:00:00-03:00'),
        local: 'Vancouver, no Canadá',
        selecao1: DadosSelecaoPartida.fromSelecao(b.primeiro),
        selecao2: DadosSelecaoPartida.fromSelecao(
          terceirosLugares.elementAt(1),
        ),
      ),
      Partida(
        numero: 86,
        dataHora: DateTime.parse('2026-07-03T12:00:00-03:00'),
        local: 'Miami, nos EUA',
        selecao1: DadosSelecaoPartida.fromSelecao(j.primeiro),
        selecao2: DadosSelecaoPartida.fromSelecao(h.segundo),
      ),
      Partida(
        numero: 87,
        dataHora: DateTime.parse('2026-07-03T12:00:00-03:00'),
        local: 'Kansas City, nos EUA',
        selecao1: DadosSelecaoPartida.fromSelecao(k.primeiro),
        selecao2: DadosSelecaoPartida.fromSelecao(
          terceirosLugares.elementAt(6),
        ),
      ),
      Partida(
        numero: 88,
        dataHora: DateTime.parse('2026-07-03T12:00:00-03:00'),
        local: 'Dallas, nos EUA',
        selecao1: DadosSelecaoPartida.fromSelecao(d.segundo),
        selecao2: DadosSelecaoPartida.fromSelecao(g.segundo),
      ),
    ];
  }

  Future<List<SelecaoTabelaGrupo>> getListaTerceiros(
    TabelaGrupo tabelaTerceiroLugar,
  ) async {
    final mapGrupoSelecao = gerarMapGrupoSelecao(tabelaTerceiroLugar);
    final chave = gerarChaveTerceirosPossiveis(mapGrupoSelecao);
    final ordemTerceiros = await combinacoesRepository.getCombinacao(chave);
    return [for (final letra in ordemTerceiros) mapGrupoSelecao[letra]!];
  }

  Map<String, SelecaoTabelaGrupo> gerarMapGrupoSelecao(
    TabelaGrupo tabelaTerceiroLugar,
  ) {
    final mapGrupoSelecao = <String, SelecaoTabelaGrupo>{};

    for (final selecao in tabelaTerceiroLugar.oitoMelhores) {
      final letraGrupo = getGrupoFrom(selecao);
      mapGrupoSelecao[letraGrupo] = selecao;
    }
    return mapGrupoSelecao;
  }

  String getGrupoFrom(SelecaoTabelaGrupo selecao) {
    for (final grupo in grupos.entries) {
      for (final trigrama in grupo.value) {
        if (trigrama == selecao.trigrama) {
          return grupo.key;
        }
      }
    }

    throw Exception('Grupo não encontrado');
  }

  String gerarChaveTerceirosPossiveis(
    Map<String, SelecaoTabelaGrupo> mapGrupoSelecao,
  ) {
    final letrasGrupoTerceiro = mapGrupoSelecao.keys.toList();
    letrasGrupoTerceiro.sort();
    return letrasGrupoTerceiro.reduce((s1, s2) => s1 + s2);
  }
}
