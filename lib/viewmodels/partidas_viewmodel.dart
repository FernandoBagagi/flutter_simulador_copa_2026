import 'package:flutter/foundation.dart';
import 'package:flutter_simulador_copa_2026/models/partida.dart';
import 'package:flutter_simulador_copa_2026/models/selecao.dart';
import 'package:flutter_simulador_copa_2026/repositories/partida_repository.dart';
import 'package:flutter_simulador_copa_2026/repositories/selecao_repository.dart';

enum PartidasViewModelStatus { carregou, carregando, erro }

class PartidasViewModel extends ChangeNotifier {
  final SelecaoRepository _selecaoRepository;
  final PartidaRepository _partidaRepository;

  PartidasViewModel(this._selecaoRepository, this._partidaRepository);

  PartidasViewModelStatus _status = PartidasViewModelStatus.carregando;
  PartidasViewModelStatus get status => _status;

  final _selecoes = <Selecao>[];
  final _partidas = <Partida>[];
  int _numeroPartidaAtual = 1;
  Partida get partidaAtual {
    return _partidas.elementAt(_numeroPartidaAtual - 1);
  }

  Selecao getSelecao(String trigrama) {
    return _selecoes.firstWhere(
      (Selecao selecao) {
        return selecao.trigrama.toUpperCase() == trigrama.toUpperCase();
      },
      orElse: () {
        throw Exception('Seleção não encontrada');
      },
    );
  }

  bool hasProximaPartida() {
    return (_numeroPartidaAtual + 1) <= _partidas.length;
  }

  void proximaPartida() {
    if (hasProximaPartida()) {
      _numeroPartidaAtual++;
      notifyListeners();
    }
  }

  bool hasPartidaAnterior() {
    return (_numeroPartidaAtual - 1) > 0;
  }

  void partidaAnterior() {
    if (hasPartidaAnterior()) {
      _numeroPartidaAtual--;
      notifyListeners();
    }
  }

  Future<void> carregarPartidas() async {
    _status = PartidasViewModelStatus.carregando;
    notifyListeners();

    try {
      _selecoes.addAll(await _selecaoRepository.findAll());
      _partidas.addAll(await _partidaRepository.findAll());
      _status = PartidasViewModelStatus.carregou;
    } catch (e) {
      _status = PartidasViewModelStatus.erro;
      debugPrint(e.toString());
    } finally {
      notifyListeners();
    }
  }

}
