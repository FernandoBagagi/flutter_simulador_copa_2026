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
