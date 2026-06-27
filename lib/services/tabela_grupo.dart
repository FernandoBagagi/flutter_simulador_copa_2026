import 'package:flutter_simulador_copa_2026/services/selecao_tabela_grupo.dart';

class TabelaGrupo {
  final String letra;
  final List<SelecaoTabelaGrupo> _selecoes;

  TabelaGrupo(this.letra) : _selecoes = [];

  void addSelecao(SelecaoTabelaGrupo selecao) {
    _selecoes.add(selecao);
    _selecoes.sort();
  }

  SelecaoTabelaGrupo get primeiro => _selecoes.elementAt(0);
  SelecaoTabelaGrupo get segundo => _selecoes.elementAt(1);
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
