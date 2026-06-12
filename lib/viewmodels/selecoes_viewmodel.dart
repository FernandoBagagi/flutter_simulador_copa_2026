import 'package:flutter/foundation.dart';
import 'package:flutter_simulador_copa_2026/models/selecao.dart';
import 'package:flutter_simulador_copa_2026/repositories/selecao_repository.dart';

class SelecoesViewModel extends ChangeNotifier {
  final SelecaoRepository _repository;
  final void Function()? mostrarMensagemErro;

  SelecoesViewModel(this._repository, {this.mostrarMensagemErro});

  bool _isCarregando = true;
  bool get isCarregando => _isCarregando;

  final _selecoes = <Selecao>[];
  List<Selecao> get selecoes => _selecoes;

  Future<void> carregarSelecoes() async {
    _isCarregando = true;
    notifyListeners();

    try {
      _selecoes.addAll(await _repository.findAll());
    } catch (e) {
      mostrarMensagemErro?.call();
    } finally {
      _isCarregando = false;
      notifyListeners();
    }
  }
}
