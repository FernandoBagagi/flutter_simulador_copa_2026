import 'package:flutter/services.dart';

class CombinacoesMelhoresTerceirosRepository {
  Future<List<String>> getCombinacao(String chave) async {
    final arquivo = await _lerArquivo();

    final arquivoTratado = _quebrarLinhasERetirarCabecalho(arquivo);

    final mapCombinacoes = _transformarArquivoEmMapCombinacoes(arquivoTratado);

    return mapCombinacoes[chave]!;
  }

  Future<String> _lerArquivo() async {
    return await rootBundle.loadString(
      'assets/combinacoes-melhores-terceiros.csv',
    );
  }

  List<String> _quebrarLinhasERetirarCabecalho(String arquivo) {
    return arquivo.split('\n').sublist(1);
  }

  Map<String, List<String>> _transformarArquivoEmMapCombinacoes(
    List<String> linhasArquivo,
  ) => Map.fromEntries(linhasArquivo.map(_mapLinhaToEntry));

  MapEntry<String, List<String>> _mapLinhaToEntry(String linha) {
    final somenteLetras = linha.replaceAll(RegExp(r'[^A-Z]'), '');

    if (somenteLetras.length != 16) {
      throw Exception('Erro ao tratar linha');
    }

    final chave = somenteLetras.substring(8);
    final valor = somenteLetras.substring(0, 8).split('');
    return MapEntry(chave, valor);
  }
}
