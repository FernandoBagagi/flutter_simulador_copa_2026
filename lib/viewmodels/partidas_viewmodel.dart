import 'package:flutter/foundation.dart';
import 'package:flutter_simulador_copa_2026/models/partida.dart';
import 'package:flutter_simulador_copa_2026/models/selecao.dart';
import 'package:flutter_simulador_copa_2026/repositories/partida_repository.dart';
import 'package:flutter_simulador_copa_2026/repositories/selecao_repository.dart';
import 'package:flutter_simulador_copa_2026/services/eliminatorias_service.dart';

enum PartidasViewModelStatus { carregou, carregando, erro }

class PartidasViewModel extends ChangeNotifier {
  final SelecaoRepository _selecaoRepository;
  final PartidaRepository _partidaRepository;
  final EliminatoriasService _eliminatoriasService;

  PartidasViewModel(
    this._selecaoRepository,
    this._partidaRepository,
    this._eliminatoriasService,
  );

  PartidasViewModelStatus _status = PartidasViewModelStatus.carregando;
  PartidasViewModelStatus get status => _status;

  final _selecoes = <Selecao>[];
  final _partidas = <Partida>[];
  List<Partida> get partidas => _partidas;

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

  List<Partida> gerarProximaRodada() {
    return _eliminatoriasService.gerarPartidas16Avos(partidas);
  }
}
