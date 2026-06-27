import 'package:flutter_simulador_copa_2026/models/partida.dart';
import 'package:flutter_simulador_copa_2026/services/selecao_tabela_grupo.dart';
import 'package:flutter_simulador_copa_2026/services/tabela_grupo.dart';

class EliminatoriasService {

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

    final grupos = {
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

    return [];
  }
}
