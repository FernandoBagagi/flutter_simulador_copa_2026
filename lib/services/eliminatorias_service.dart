import 'package:flutter_simulador_copa_2026/models/partida.dart';
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
    switch (chave) {
      // Veio da linha: 1,3E,3J,3I,3F,3H,3G,3L,3K,EFGHIJKL
      case 'EFGHIJKL':
        return [
          map['E']!,
          map['J']!,
          map['I']!,
          map['F']!,
          map['H']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 2,3H,3G,3I,3D,3J,3F,3L,3K,DFGHIJKL
      case 'DFGHIJKL':
        return [
          map['H']!,
          map['G']!,
          map['I']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 3,3E,3J,3I,3D,3H,3G,3L,3K,DEGHIJKL
      case 'DEGHIJKL':
        return [
          map['E']!,
          map['J']!,
          map['I']!,
          map['D']!,
          map['H']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 4,3E,3J,3I,3D,3H,3F,3L,3K,DEFHIJKL
      case 'DEFHIJKL':
        return [
          map['E']!,
          map['J']!,
          map['I']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 5,3E,3G,3I,3D,3J,3F,3L,3K,DEFGIJKL
      case 'DEFGIJKL':
        return [
          map['E']!,
          map['G']!,
          map['I']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 6,3E,3G,3J,3D,3H,3F,3L,3K,DEFGHJKL
      case 'DEFGHJKL':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 7,3E,3G,3I,3D,3H,3F,3L,3K,DEFGHIKL
      case 'DEFGHIKL':
        return [
          map['E']!,
          map['G']!,
          map['I']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 8,3E,3G,3J,3D,3H,3F,3L,3I,DEFGHIJL
      case 'DEFGHIJL':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 9,3E,3G,3J,3D,3H,3F,3I,3K,DEFGHIJK
      case 'DEFGHIJK':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 10,3H,3G,3I,3C,3J,3F,3L,3K,CFGHIJKL
      case 'CFGHIJKL':
        return [
          map['H']!,
          map['G']!,
          map['I']!,
          map['C']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 11,3E,3J,3I,3C,3H,3G,3L,3K,CEGHIJKL
      case 'CEGHIJKL':
        return [
          map['E']!,
          map['J']!,
          map['I']!,
          map['C']!,
          map['H']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 12,3E,3J,3I,3C,3H,3F,3L,3K,CEFHIJKL
      case 'CEFHIJKL':
        return [
          map['E']!,
          map['J']!,
          map['I']!,
          map['C']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 13,3E,3G,3I,3C,3J,3F,3L,3K,CEFGIJKL
      case 'CEFGIJKL':
        return [
          map['E']!,
          map['G']!,
          map['I']!,
          map['C']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 14,3E,3G,3J,3C,3H,3F,3L,3K,CEFGHJKL
      case 'CEFGHJKL':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 15,3E,3G,3I,3C,3H,3F,3L,3K,CEFGHIKL
      case 'CEFGHIKL':
        return [
          map['E']!,
          map['G']!,
          map['I']!,
          map['C']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 16,3E,3G,3J,3C,3H,3F,3L,3I,CEFGHIJL
      case 'CEFGHIJL':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 17,3E,3G,3J,3C,3H,3F,3I,3K,CEFGHIJK
      case 'CEFGHIJK':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['H']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 18,3H,3G,3I,3C,3J,3D,3L,3K,CDGHIJKL
      case 'CDGHIJKL':
        return [
          map['H']!,
          map['G']!,
          map['I']!,
          map['C']!,
          map['J']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 19,3C,3J,3I,3D,3H,3F,3L,3K,CDFHIJKL
      case 'CDFHIJKL':
        return [
          map['C']!,
          map['J']!,
          map['I']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 20,3C,3G,3I,3D,3J,3F,3L,3K,CDFGIJKL
      case 'CDFGIJKL':
        return [
          map['C']!,
          map['G']!,
          map['I']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 21,3C,3G,3J,3D,3H,3F,3L,3K,CDFGHJKL
      case 'CDFGHJKL':
        return [
          map['C']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 22,3C,3G,3I,3D,3H,3F,3L,3K,CDFGHIKL
      case 'CDFGHIKL':
        return [
          map['C']!,
          map['G']!,
          map['I']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 23,3C,3G,3J,3D,3H,3F,3L,3I,CDFGHIJL
      case 'CDFGHIJL':
        return [
          map['C']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 24,3C,3G,3J,3D,3H,3F,3I,3K,CDFGHIJK
      case 'CDFGHIJK':
        return [
          map['C']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 25,3E,3J,3I,3C,3H,3D,3L,3K,CDEHIJKL
      case 'CDEHIJKL':
        return [
          map['E']!,
          map['J']!,
          map['I']!,
          map['C']!,
          map['H']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 26,3E,3G,3I,3C,3J,3D,3L,3K,CDEGIJKL
      case 'CDEGIJKL':
        return [
          map['E']!,
          map['G']!,
          map['I']!,
          map['C']!,
          map['J']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 27,3E,3G,3J,3C,3H,3D,3L,3K,CDEGHJKL
      case 'CDEGHJKL':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['H']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 28,3E,3G,3I,3C,3H,3D,3L,3K,CDEGHIKL
      case 'CDEGHIKL':
        return [
          map['E']!,
          map['G']!,
          map['I']!,
          map['C']!,
          map['H']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 29,3E,3G,3J,3C,3H,3D,3L,3I,CDEGHIJL
      case 'CDEGHIJL':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['H']!,
          map['D']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 30,3E,3G,3J,3C,3H,3D,3I,3K,CDEGHIJK
      case 'CDEGHIJK':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['H']!,
          map['D']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 31,3C,3J,3E,3D,3I,3F,3L,3K,CDEFIJKL
      case 'CDEFIJKL':
        return [
          map['C']!,
          map['J']!,
          map['E']!,
          map['D']!,
          map['I']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 32,3C,3J,3E,3D,3H,3F,3L,3K,CDEFHJKL
      case 'CDEFHJKL':
        return [
          map['C']!,
          map['J']!,
          map['E']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 33,3C,3E,3I,3D,3H,3F,3L,3K,CDEFHIKL
      case 'CDEFHIKL':
        return [
          map['C']!,
          map['E']!,
          map['I']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 34,3C,3J,3E,3D,3H,3F,3L,3I,CDEFHIJL
      case 'CDEFHIJL':
        return [
          map['C']!,
          map['J']!,
          map['E']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 35,3C,3J,3E,3D,3H,3F,3I,3K,CDEFHIJK
      case 'CDEFHIJK':
        return [
          map['C']!,
          map['J']!,
          map['E']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 36,3C,3G,3E,3D,3J,3F,3L,3K,CDEFGJKL
      case 'CDEFGJKL':
        return [
          map['C']!,
          map['G']!,
          map['E']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 37,3C,3G,3E,3D,3I,3F,3L,3K,CDEFGIKL
      case 'CDEFGIKL':
        return [
          map['C']!,
          map['G']!,
          map['E']!,
          map['D']!,
          map['I']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 38,3C,3G,3E,3D,3J,3F,3L,3I,CDEFGIJL
      case 'CDEFGIJL':
        return [
          map['C']!,
          map['G']!,
          map['E']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 39,3C,3G,3E,3D,3J,3F,3I,3K,CDEFGIJK
      case 'CDEFGIJK':
        return [
          map['C']!,
          map['G']!,
          map['E']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 40,3C,3G,3E,3D,3H,3F,3L,3K,CDEFGHKL
      case 'CDEFGHKL':
        return [
          map['C']!,
          map['G']!,
          map['E']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 41,3C,3G,3J,3D,3H,3F,3L,3E,CDEFGHJL
      case 'CDEFGHJL':
        return [
          map['C']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 42,3C,3G,3J,3D,3H,3F,3E,3K,CDEFGHJK
      case 'CDEFGHJK':
        return [
          map['C']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 43,3C,3G,3E,3D,3H,3F,3L,3I,CDEFGHIL
      case 'CDEFGHIL':
        return [
          map['C']!,
          map['G']!,
          map['E']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 44,3C,3G,3E,3D,3H,3F,3I,3K,CDEFGHIK
      case 'CDEFGHIK':
        return [
          map['C']!,
          map['G']!,
          map['E']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 45,3C,3G,3J,3D,3H,3F,3E,3I,CDEFGHIJ
      case 'CDEFGHIJ':
        return [
          map['C']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 46,3H,3J,3B,3F,3I,3G,3L,3K,BFGHIJKL
      case 'BFGHIJKL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['I']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 47,3E,3J,3I,3B,3H,3G,3L,3K,BEGHIJKL
      case 'BEGHIJKL':
        return [
          map['E']!,
          map['J']!,
          map['I']!,
          map['B']!,
          map['H']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 48,3E,3J,3B,3F,3I,3H,3L,3K,BEFHIJKL
      case 'BEFHIJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['I']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 49,3E,3J,3B,3F,3I,3G,3L,3K,BEFGIJKL
      case 'BEFGIJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['I']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 50,3E,3J,3B,3F,3H,3G,3L,3K,BEFGHJKL
      case 'BEFGHJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['H']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 51,3E,3G,3B,3F,3I,3H,3L,3K,BEFGHIKL
      case 'BEFGHIKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['F']!,
          map['I']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 52,3E,3J,3B,3F,3H,3G,3L,3I,BEFGHIJL
      case 'BEFGHIJL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['H']!,
          map['G']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 53,3E,3J,3B,3F,3H,3G,3I,3K,BEFGHIJK
      case 'BEFGHIJK':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['H']!,
          map['G']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 54,3H,3J,3B,3D,3I,3G,3L,3K,BDGHIJKL
      case 'BDGHIJKL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['I']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 55,3H,3J,3B,3D,3I,3F,3L,3K,BDFHIJKL
      case 'BDFHIJKL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['I']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 56,3I,3G,3B,3D,3J,3F,3L,3K,BDFGIJKL
      case 'BDFGIJKL':
        return [
          map['I']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 57,3H,3G,3B,3D,3J,3F,3L,3K,BDFGHJKL
      case 'BDFGHJKL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 58,3H,3G,3B,3D,3I,3F,3L,3K,BDFGHIKL
      case 'BDFGHIKL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['I']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 59,3H,3G,3B,3D,3J,3F,3L,3I,BDFGHIJL
      case 'BDFGHIJL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 60,3H,3G,3B,3D,3J,3F,3I,3K,BDFGHIJK
      case 'BDFGHIJK':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 61,3E,3J,3B,3D,3I,3H,3L,3K,BDEHIJKL
      case 'BDEHIJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['I']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 62,3E,3J,3B,3D,3I,3G,3L,3K,BDEGIJKL
      case 'BDEGIJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['I']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 63,3E,3J,3B,3D,3H,3G,3L,3K,BDEGHJKL
      case 'BDEGHJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 64,3E,3G,3B,3D,3I,3H,3L,3K,BDEGHIKL
      case 'BDEGHIKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['I']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 65,3E,3J,3B,3D,3H,3G,3L,3I,BDEGHIJL
      case 'BDEGHIJL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['G']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 66,3E,3J,3B,3D,3H,3G,3I,3K,BDEGHIJK
      case 'BDEGHIJK':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['G']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 67,3E,3J,3B,3D,3I,3F,3L,3K,BDEFIJKL
      case 'BDEFIJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['I']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 68,3E,3J,3B,3D,3H,3F,3L,3K,BDEFHJKL
      case 'BDEFHJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 69,3E,3I,3B,3D,3H,3F,3L,3K,BDEFHIKL
      case 'BDEFHIKL':
        return [
          map['E']!,
          map['I']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 70,3E,3J,3B,3D,3H,3F,3L,3I,BDEFHIJL
      case 'BDEFHIJL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 71,3E,3J,3B,3D,3H,3F,3I,3K,BDEFHIJK
      case 'BDEFHIJK':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 72,3E,3G,3B,3D,3J,3F,3L,3K,BDEFGJKL
      case 'BDEFGJKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 73,3E,3G,3B,3D,3I,3F,3L,3K,BDEFGIKL
      case 'BDEFGIKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['I']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 74,3E,3G,3B,3D,3J,3F,3L,3I,BDEFGIJL
      case 'BDEFGIJL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 75,3E,3G,3B,3D,3J,3F,3I,3K,BDEFGIJK
      case 'BDEFGIJK':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 76,3E,3G,3B,3D,3H,3F,3L,3K,BDEFGHKL
      case 'BDEFGHKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 77,3H,3G,3B,3D,3J,3F,3L,3E,BDEFGHJL
      case 'BDEFGHJL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 78,3H,3G,3B,3D,3J,3F,3E,3K,BDEFGHJK
      case 'BDEFGHJK':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 79,3E,3G,3B,3D,3H,3F,3L,3I,BDEFGHIL
      case 'BDEFGHIL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 80,3E,3G,3B,3D,3H,3F,3I,3K,BDEFGHIK
      case 'BDEFGHIK':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 81,3H,3G,3B,3D,3J,3F,3E,3I,BDEFGHIJ
      case 'BDEFGHIJ':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 82,3H,3J,3B,3C,3I,3G,3L,3K,BCGHIJKL
      case 'BCGHIJKL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['I']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 83,3H,3J,3B,3C,3I,3F,3L,3K,BCFHIJKL
      case 'BCFHIJKL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['I']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 84,3I,3G,3B,3C,3J,3F,3L,3K,BCFGIJKL
      case 'BCFGIJKL':
        return [
          map['I']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 85,3H,3G,3B,3C,3J,3F,3L,3K,BCFGHJKL
      case 'BCFGHJKL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 86,3H,3G,3B,3C,3I,3F,3L,3K,BCFGHIKL
      case 'BCFGHIKL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['I']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 87,3H,3G,3B,3C,3J,3F,3L,3I,BCFGHIJL
      case 'BCFGHIJL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 88,3H,3G,3B,3C,3J,3F,3I,3K,BCFGHIJK
      case 'BCFGHIJK':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 89,3E,3J,3B,3C,3I,3H,3L,3K,BCEHIJKL
      case 'BCEHIJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['I']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 90,3E,3J,3B,3C,3I,3G,3L,3K,BCEGIJKL
      case 'BCEGIJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['I']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 91,3E,3J,3B,3C,3H,3G,3L,3K,BCEGHJKL
      case 'BCEGHJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['H']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 92,3E,3G,3B,3C,3I,3H,3L,3K,BCEGHIKL
      case 'BCEGHIKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['I']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 93,3E,3J,3B,3C,3H,3G,3L,3I,BCEGHIJL
      case 'BCEGHIJL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['H']!,
          map['G']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 94,3E,3J,3B,3C,3H,3G,3I,3K,BCEGHIJK
      case 'BCEGHIJK':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['H']!,
          map['G']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 95,3E,3J,3B,3C,3I,3F,3L,3K,BCEFIJKL
      case 'BCEFIJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['I']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 96,3E,3J,3B,3C,3H,3F,3L,3K,BCEFHJKL
      case 'BCEFHJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 97,3E,3I,3B,3C,3H,3F,3L,3K,BCEFHIKL
      case 'BCEFHIKL':
        return [
          map['E']!,
          map['I']!,
          map['B']!,
          map['C']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 98,3E,3J,3B,3C,3H,3F,3L,3I,BCEFHIJL
      case 'BCEFHIJL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 99,3E,3J,3B,3C,3H,3F,3I,3K,BCEFHIJK
      case 'BCEFHIJK':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['H']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 100,3E,3G,3B,3C,3J,3F,3L,3K,BCEFGJKL
      case 'BCEFGJKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 101,3E,3G,3B,3C,3I,3F,3L,3K,BCEFGIKL
      case 'BCEFGIKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['I']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 102,3E,3G,3B,3C,3J,3F,3L,3I,BCEFGIJL
      case 'BCEFGIJL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 103,3E,3G,3B,3C,3J,3F,3I,3K,BCEFGIJK
      case 'BCEFGIJK':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 104,3E,3G,3B,3C,3H,3F,3L,3K,BCEFGHKL
      case 'BCEFGHKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 105,3H,3G,3B,3C,3J,3F,3L,3E,BCEFGHJL
      case 'BCEFGHJL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 106,3H,3G,3B,3C,3J,3F,3E,3K,BCEFGHJK
      case 'BCEFGHJK':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['F']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 107,3E,3G,3B,3C,3H,3F,3L,3I,BCEFGHIL
      case 'BCEFGHIL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 108,3E,3G,3B,3C,3H,3F,3I,3K,BCEFGHIK
      case 'BCEFGHIK':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['H']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 109,3H,3G,3B,3C,3J,3F,3E,3I,BCEFGHIJ
      case 'BCEFGHIJ':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['F']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 110,3H,3J,3B,3C,3I,3D,3L,3K,BCDHIJKL
      case 'BCDHIJKL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['I']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 111,3I,3G,3B,3C,3J,3D,3L,3K,BCDGIJKL
      case 'BCDGIJKL':
        return [
          map['I']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 112,3H,3G,3B,3C,3J,3D,3L,3K,BCDGHJKL
      case 'BCDGHJKL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 113,3H,3G,3B,3C,3I,3D,3L,3K,BCDGHIKL
      case 'BCDGHIKL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['I']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 114,3H,3G,3B,3C,3J,3D,3L,3I,BCDGHIJL
      case 'BCDGHIJL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['D']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 115,3H,3G,3B,3C,3J,3D,3I,3K,BCDGHIJK
      case 'BCDGHIJK':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['D']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 116,3C,3J,3B,3D,3I,3F,3L,3K,BCDFIJKL
      case 'BCDFIJKL':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['I']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 117,3C,3J,3B,3D,3H,3F,3L,3K,BCDFHJKL
      case 'BCDFHJKL':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 118,3C,3I,3B,3D,3H,3F,3L,3K,BCDFHIKL
      case 'BCDFHIKL':
        return [
          map['C']!,
          map['I']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 119,3C,3J,3B,3D,3H,3F,3L,3I,BCDFHIJL
      case 'BCDFHIJL':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 120,3C,3J,3B,3D,3H,3F,3I,3K,BCDFHIJK
      case 'BCDFHIJK':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 121,3C,3G,3B,3D,3J,3F,3L,3K,BCDFGJKL
      case 'BCDFGJKL':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 122,3C,3G,3B,3D,3I,3F,3L,3K,BCDFGIKL
      case 'BCDFGIKL':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['I']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 123,3C,3G,3B,3D,3J,3F,3L,3I,BCDFGIJL
      case 'BCDFGIJL':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 124,3C,3G,3B,3D,3J,3F,3I,3K,BCDFGIJK
      case 'BCDFGIJK':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 125,3C,3G,3B,3D,3H,3F,3L,3K,BCDFGHKL
      case 'BCDFGHKL':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 126,3C,3G,3B,3D,3H,3F,3L,3J,BCDFGHJL
      case 'BCDFGHJL':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['J']!,
        ];
      // Veio da linha: 127,3H,3G,3B,3C,3J,3F,3D,3K,BCDFGHJK
      case 'BCDFGHJK':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['F']!,
          map['D']!,
          map['K']!,
        ];
      // Veio da linha: 128,3C,3G,3B,3D,3H,3F,3L,3I,BCDFGHIL
      case 'BCDFGHIL':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 129,3C,3G,3B,3D,3H,3F,3I,3K,BCDFGHIK
      case 'BCDFGHIK':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 130,3H,3G,3B,3C,3J,3F,3D,3I,BCDFGHIJ
      case 'BCDFGHIJ':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['F']!,
          map['D']!,
          map['I']!,
        ];
      // Veio da linha: 131,3E,3J,3B,3C,3I,3D,3L,3K,BCDEIJKL
      case 'BCDEIJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['I']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 132,3E,3J,3B,3C,3H,3D,3L,3K,BCDEHJKL
      case 'BCDEHJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['H']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 133,3E,3I,3B,3C,3H,3D,3L,3K,BCDEHIKL
      case 'BCDEHIKL':
        return [
          map['E']!,
          map['I']!,
          map['B']!,
          map['C']!,
          map['H']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 134,3E,3J,3B,3C,3H,3D,3L,3I,BCDEHIJL
      case 'BCDEHIJL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['H']!,
          map['D']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 135,3E,3J,3B,3C,3H,3D,3I,3K,BCDEHIJK
      case 'BCDEHIJK':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['H']!,
          map['D']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 136,3E,3G,3B,3C,3J,3D,3L,3K,BCDEGJKL
      case 'BCDEGJKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 137,3E,3G,3B,3C,3I,3D,3L,3K,BCDEGIKL
      case 'BCDEGIKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['I']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 138,3E,3G,3B,3C,3J,3D,3L,3I,BCDEGIJL
      case 'BCDEGIJL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['D']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 139,3E,3G,3B,3C,3J,3D,3I,3K,BCDEGIJK
      case 'BCDEGIJK':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['D']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 140,3E,3G,3B,3C,3H,3D,3L,3K,BCDEGHKL
      case 'BCDEGHKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['H']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 141,3H,3G,3B,3C,3J,3D,3L,3E,BCDEGHJL
      case 'BCDEGHJL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['D']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 142,3H,3G,3B,3C,3J,3D,3E,3K,BCDEGHJK
      case 'BCDEGHJK':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['D']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 143,3E,3G,3B,3C,3H,3D,3L,3I,BCDEGHIL
      case 'BCDEGHIL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['H']!,
          map['D']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 144,3E,3G,3B,3C,3H,3D,3I,3K,BCDEGHIK
      case 'BCDEGHIK':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['H']!,
          map['D']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 145,3H,3G,3B,3C,3J,3D,3E,3I,BCDEGHIJ
      case 'BCDEGHIJ':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['D']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 146,3C,3J,3B,3D,3E,3F,3L,3K,BCDEFJKL
      case 'BCDEFJKL':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['E']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 147,3C,3E,3B,3D,3I,3F,3L,3K,BCDEFIKL
      case 'BCDEFIKL':
        return [
          map['C']!,
          map['E']!,
          map['B']!,
          map['D']!,
          map['I']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 148,3C,3J,3B,3D,3E,3F,3L,3I,BCDEFIJL
      case 'BCDEFIJL':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['E']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 149,3C,3J,3B,3D,3E,3F,3I,3K,BCDEFIJK
      case 'BCDEFIJK':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['E']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 150,3C,3E,3B,3D,3H,3F,3L,3K,BCDEFHKL
      case 'BCDEFHKL':
        return [
          map['C']!,
          map['E']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 151,3C,3J,3B,3D,3H,3F,3L,3E,BCDEFHJL
      case 'BCDEFHJL':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 152,3C,3J,3B,3D,3H,3F,3E,3K,BCDEFHJK
      case 'BCDEFHJK':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 153,3C,3E,3B,3D,3H,3F,3L,3I,BCDEFHIL
      case 'BCDEFHIL':
        return [
          map['C']!,
          map['E']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 154,3C,3E,3B,3D,3H,3F,3I,3K,BCDEFHIK
      case 'BCDEFHIK':
        return [
          map['C']!,
          map['E']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 155,3C,3J,3B,3D,3H,3F,3E,3I,BCDEFHIJ
      case 'BCDEFHIJ':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 156,3C,3G,3B,3D,3E,3F,3L,3K,BCDEFGKL
      case 'BCDEFGKL':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['E']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 157,3C,3G,3B,3D,3J,3F,3L,3E,BCDEFGJL
      case 'BCDEFGJL':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 158,3C,3G,3B,3D,3J,3F,3E,3K,BCDEFGJK
      case 'BCDEFGJK':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 159,3C,3G,3B,3D,3E,3F,3L,3I,BCDEFGIL
      case 'BCDEFGIL':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['E']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 160,3C,3G,3B,3D,3E,3F,3I,3K,BCDEFGIK
      case 'BCDEFGIK':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['E']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 161,3C,3G,3B,3D,3J,3F,3E,3I,BCDEFGIJ
      case 'BCDEFGIJ':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['J']!,
          map['F']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 162,3C,3G,3B,3D,3H,3F,3L,3E,BCDEFGHL
      case 'BCDEFGHL':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 163,3C,3G,3B,3D,3H,3F,3E,3K,BCDEFGHK
      case 'BCDEFGHK':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 164,3H,3G,3B,3C,3J,3F,3D,3E,BCDEFGHJ
      case 'BCDEFGHJ':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['J']!,
          map['F']!,
          map['D']!,
          map['E']!,
        ];
      // Veio da linha: 165,3C,3G,3B,3D,3H,3F,3E,3I,BCDEFGHI
      case 'BCDEFGHI':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['H']!,
          map['F']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 166,3H,3J,3I,3F,3A,3G,3L,3K,AFGHIJKL
      case 'AFGHIJKL':
        return [
          map['H']!,
          map['J']!,
          map['I']!,
          map['F']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 167,3E,3J,3I,3A,3H,3G,3L,3K,AEGHIJKL
      case 'AEGHIJKL':
        return [
          map['E']!,
          map['J']!,
          map['I']!,
          map['A']!,
          map['H']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 168,3E,3J,3I,3F,3A,3H,3L,3K,AEFHIJKL
      case 'AEFHIJKL':
        return [
          map['E']!,
          map['J']!,
          map['I']!,
          map['F']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 169,3E,3J,3I,3F,3A,3G,3L,3K,AEFGIJKL
      case 'AEFGIJKL':
        return [
          map['E']!,
          map['J']!,
          map['I']!,
          map['F']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 170,3E,3G,3J,3F,3A,3H,3L,3K,AEFGHJKL
      case 'AEFGHJKL':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['F']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 171,3E,3G,3I,3F,3A,3H,3L,3K,AEFGHIKL
      case 'AEFGHIKL':
        return [
          map['E']!,
          map['G']!,
          map['I']!,
          map['F']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 172,3E,3G,3J,3F,3A,3H,3L,3I,AEFGHIJL
      case 'AEFGHIJL':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['F']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 173,3E,3G,3J,3F,3A,3H,3I,3K,AEFGHIJK
      case 'AEFGHIJK':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['F']!,
          map['A']!,
          map['H']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 174,3H,3J,3I,3D,3A,3G,3L,3K,ADGHIJKL
      case 'ADGHIJKL':
        return [
          map['H']!,
          map['J']!,
          map['I']!,
          map['D']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 175,3H,3J,3I,3D,3A,3F,3L,3K,ADFHIJKL
      case 'ADFHIJKL':
        return [
          map['H']!,
          map['J']!,
          map['I']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 176,3I,3G,3J,3D,3A,3F,3L,3K,ADFGIJKL
      case 'ADFGIJKL':
        return [
          map['I']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 177,3H,3G,3J,3D,3A,3F,3L,3K,ADFGHJKL
      case 'ADFGHJKL':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 178,3H,3G,3I,3D,3A,3F,3L,3K,ADFGHIKL
      case 'ADFGHIKL':
        return [
          map['H']!,
          map['G']!,
          map['I']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 179,3H,3G,3J,3D,3A,3F,3L,3I,ADFGHIJL
      case 'ADFGHIJL':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 180,3H,3G,3J,3D,3A,3F,3I,3K,ADFGHIJK
      case 'ADFGHIJK':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 181,3E,3J,3I,3D,3A,3H,3L,3K,ADEHIJKL
      case 'ADEHIJKL':
        return [
          map['E']!,
          map['J']!,
          map['I']!,
          map['D']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 182,3E,3J,3I,3D,3A,3G,3L,3K,ADEGIJKL
      case 'ADEGIJKL':
        return [
          map['E']!,
          map['J']!,
          map['I']!,
          map['D']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 183,3E,3G,3J,3D,3A,3H,3L,3K,ADEGHJKL
      case 'ADEGHJKL':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 184,3E,3G,3I,3D,3A,3H,3L,3K,ADEGHIKL
      case 'ADEGHIKL':
        return [
          map['E']!,
          map['G']!,
          map['I']!,
          map['D']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 185,3E,3G,3J,3D,3A,3H,3L,3I,ADEGHIJL
      case 'ADEGHIJL':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 186,3E,3G,3J,3D,3A,3H,3I,3K,ADEGHIJK
      case 'ADEGHIJK':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['H']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 187,3E,3J,3I,3D,3A,3F,3L,3K,ADEFIJKL
      case 'ADEFIJKL':
        return [
          map['E']!,
          map['J']!,
          map['I']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 188,3H,3J,3E,3D,3A,3F,3L,3K,ADEFHJKL
      case 'ADEFHJKL':
        return [
          map['H']!,
          map['J']!,
          map['E']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 189,3H,3E,3I,3D,3A,3F,3L,3K,ADEFHIKL
      case 'ADEFHIKL':
        return [
          map['H']!,
          map['E']!,
          map['I']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 190,3H,3J,3E,3D,3A,3F,3L,3I,ADEFHIJL
      case 'ADEFHIJL':
        return [
          map['H']!,
          map['J']!,
          map['E']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 191,3H,3J,3E,3D,3A,3F,3I,3K,ADEFHIJK
      case 'ADEFHIJK':
        return [
          map['H']!,
          map['J']!,
          map['E']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 192,3E,3G,3J,3D,3A,3F,3L,3K,ADEFGJKL
      case 'ADEFGJKL':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 193,3E,3G,3I,3D,3A,3F,3L,3K,ADEFGIKL
      case 'ADEFGIKL':
        return [
          map['E']!,
          map['G']!,
          map['I']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 194,3E,3G,3J,3D,3A,3F,3L,3I,ADEFGIJL
      case 'ADEFGIJL':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 195,3E,3G,3J,3D,3A,3F,3I,3K,ADEFGIJK
      case 'ADEFGIJK':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 196,3H,3G,3E,3D,3A,3F,3L,3K,ADEFGHKL
      case 'ADEFGHKL':
        return [
          map['H']!,
          map['G']!,
          map['E']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 197,3H,3G,3J,3D,3A,3F,3L,3E,ADEFGHJL
      case 'ADEFGHJL':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 198,3H,3G,3J,3D,3A,3F,3E,3K,ADEFGHJK
      case 'ADEFGHJK':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 199,3H,3G,3E,3D,3A,3F,3L,3I,ADEFGHIL
      case 'ADEFGHIL':
        return [
          map['H']!,
          map['G']!,
          map['E']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 200,3H,3G,3E,3D,3A,3F,3I,3K,ADEFGHIK
      case 'ADEFGHIK':
        return [
          map['H']!,
          map['G']!,
          map['E']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 201,3H,3G,3J,3D,3A,3F,3E,3I,ADEFGHIJ
      case 'ADEFGHIJ':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 202,3H,3J,3I,3C,3A,3G,3L,3K,ACGHIJKL
      case 'ACGHIJKL':
        return [
          map['H']!,
          map['J']!,
          map['I']!,
          map['C']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 203,3H,3J,3I,3C,3A,3F,3L,3K,ACFHIJKL
      case 'ACFHIJKL':
        return [
          map['H']!,
          map['J']!,
          map['I']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 204,3I,3G,3J,3C,3A,3F,3L,3K,ACFGIJKL
      case 'ACFGIJKL':
        return [
          map['I']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 205,3H,3G,3J,3C,3A,3F,3L,3K,ACFGHJKL
      case 'ACFGHJKL':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 206,3H,3G,3I,3C,3A,3F,3L,3K,ACFGHIKL
      case 'ACFGHIKL':
        return [
          map['H']!,
          map['G']!,
          map['I']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 207,3H,3G,3J,3C,3A,3F,3L,3I,ACFGHIJL
      case 'ACFGHIJL':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 208,3H,3G,3J,3C,3A,3F,3I,3K,ACFGHIJK
      case 'ACFGHIJK':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 209,3E,3J,3I,3C,3A,3H,3L,3K,ACEHIJKL
      case 'ACEHIJKL':
        return [
          map['E']!,
          map['J']!,
          map['I']!,
          map['C']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 210,3E,3J,3I,3C,3A,3G,3L,3K,ACEGIJKL
      case 'ACEGIJKL':
        return [
          map['E']!,
          map['J']!,
          map['I']!,
          map['C']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 211,3E,3G,3J,3C,3A,3H,3L,3K,ACEGHJKL
      case 'ACEGHJKL':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 212,3E,3G,3I,3C,3A,3H,3L,3K,ACEGHIKL
      case 'ACEGHIKL':
        return [
          map['E']!,
          map['G']!,
          map['I']!,
          map['C']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 213,3E,3G,3J,3C,3A,3H,3L,3I,ACEGHIJL
      case 'ACEGHIJL':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 214,3E,3G,3J,3C,3A,3H,3I,3K,ACEGHIJK
      case 'ACEGHIJK':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['H']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 215,3E,3J,3I,3C,3A,3F,3L,3K,ACEFIJKL
      case 'ACEFIJKL':
        return [
          map['E']!,
          map['J']!,
          map['I']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 216,3H,3J,3E,3C,3A,3F,3L,3K,ACEFHJKL
      case 'ACEFHJKL':
        return [
          map['H']!,
          map['J']!,
          map['E']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 217,3H,3E,3I,3C,3A,3F,3L,3K,ACEFHIKL
      case 'ACEFHIKL':
        return [
          map['H']!,
          map['E']!,
          map['I']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 218,3H,3J,3E,3C,3A,3F,3L,3I,ACEFHIJL
      case 'ACEFHIJL':
        return [
          map['H']!,
          map['J']!,
          map['E']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 219,3H,3J,3E,3C,3A,3F,3I,3K,ACEFHIJK
      case 'ACEFHIJK':
        return [
          map['H']!,
          map['J']!,
          map['E']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 220,3E,3G,3J,3C,3A,3F,3L,3K,ACEFGJKL
      case 'ACEFGJKL':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 221,3E,3G,3I,3C,3A,3F,3L,3K,ACEFGIKL
      case 'ACEFGIKL':
        return [
          map['E']!,
          map['G']!,
          map['I']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 222,3E,3G,3J,3C,3A,3F,3L,3I,ACEFGIJL
      case 'ACEFGIJL':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 223,3E,3G,3J,3C,3A,3F,3I,3K,ACEFGIJK
      case 'ACEFGIJK':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 224,3H,3G,3E,3C,3A,3F,3L,3K,ACEFGHKL
      case 'ACEFGHKL':
        return [
          map['H']!,
          map['G']!,
          map['E']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 225,3H,3G,3J,3C,3A,3F,3L,3E,ACEFGHJL
      case 'ACEFGHJL':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 226,3H,3G,3J,3C,3A,3F,3E,3K,ACEFGHJK
      case 'ACEFGHJK':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 227,3H,3G,3E,3C,3A,3F,3L,3I,ACEFGHIL
      case 'ACEFGHIL':
        return [
          map['H']!,
          map['G']!,
          map['E']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 228,3H,3G,3E,3C,3A,3F,3I,3K,ACEFGHIK
      case 'ACEFGHIK':
        return [
          map['H']!,
          map['G']!,
          map['E']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 229,3H,3G,3J,3C,3A,3F,3E,3I,ACEFGHIJ
      case 'ACEFGHIJ':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 230,3H,3J,3I,3C,3A,3D,3L,3K,ACDHIJKL
      case 'ACDHIJKL':
        return [
          map['H']!,
          map['J']!,
          map['I']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 231,3I,3G,3J,3C,3A,3D,3L,3K,ACDGIJKL
      case 'ACDGIJKL':
        return [
          map['I']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 232,3H,3G,3J,3C,3A,3D,3L,3K,ACDGHJKL
      case 'ACDGHJKL':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 233,3H,3G,3I,3C,3A,3D,3L,3K,ACDGHIKL
      case 'ACDGHIKL':
        return [
          map['H']!,
          map['G']!,
          map['I']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 234,3H,3G,3J,3C,3A,3D,3L,3I,ACDGHIJL
      case 'ACDGHIJL':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 235,3H,3G,3J,3C,3A,3D,3I,3K,ACDGHIJK
      case 'ACDGHIJK':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 236,3C,3J,3I,3D,3A,3F,3L,3K,ACDFIJKL
      case 'ACDFIJKL':
        return [
          map['C']!,
          map['J']!,
          map['I']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 237,3H,3J,3F,3C,3A,3D,3L,3K,ACDFHJKL
      case 'ACDFHJKL':
        return [
          map['H']!,
          map['J']!,
          map['F']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 238,3H,3F,3I,3C,3A,3D,3L,3K,ACDFHIKL
      case 'ACDFHIKL':
        return [
          map['H']!,
          map['F']!,
          map['I']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 239,3H,3J,3F,3C,3A,3D,3L,3I,ACDFHIJL
      case 'ACDFHIJL':
        return [
          map['H']!,
          map['J']!,
          map['F']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 240,3H,3J,3F,3C,3A,3D,3I,3K,ACDFHIJK
      case 'ACDFHIJK':
        return [
          map['H']!,
          map['J']!,
          map['F']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 241,3C,3G,3J,3D,3A,3F,3L,3K,ACDFGJKL
      case 'ACDFGJKL':
        return [
          map['C']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 242,3C,3G,3I,3D,3A,3F,3L,3K,ACDFGIKL
      case 'ACDFGIKL':
        return [
          map['C']!,
          map['G']!,
          map['I']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 243,3C,3G,3J,3D,3A,3F,3L,3I,ACDFGIJL
      case 'ACDFGIJL':
        return [
          map['C']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 244,3C,3G,3J,3D,3A,3F,3I,3K,ACDFGIJK
      case 'ACDFGIJK':
        return [
          map['C']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 245,3H,3G,3F,3C,3A,3D,3L,3K,ACDFGHKL
      case 'ACDFGHKL':
        return [
          map['H']!,
          map['G']!,
          map['F']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 246,3C,3G,3J,3D,3A,3F,3L,3H,ACDFGHJL
      case 'ACDFGHJL':
        return [
          map['C']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['H']!,
        ];
      // Veio da linha: 247,3H,3G,3J,3C,3A,3F,3D,3K,ACDFGHJK
      case 'ACDFGHJK':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['D']!,
          map['K']!,
        ];
      // Veio da linha: 248,3H,3G,3F,3C,3A,3D,3L,3I,ACDFGHIL
      case 'ACDFGHIL':
        return [
          map['H']!,
          map['G']!,
          map['F']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 249,3H,3G,3F,3C,3A,3D,3I,3K,ACDFGHIK
      case 'ACDFGHIK':
        return [
          map['H']!,
          map['G']!,
          map['F']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 250,3H,3G,3J,3C,3A,3F,3D,3I,ACDFGHIJ
      case 'ACDFGHIJ':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['D']!,
          map['I']!,
        ];
      // Veio da linha: 251,3E,3J,3I,3C,3A,3D,3L,3K,ACDEIJKL
      case 'ACDEIJKL':
        return [
          map['E']!,
          map['J']!,
          map['I']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 252,3H,3J,3E,3C,3A,3D,3L,3K,ACDEHJKL
      case 'ACDEHJKL':
        return [
          map['H']!,
          map['J']!,
          map['E']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 253,3H,3E,3I,3C,3A,3D,3L,3K,ACDEHIKL
      case 'ACDEHIKL':
        return [
          map['H']!,
          map['E']!,
          map['I']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 254,3H,3J,3E,3C,3A,3D,3L,3I,ACDEHIJL
      case 'ACDEHIJL':
        return [
          map['H']!,
          map['J']!,
          map['E']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 255,3H,3J,3E,3C,3A,3D,3I,3K,ACDEHIJK
      case 'ACDEHIJK':
        return [
          map['H']!,
          map['J']!,
          map['E']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 256,3E,3G,3J,3C,3A,3D,3L,3K,ACDEGJKL
      case 'ACDEGJKL':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 257,3E,3G,3I,3C,3A,3D,3L,3K,ACDEGIKL
      case 'ACDEGIKL':
        return [
          map['E']!,
          map['G']!,
          map['I']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 258,3E,3G,3J,3C,3A,3D,3L,3I,ACDEGIJL
      case 'ACDEGIJL':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 259,3E,3G,3J,3C,3A,3D,3I,3K,ACDEGIJK
      case 'ACDEGIJK':
        return [
          map['E']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 260,3H,3G,3E,3C,3A,3D,3L,3K,ACDEGHKL
      case 'ACDEGHKL':
        return [
          map['H']!,
          map['G']!,
          map['E']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 261,3H,3G,3J,3C,3A,3D,3L,3E,ACDEGHJL
      case 'ACDEGHJL':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 262,3H,3G,3J,3C,3A,3D,3E,3K,ACDEGHJK
      case 'ACDEGHJK':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 263,3H,3G,3E,3C,3A,3D,3L,3I,ACDEGHIL
      case 'ACDEGHIL':
        return [
          map['H']!,
          map['G']!,
          map['E']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 264,3H,3G,3E,3C,3A,3D,3I,3K,ACDEGHIK
      case 'ACDEGHIK':
        return [
          map['H']!,
          map['G']!,
          map['E']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 265,3H,3G,3J,3C,3A,3D,3E,3I,ACDEGHIJ
      case 'ACDEGHIJ':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 266,3C,3J,3E,3D,3A,3F,3L,3K,ACDEFJKL
      case 'ACDEFJKL':
        return [
          map['C']!,
          map['J']!,
          map['E']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 267,3C,3E,3I,3D,3A,3F,3L,3K,ACDEFIKL
      case 'ACDEFIKL':
        return [
          map['C']!,
          map['E']!,
          map['I']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 268,3C,3J,3E,3D,3A,3F,3L,3I,ACDEFIJL
      case 'ACDEFIJL':
        return [
          map['C']!,
          map['J']!,
          map['E']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 269,3C,3J,3E,3D,3A,3F,3I,3K,ACDEFIJK
      case 'ACDEFIJK':
        return [
          map['C']!,
          map['J']!,
          map['E']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 270,3H,3E,3F,3C,3A,3D,3L,3K,ACDEFHKL
      case 'ACDEFHKL':
        return [
          map['H']!,
          map['E']!,
          map['F']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 271,3H,3J,3F,3C,3A,3D,3L,3E,ACDEFHJL
      case 'ACDEFHJL':
        return [
          map['H']!,
          map['J']!,
          map['F']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 272,3H,3J,3E,3C,3A,3F,3D,3K,ACDEFHJK
      case 'ACDEFHJK':
        return [
          map['H']!,
          map['J']!,
          map['E']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['D']!,
          map['K']!,
        ];
      // Veio da linha: 273,3H,3E,3F,3C,3A,3D,3L,3I,ACDEFHIL
      case 'ACDEFHIL':
        return [
          map['H']!,
          map['E']!,
          map['F']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 274,3H,3E,3F,3C,3A,3D,3I,3K,ACDEFHIK
      case 'ACDEFHIK':
        return [
          map['H']!,
          map['E']!,
          map['F']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 275,3H,3J,3E,3C,3A,3F,3D,3I,ACDEFHIJ
      case 'ACDEFHIJ':
        return [
          map['H']!,
          map['J']!,
          map['E']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['D']!,
          map['I']!,
        ];
      // Veio da linha: 276,3C,3G,3E,3D,3A,3F,3L,3K,ACDEFGKL
      case 'ACDEFGKL':
        return [
          map['C']!,
          map['G']!,
          map['E']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 277,3C,3G,3J,3D,3A,3F,3L,3E,ACDEFGJL
      case 'ACDEFGJL':
        return [
          map['C']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 278,3C,3G,3J,3D,3A,3F,3E,3K,ACDEFGJK
      case 'ACDEFGJK':
        return [
          map['C']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 279,3C,3G,3E,3D,3A,3F,3L,3I,ACDEFGIL
      case 'ACDEFGIL':
        return [
          map['C']!,
          map['G']!,
          map['E']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 280,3C,3G,3E,3D,3A,3F,3I,3K,ACDEFGIK
      case 'ACDEFGIK':
        return [
          map['C']!,
          map['G']!,
          map['E']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 281,3C,3G,3J,3D,3A,3F,3E,3I,ACDEFGIJ
      case 'ACDEFGIJ':
        return [
          map['C']!,
          map['G']!,
          map['J']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 282,3H,3G,3F,3C,3A,3D,3L,3E,ACDEFGHL
      case 'ACDEFGHL':
        return [
          map['H']!,
          map['G']!,
          map['F']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 283,3H,3G,3E,3C,3A,3F,3D,3K,ACDEFGHK
      case 'ACDEFGHK':
        return [
          map['H']!,
          map['G']!,
          map['E']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['D']!,
          map['K']!,
        ];
      // Veio da linha: 284,3H,3G,3J,3C,3A,3F,3D,3E,ACDEFGHJ
      case 'ACDEFGHJ':
        return [
          map['H']!,
          map['G']!,
          map['J']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['D']!,
          map['E']!,
        ];
      // Veio da linha: 285,3H,3G,3E,3C,3A,3F,3D,3I,ACDEFGHI
      case 'ACDEFGHI':
        return [
          map['H']!,
          map['G']!,
          map['E']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['D']!,
          map['I']!,
        ];
      // Veio da linha: 286,3H,3J,3B,3A,3I,3G,3L,3K,ABGHIJKL
      case 'ABGHIJKL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['A']!,
          map['I']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 287,3H,3J,3B,3A,3I,3F,3L,3K,ABFHIJKL
      case 'ABFHIJKL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['A']!,
          map['I']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 288,3I,3J,3B,3F,3A,3G,3L,3K,ABFGIJKL
      case 'ABFGIJKL':
        return [
          map['I']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 289,3H,3J,3B,3F,3A,3G,3L,3K,ABFGHJKL
      case 'ABFGHJKL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 290,3H,3G,3B,3A,3I,3F,3L,3K,ABFGHIKL
      case 'ABFGHIKL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['A']!,
          map['I']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 291,3H,3J,3B,3F,3A,3G,3L,3I,ABFGHIJL
      case 'ABFGHIJL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 292,3H,3J,3B,3F,3A,3G,3I,3K,ABFGHIJK
      case 'ABFGHIJK':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['G']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 293,3E,3J,3B,3A,3I,3H,3L,3K,ABEHIJKL
      case 'ABEHIJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['A']!,
          map['I']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 294,3E,3J,3B,3A,3I,3G,3L,3K,ABEGIJKL
      case 'ABEGIJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['A']!,
          map['I']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 295,3E,3J,3B,3A,3H,3G,3L,3K,ABEGHJKL
      case 'ABEGHJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['A']!,
          map['H']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 296,3E,3G,3B,3A,3I,3H,3L,3K,ABEGHIKL
      case 'ABEGHIKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['A']!,
          map['I']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 297,3E,3J,3B,3A,3H,3G,3L,3I,ABEGHIJL
      case 'ABEGHIJL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['A']!,
          map['H']!,
          map['G']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 298,3E,3J,3B,3A,3H,3G,3I,3K,ABEGHIJK
      case 'ABEGHIJK':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['A']!,
          map['H']!,
          map['G']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 299,3E,3J,3B,3A,3I,3F,3L,3K,ABEFIJKL
      case 'ABEFIJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['A']!,
          map['I']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 300,3E,3J,3B,3F,3A,3H,3L,3K,ABEFHJKL
      case 'ABEFHJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 301,3E,3I,3B,3F,3A,3H,3L,3K,ABEFHIKL
      case 'ABEFHIKL':
        return [
          map['E']!,
          map['I']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 302,3E,3J,3B,3F,3A,3H,3L,3I,ABEFHIJL
      case 'ABEFHIJL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 303,3E,3J,3B,3F,3A,3H,3I,3K,ABEFHIJK
      case 'ABEFHIJK':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['H']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 304,3E,3J,3B,3F,3A,3G,3L,3K,ABEFGJKL
      case 'ABEFGJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 305,3E,3G,3B,3A,3I,3F,3L,3K,ABEFGIKL
      case 'ABEFGIKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['A']!,
          map['I']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 306,3E,3J,3B,3F,3A,3G,3L,3I,ABEFGIJL
      case 'ABEFGIJL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 307,3E,3J,3B,3F,3A,3G,3I,3K,ABEFGIJK
      case 'ABEFGIJK':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['G']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 308,3E,3G,3B,3F,3A,3H,3L,3K,ABEFGHKL
      case 'ABEFGHKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 309,3H,3J,3B,3F,3A,3G,3L,3E,ABEFGHJL
      case 'ABEFGHJL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 310,3H,3J,3B,3F,3A,3G,3E,3K,ABEFGHJK
      case 'ABEFGHJK':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['G']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 311,3E,3G,3B,3F,3A,3H,3L,3I,ABEFGHIL
      case 'ABEFGHIL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 312,3E,3G,3B,3F,3A,3H,3I,3K,ABEFGHIK
      case 'ABEFGHIK':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['H']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 313,3H,3J,3B,3F,3A,3G,3E,3I,ABEFGHIJ
      case 'ABEFGHIJ':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['G']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 314,3I,3J,3B,3D,3A,3H,3L,3K,ABDHIJKL
      case 'ABDHIJKL':
        return [
          map['I']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 315,3I,3J,3B,3D,3A,3G,3L,3K,ABDGIJKL
      case 'ABDGIJKL':
        return [
          map['I']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 316,3H,3J,3B,3D,3A,3G,3L,3K,ABDGHJKL
      case 'ABDGHJKL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 317,3I,3G,3B,3D,3A,3H,3L,3K,ABDGHIKL
      case 'ABDGHIKL':
        return [
          map['I']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 318,3H,3J,3B,3D,3A,3G,3L,3I,ABDGHIJL
      case 'ABDGHIJL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 319,3H,3J,3B,3D,3A,3G,3I,3K,ABDGHIJK
      case 'ABDGHIJK':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['G']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 320,3I,3J,3B,3D,3A,3F,3L,3K,ABDFIJKL
      case 'ABDFIJKL':
        return [
          map['I']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 321,3H,3J,3B,3D,3A,3F,3L,3K,ABDFHJKL
      case 'ABDFHJKL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 322,3H,3I,3B,3D,3A,3F,3L,3K,ABDFHIKL
      case 'ABDFHIKL':
        return [
          map['H']!,
          map['I']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 323,3H,3J,3B,3D,3A,3F,3L,3I,ABDFHIJL
      case 'ABDFHIJL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 324,3H,3J,3B,3D,3A,3F,3I,3K,ABDFHIJK
      case 'ABDFHIJK':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 325,3F,3J,3B,3D,3A,3G,3L,3K,ABDFGJKL
      case 'ABDFGJKL':
        return [
          map['F']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 326,3I,3G,3B,3D,3A,3F,3L,3K,ABDFGIKL
      case 'ABDFGIKL':
        return [
          map['I']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 327,3F,3J,3B,3D,3A,3G,3L,3I,ABDFGIJL
      case 'ABDFGIJL':
        return [
          map['F']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 328,3F,3J,3B,3D,3A,3G,3I,3K,ABDFGIJK
      case 'ABDFGIJK':
        return [
          map['F']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['G']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 329,3H,3G,3B,3D,3A,3F,3L,3K,ABDFGHKL
      case 'ABDFGHKL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 330,3H,3G,3B,3D,3A,3F,3L,3J,ABDFGHJL
      case 'ABDFGHJL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['J']!,
        ];
      // Veio da linha: 331,3H,3G,3B,3D,3A,3F,3J,3K,ABDFGHJK
      case 'ABDFGHJK':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['J']!,
          map['K']!,
        ];
      // Veio da linha: 332,3H,3G,3B,3D,3A,3F,3L,3I,ABDFGHIL
      case 'ABDFGHIL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 333,3H,3G,3B,3D,3A,3F,3I,3K,ABDFGHIK
      case 'ABDFGHIK':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 334,3H,3G,3B,3D,3A,3F,3I,3J,ABDFGHIJ
      case 'ABDFGHIJ':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['J']!,
        ];
      // Veio da linha: 335,3E,3J,3B,3A,3I,3D,3L,3K,ABDEIJKL
      case 'ABDEIJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['A']!,
          map['I']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 336,3E,3J,3B,3D,3A,3H,3L,3K,ABDEHJKL
      case 'ABDEHJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 337,3E,3I,3B,3D,3A,3H,3L,3K,ABDEHIKL
      case 'ABDEHIKL':
        return [
          map['E']!,
          map['I']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 338,3E,3J,3B,3D,3A,3H,3L,3I,ABDEHIJL
      case 'ABDEHIJL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 339,3E,3J,3B,3D,3A,3H,3I,3K,ABDEHIJK
      case 'ABDEHIJK':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['H']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 340,3E,3J,3B,3D,3A,3G,3L,3K,ABDEGJKL
      case 'ABDEGJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 341,3E,3G,3B,3A,3I,3D,3L,3K,ABDEGIKL
      case 'ABDEGIKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['A']!,
          map['I']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 342,3E,3J,3B,3D,3A,3G,3L,3I,ABDEGIJL
      case 'ABDEGIJL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 343,3E,3J,3B,3D,3A,3G,3I,3K,ABDEGIJK
      case 'ABDEGIJK':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['G']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 344,3E,3G,3B,3D,3A,3H,3L,3K,ABDEGHKL
      case 'ABDEGHKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 345,3H,3J,3B,3D,3A,3G,3L,3E,ABDEGHJL
      case 'ABDEGHJL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 346,3H,3J,3B,3D,3A,3G,3E,3K,ABDEGHJK
      case 'ABDEGHJK':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['G']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 347,3E,3G,3B,3D,3A,3H,3L,3I,ABDEGHIL
      case 'ABDEGHIL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 348,3E,3G,3B,3D,3A,3H,3I,3K,ABDEGHIK
      case 'ABDEGHIK':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['H']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 349,3H,3J,3B,3D,3A,3G,3E,3I,ABDEGHIJ
      case 'ABDEGHIJ':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['G']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 350,3E,3J,3B,3D,3A,3F,3L,3K,ABDEFJKL
      case 'ABDEFJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 351,3E,3I,3B,3D,3A,3F,3L,3K,ABDEFIKL
      case 'ABDEFIKL':
        return [
          map['E']!,
          map['I']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 352,3E,3J,3B,3D,3A,3F,3L,3I,ABDEFIJL
      case 'ABDEFIJL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 353,3E,3J,3B,3D,3A,3F,3I,3K,ABDEFIJK
      case 'ABDEFIJK':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 354,3H,3E,3B,3D,3A,3F,3L,3K,ABDEFHKL
      case 'ABDEFHKL':
        return [
          map['H']!,
          map['E']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 355,3H,3J,3B,3D,3A,3F,3L,3E,ABDEFHJL
      case 'ABDEFHJL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 356,3H,3J,3B,3D,3A,3F,3E,3K,ABDEFHJK
      case 'ABDEFHJK':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 357,3H,3E,3B,3D,3A,3F,3L,3I,ABDEFHIL
      case 'ABDEFHIL':
        return [
          map['H']!,
          map['E']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 358,3H,3E,3B,3D,3A,3F,3I,3K,ABDEFHIK
      case 'ABDEFHIK':
        return [
          map['H']!,
          map['E']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 359,3H,3J,3B,3D,3A,3F,3E,3I,ABDEFHIJ
      case 'ABDEFHIJ':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 360,3E,3G,3B,3D,3A,3F,3L,3K,ABDEFGKL
      case 'ABDEFGKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 361,3E,3G,3B,3D,3A,3F,3L,3J,ABDEFGJL
      case 'ABDEFGJL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['J']!,
        ];
      // Veio da linha: 362,3E,3G,3B,3D,3A,3F,3J,3K,ABDEFGJK
      case 'ABDEFGJK':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['J']!,
          map['K']!,
        ];
      // Veio da linha: 363,3E,3G,3B,3D,3A,3F,3L,3I,ABDEFGIL
      case 'ABDEFGIL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 364,3E,3G,3B,3D,3A,3F,3I,3K,ABDEFGIK
      case 'ABDEFGIK':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 365,3E,3G,3B,3D,3A,3F,3I,3J,ABDEFGIJ
      case 'ABDEFGIJ':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['J']!,
        ];
      // Veio da linha: 366,3H,3G,3B,3D,3A,3F,3L,3E,ABDEFGHL
      case 'ABDEFGHL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 367,3H,3G,3B,3D,3A,3F,3E,3K,ABDEFGHK
      case 'ABDEFGHK':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 368,3H,3G,3B,3D,3A,3F,3E,3J,ABDEFGHJ
      case 'ABDEFGHJ':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['J']!,
        ];
      // Veio da linha: 369,3H,3G,3B,3D,3A,3F,3E,3I,ABDEFGHI
      case 'ABDEFGHI':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 370,3I,3J,3B,3C,3A,3H,3L,3K,ABCHIJKL
      case 'ABCHIJKL':
        return [
          map['I']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 371,3I,3J,3B,3C,3A,3G,3L,3K,ABCGIJKL
      case 'ABCGIJKL':
        return [
          map['I']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 372,3H,3J,3B,3C,3A,3G,3L,3K,ABCGHJKL
      case 'ABCGHJKL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 373,3I,3G,3B,3C,3A,3H,3L,3K,ABCGHIKL
      case 'ABCGHIKL':
        return [
          map['I']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 374,3H,3J,3B,3C,3A,3G,3L,3I,ABCGHIJL
      case 'ABCGHIJL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 375,3H,3J,3B,3C,3A,3G,3I,3K,ABCGHIJK
      case 'ABCGHIJK':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['G']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 376,3I,3J,3B,3C,3A,3F,3L,3K,ABCFIJKL
      case 'ABCFIJKL':
        return [
          map['I']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 377,3H,3J,3B,3C,3A,3F,3L,3K,ABCFHJKL
      case 'ABCFHJKL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 378,3H,3I,3B,3C,3A,3F,3L,3K,ABCFHIKL
      case 'ABCFHIKL':
        return [
          map['H']!,
          map['I']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 379,3H,3J,3B,3C,3A,3F,3L,3I,ABCFHIJL
      case 'ABCFHIJL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 380,3H,3J,3B,3C,3A,3F,3I,3K,ABCFHIJK
      case 'ABCFHIJK':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 381,3C,3J,3B,3F,3A,3G,3L,3K,ABCFGJKL
      case 'ABCFGJKL':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 382,3I,3G,3B,3C,3A,3F,3L,3K,ABCFGIKL
      case 'ABCFGIKL':
        return [
          map['I']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 383,3C,3J,3B,3F,3A,3G,3L,3I,ABCFGIJL
      case 'ABCFGIJL':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 384,3C,3J,3B,3F,3A,3G,3I,3K,ABCFGIJK
      case 'ABCFGIJK':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['F']!,
          map['A']!,
          map['G']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 385,3H,3G,3B,3C,3A,3F,3L,3K,ABCFGHKL
      case 'ABCFGHKL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 386,3H,3G,3B,3C,3A,3F,3L,3J,ABCFGHJL
      case 'ABCFGHJL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['J']!,
        ];
      // Veio da linha: 387,3H,3G,3B,3C,3A,3F,3J,3K,ABCFGHJK
      case 'ABCFGHJK':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['J']!,
          map['K']!,
        ];
      // Veio da linha: 388,3H,3G,3B,3C,3A,3F,3L,3I,ABCFGHIL
      case 'ABCFGHIL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 389,3H,3G,3B,3C,3A,3F,3I,3K,ABCFGHIK
      case 'ABCFGHIK':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 390,3H,3G,3B,3C,3A,3F,3I,3J,ABCFGHIJ
      case 'ABCFGHIJ':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['J']!,
        ];
      // Veio da linha: 391,3E,3J,3B,3A,3I,3C,3L,3K,ABCEIJKL
      case 'ABCEIJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['A']!,
          map['I']!,
          map['C']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 392,3E,3J,3B,3C,3A,3H,3L,3K,ABCEHJKL
      case 'ABCEHJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 393,3E,3I,3B,3C,3A,3H,3L,3K,ABCEHIKL
      case 'ABCEHIKL':
        return [
          map['E']!,
          map['I']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 394,3E,3J,3B,3C,3A,3H,3L,3I,ABCEHIJL
      case 'ABCEHIJL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 395,3E,3J,3B,3C,3A,3H,3I,3K,ABCEHIJK
      case 'ABCEHIJK':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['H']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 396,3E,3J,3B,3C,3A,3G,3L,3K,ABCEGJKL
      case 'ABCEGJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 397,3E,3G,3B,3A,3I,3C,3L,3K,ABCEGIKL
      case 'ABCEGIKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['A']!,
          map['I']!,
          map['C']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 398,3E,3J,3B,3C,3A,3G,3L,3I,ABCEGIJL
      case 'ABCEGIJL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 399,3E,3J,3B,3C,3A,3G,3I,3K,ABCEGIJK
      case 'ABCEGIJK':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['G']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 400,3E,3G,3B,3C,3A,3H,3L,3K,ABCEGHKL
      case 'ABCEGHKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 401,3H,3J,3B,3C,3A,3G,3L,3E,ABCEGHJL
      case 'ABCEGHJL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 402,3H,3J,3B,3C,3A,3G,3E,3K,ABCEGHJK
      case 'ABCEGHJK':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['G']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 403,3E,3G,3B,3C,3A,3H,3L,3I,ABCEGHIL
      case 'ABCEGHIL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['H']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 404,3E,3G,3B,3C,3A,3H,3I,3K,ABCEGHIK
      case 'ABCEGHIK':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['H']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 405,3H,3J,3B,3C,3A,3G,3E,3I,ABCEGHIJ
      case 'ABCEGHIJ':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['G']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 406,3E,3J,3B,3C,3A,3F,3L,3K,ABCEFJKL
      case 'ABCEFJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 407,3E,3I,3B,3C,3A,3F,3L,3K,ABCEFIKL
      case 'ABCEFIKL':
        return [
          map['E']!,
          map['I']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 408,3E,3J,3B,3C,3A,3F,3L,3I,ABCEFIJL
      case 'ABCEFIJL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 409,3E,3J,3B,3C,3A,3F,3I,3K,ABCEFIJK
      case 'ABCEFIJK':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 410,3H,3E,3B,3C,3A,3F,3L,3K,ABCEFHKL
      case 'ABCEFHKL':
        return [
          map['H']!,
          map['E']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 411,3H,3J,3B,3C,3A,3F,3L,3E,ABCEFHJL
      case 'ABCEFHJL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 412,3H,3J,3B,3C,3A,3F,3E,3K,ABCEFHJK
      case 'ABCEFHJK':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 413,3H,3E,3B,3C,3A,3F,3L,3I,ABCEFHIL
      case 'ABCEFHIL':
        return [
          map['H']!,
          map['E']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 414,3H,3E,3B,3C,3A,3F,3I,3K,ABCEFHIK
      case 'ABCEFHIK':
        return [
          map['H']!,
          map['E']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 415,3H,3J,3B,3C,3A,3F,3E,3I,ABCEFHIJ
      case 'ABCEFHIJ':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 416,3E,3G,3B,3C,3A,3F,3L,3K,ABCEFGKL
      case 'ABCEFGKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 417,3E,3G,3B,3C,3A,3F,3L,3J,ABCEFGJL
      case 'ABCEFGJL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['J']!,
        ];
      // Veio da linha: 418,3E,3G,3B,3C,3A,3F,3J,3K,ABCEFGJK
      case 'ABCEFGJK':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['J']!,
          map['K']!,
        ];
      // Veio da linha: 419,3E,3G,3B,3C,3A,3F,3L,3I,ABCEFGIL
      case 'ABCEFGIL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 420,3E,3G,3B,3C,3A,3F,3I,3K,ABCEFGIK
      case 'ABCEFGIK':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 421,3E,3G,3B,3C,3A,3F,3I,3J,ABCEFGIJ
      case 'ABCEFGIJ':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['J']!,
        ];
      // Veio da linha: 422,3H,3G,3B,3C,3A,3F,3L,3E,ABCEFGHL
      case 'ABCEFGHL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 423,3H,3G,3B,3C,3A,3F,3E,3K,ABCEFGHK
      case 'ABCEFGHK':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 424,3H,3G,3B,3C,3A,3F,3E,3J,ABCEFGHJ
      case 'ABCEFGHJ':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['J']!,
        ];
      // Veio da linha: 425,3H,3G,3B,3C,3A,3F,3E,3I,ABCEFGHI
      case 'ABCEFGHI':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 426,3I,3J,3B,3C,3A,3D,3L,3K,ABCDIJKL
      case 'ABCDIJKL':
        return [
          map['I']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 427,3H,3J,3B,3C,3A,3D,3L,3K,ABCDHJKL
      case 'ABCDHJKL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 428,3H,3I,3B,3C,3A,3D,3L,3K,ABCDHIKL
      case 'ABCDHIKL':
        return [
          map['H']!,
          map['I']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 429,3H,3J,3B,3C,3A,3D,3L,3I,ABCDHIJL
      case 'ABCDHIJL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 430,3H,3J,3B,3C,3A,3D,3I,3K,ABCDHIJK
      case 'ABCDHIJK':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 431,3C,3J,3B,3D,3A,3G,3L,3K,ABCDGJKL
      case 'ABCDGJKL':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 432,3I,3G,3B,3C,3A,3D,3L,3K,ABCDGIKL
      case 'ABCDGIKL':
        return [
          map['I']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 433,3C,3J,3B,3D,3A,3G,3L,3I,ABCDGIJL
      case 'ABCDGIJL':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['G']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 434,3C,3J,3B,3D,3A,3G,3I,3K,ABCDGIJK
      case 'ABCDGIJK':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['G']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 435,3H,3G,3B,3C,3A,3D,3L,3K,ABCDGHKL
      case 'ABCDGHKL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 436,3H,3G,3B,3C,3A,3D,3L,3J,ABCDGHJL
      case 'ABCDGHJL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['J']!,
        ];
      // Veio da linha: 437,3H,3G,3B,3C,3A,3D,3J,3K,ABCDGHJK
      case 'ABCDGHJK':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['J']!,
          map['K']!,
        ];
      // Veio da linha: 438,3H,3G,3B,3C,3A,3D,3L,3I,ABCDGHIL
      case 'ABCDGHIL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 439,3H,3G,3B,3C,3A,3D,3I,3K,ABCDGHIK
      case 'ABCDGHIK':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 440,3H,3G,3B,3C,3A,3D,3I,3J,ABCDGHIJ
      case 'ABCDGHIJ':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['I']!,
          map['J']!,
        ];
      // Veio da linha: 441,3C,3J,3B,3D,3A,3F,3L,3K,ABCDFJKL
      case 'ABCDFJKL':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 442,3C,3I,3B,3D,3A,3F,3L,3K,ABCDFIKL
      case 'ABCDFIKL':
        return [
          map['C']!,
          map['I']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 443,3C,3J,3B,3D,3A,3F,3L,3I,ABCDFIJL
      case 'ABCDFIJL':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 444,3C,3J,3B,3D,3A,3F,3I,3K,ABCDFIJK
      case 'ABCDFIJK':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 445,3H,3F,3B,3C,3A,3D,3L,3K,ABCDFHKL
      case 'ABCDFHKL':
        return [
          map['H']!,
          map['F']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 446,3C,3J,3B,3D,3A,3F,3L,3H,ABCDFHJL
      case 'ABCDFHJL':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['H']!,
        ];
      // Veio da linha: 447,3H,3J,3B,3C,3A,3F,3D,3K,ABCDFHJK
      case 'ABCDFHJK':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['D']!,
          map['K']!,
        ];
      // Veio da linha: 448,3H,3F,3B,3C,3A,3D,3L,3I,ABCDFHIL
      case 'ABCDFHIL':
        return [
          map['H']!,
          map['F']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 449,3H,3F,3B,3C,3A,3D,3I,3K,ABCDFHIK
      case 'ABCDFHIK':
        return [
          map['H']!,
          map['F']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 450,3H,3J,3B,3C,3A,3F,3D,3I,ABCDFHIJ
      case 'ABCDFHIJ':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['D']!,
          map['I']!,
        ];
      // Veio da linha: 451,3C,3G,3B,3D,3A,3F,3L,3K,ABCDFGKL
      case 'ABCDFGKL':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 452,3C,3G,3B,3D,3A,3F,3L,3J,ABCDFGJL
      case 'ABCDFGJL':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['J']!,
        ];
      // Veio da linha: 453,3C,3G,3B,3D,3A,3F,3J,3K,ABCDFGJK
      case 'ABCDFGJK':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['J']!,
          map['K']!,
        ];
      // Veio da linha: 454,3C,3G,3B,3D,3A,3F,3L,3I,ABCDFGIL
      case 'ABCDFGIL':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 455,3C,3G,3B,3D,3A,3F,3I,3K,ABCDFGIK
      case 'ABCDFGIK':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 456,3C,3G,3B,3D,3A,3F,3I,3J,ABCDFGIJ
      case 'ABCDFGIJ':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['J']!,
        ];
      // Veio da linha: 457,3C,3G,3B,3D,3A,3F,3L,3H,ABCDFGHL
      case 'ABCDFGHL':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['H']!,
        ];
      // Veio da linha: 458,3H,3G,3B,3C,3A,3F,3D,3K,ABCDFGHK
      case 'ABCDFGHK':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['D']!,
          map['K']!,
        ];
      // Veio da linha: 459,3H,3G,3B,3C,3A,3F,3D,3J,ABCDFGHJ
      case 'ABCDFGHJ':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['D']!,
          map['J']!,
        ];
      // Veio da linha: 460,3H,3G,3B,3C,3A,3F,3D,3I,ABCDFGHI
      case 'ABCDFGHI':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['D']!,
          map['I']!,
        ];
      // Veio da linha: 461,3E,3J,3B,3C,3A,3D,3L,3K,ABCDEJKL
      case 'ABCDEJKL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 462,3E,3I,3B,3C,3A,3D,3L,3K,ABCDEIKL
      case 'ABCDEIKL':
        return [
          map['E']!,
          map['I']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 463,3E,3J,3B,3C,3A,3D,3L,3I,ABCDEIJL
      case 'ABCDEIJL':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 464,3E,3J,3B,3C,3A,3D,3I,3K,ABCDEIJK
      case 'ABCDEIJK':
        return [
          map['E']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 465,3H,3E,3B,3C,3A,3D,3L,3K,ABCDEHKL
      case 'ABCDEHKL':
        return [
          map['H']!,
          map['E']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 466,3H,3J,3B,3C,3A,3D,3L,3E,ABCDEHJL
      case 'ABCDEHJL':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 467,3H,3J,3B,3C,3A,3D,3E,3K,ABCDEHJK
      case 'ABCDEHJK':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 468,3H,3E,3B,3C,3A,3D,3L,3I,ABCDEHIL
      case 'ABCDEHIL':
        return [
          map['H']!,
          map['E']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 469,3H,3E,3B,3C,3A,3D,3I,3K,ABCDEHIK
      case 'ABCDEHIK':
        return [
          map['H']!,
          map['E']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 470,3H,3J,3B,3C,3A,3D,3E,3I,ABCDEHIJ
      case 'ABCDEHIJ':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 471,3E,3G,3B,3C,3A,3D,3L,3K,ABCDEGKL
      case 'ABCDEGKL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 472,3E,3G,3B,3C,3A,3D,3L,3J,ABCDEGJL
      case 'ABCDEGJL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['J']!,
        ];
      // Veio da linha: 473,3E,3G,3B,3C,3A,3D,3J,3K,ABCDEGJK
      case 'ABCDEGJK':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['J']!,
          map['K']!,
        ];
      // Veio da linha: 474,3E,3G,3B,3C,3A,3D,3L,3I,ABCDEGIL
      case 'ABCDEGIL':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 475,3E,3G,3B,3C,3A,3D,3I,3K,ABCDEGIK
      case 'ABCDEGIK':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 476,3E,3G,3B,3C,3A,3D,3I,3J,ABCDEGIJ
      case 'ABCDEGIJ':
        return [
          map['E']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['I']!,
          map['J']!,
        ];
      // Veio da linha: 477,3H,3G,3B,3C,3A,3D,3L,3E,ABCDEGHL
      case 'ABCDEGHL':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 478,3H,3G,3B,3C,3A,3D,3E,3K,ABCDEGHK
      case 'ABCDEGHK':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 479,3H,3G,3B,3C,3A,3D,3E,3J,ABCDEGHJ
      case 'ABCDEGHJ':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['E']!,
          map['J']!,
        ];
      // Veio da linha: 480,3H,3G,3B,3C,3A,3D,3E,3I,ABCDEGHI
      case 'ABCDEGHI':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 481,3C,3E,3B,3D,3A,3F,3L,3K,ABCDEFKL
      case 'ABCDEFKL':
        return [
          map['C']!,
          map['E']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['K']!,
        ];
      // Veio da linha: 482,3C,3J,3B,3D,3A,3F,3L,3E,ABCDEFJL
      case 'ABCDEFJL':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 483,3C,3J,3B,3D,3A,3F,3E,3K,ABCDEFJK
      case 'ABCDEFJK':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 484,3C,3E,3B,3D,3A,3F,3L,3I,ABCDEFIL
      case 'ABCDEFIL':
        return [
          map['C']!,
          map['E']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['I']!,
        ];
      // Veio da linha: 485,3C,3E,3B,3D,3A,3F,3I,3K,ABCDEFIK
      case 'ABCDEFIK':
        return [
          map['C']!,
          map['E']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['I']!,
          map['K']!,
        ];
      // Veio da linha: 486,3C,3J,3B,3D,3A,3F,3E,3I,ABCDEFIJ
      case 'ABCDEFIJ':
        return [
          map['C']!,
          map['J']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 487,3H,3F,3B,3C,3A,3D,3L,3E,ABCDEFHL
      case 'ABCDEFHL':
        return [
          map['H']!,
          map['F']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['D']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 488,3H,3E,3B,3C,3A,3F,3D,3K,ABCDEFHK
      case 'ABCDEFHK':
        return [
          map['H']!,
          map['E']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['D']!,
          map['K']!,
        ];
      // Veio da linha: 489,3H,3J,3B,3C,3A,3F,3D,3E,ABCDEFHJ
      case 'ABCDEFHJ':
        return [
          map['H']!,
          map['J']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['D']!,
          map['E']!,
        ];
      // Veio da linha: 490,3H,3E,3B,3C,3A,3F,3D,3I,ABCDEFHI
      case 'ABCDEFHI':
        return [
          map['H']!,
          map['E']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['D']!,
          map['I']!,
        ];
      // Veio da linha: 491,3C,3G,3B,3D,3A,3F,3L,3E,ABCDEFGL
      case 'ABCDEFGL':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['L']!,
          map['E']!,
        ];
      // Veio da linha: 492,3C,3G,3B,3D,3A,3F,3E,3K,ABCDEFGK
      case 'ABCDEFGK':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['K']!,
        ];
      // Veio da linha: 493,3C,3G,3B,3D,3A,3F,3E,3J,ABCDEFGJ
      case 'ABCDEFGJ':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['J']!,
        ];
      // Veio da linha: 494,3C,3G,3B,3D,3A,3F,3E,3I,ABCDEFGI
      case 'ABCDEFGI':
        return [
          map['C']!,
          map['G']!,
          map['B']!,
          map['D']!,
          map['A']!,
          map['F']!,
          map['E']!,
          map['I']!,
        ];
      // Veio da linha: 495,3H,3G,3B,3C,3A,3F,3D,3E,ABCDEFGH
      case 'ABCDEFGH':
        return [
          map['H']!,
          map['G']!,
          map['B']!,
          map['C']!,
          map['A']!,
          map['F']!,
          map['D']!,
          map['E']!,
        ];
    }

    throw Exception('Não foi possível montar os terceiros lugares');
  }
}
