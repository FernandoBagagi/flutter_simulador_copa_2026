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

  final CombinacoesMelhoresTerceirosRepository combinacoesMelhoresTerceirosRepository;

  EliminatoriasService(this.combinacoesMelhoresTerceirosRepository);

  List<Partida> gerarPartidas16Avos(List<Partida> partidasGrupos) {
    final selecoesTabela = <String, SelecaoTabelaGrupo>{};

    for (Partida partida in partidasGrupos) {
      final selecao1 = selecoesTabela.putIfAbsent(
        partida.selecao1.trigrama,
        () => SelecaoTabelaGrupo(partida.selecao1.trigrama),
      );

      final selecao2 = selecoesTabela.putIfAbsent(
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

    tabelasGrupo.values.forEach(print);

    final terceirosLugares = getListaTerceiros(tabelaTerceiroLugar);

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

    final trigramas16Avos = [
      e.primeiro, // 1E
      terceirosLugares.elementAt(0), // T1
      i.primeiro, // 1I
      terceirosLugares.elementAt(1), // T2
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
      terceirosLugares.elementAt(3), // T4
      c.primeiro, // 1C
      f.segundo, // 2F
      e.segundo, // 2E
      i.segundo, // 2I
      a.primeiro, // 1A
      terceirosLugares.elementAt(4), // T5
      l.primeiro, // 1L
      terceirosLugares.elementAt(5), // T6
      j.primeiro, // 1J
      h.segundo, // 2H
      d.segundo, // 2D
      g.segundo, // 2G
      b.primeiro, // 1B
      terceirosLugares.elementAt(6), // T7
      k.primeiro, // 1K
      terceirosLugares.elementAt(7), // T8
    ];

    return [];
  }

  List<SelecaoTabelaGrupo> getListaTerceiros(TabelaGrupo tabelaTerceiroLugar) {
    final mapGrupoSelecao = gerarMapGrupoSelecao(tabelaTerceiroLugar);
    final chave = gerarChaveTerceirosPossiveis(mapGrupoSelecao);
    return getListaFromCombinacao(mapGrupoSelecao, chave);
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

  List<SelecaoTabelaGrupo> getListaFromCombinacao(
    Map<String, SelecaoTabelaGrupo> map,
    String chave,
  ) {
    return [];
  }

  

}
