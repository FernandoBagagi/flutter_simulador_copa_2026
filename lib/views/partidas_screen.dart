import 'package:flutter/material.dart';
import 'package:flutter_simulador_copa_2026/di/service_locator.dart';
import 'package:flutter_simulador_copa_2026/viewmodels/partidas_viewmodel.dart';
import 'package:flutter_simulador_copa_2026/views/partida_widget.dart';
import 'package:flutter_simulador_copa_2026/views/partida_widget_contoller.dart';

class PartidasScreen extends StatefulWidget {
  const PartidasScreen({super.key});

  @override
  State<PartidasScreen> createState() => _PartidasScreenState();
}

class _PartidasScreenState extends State<PartidasScreen> {
  late final PartidasViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<PartidasViewModel>();
    _viewModel.carregarPartidas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Partidas')),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: _bodyListenableBuilder,
      ),
    );
  }

  Widget _bodyListenableBuilder(BuildContext context, Widget? child) {
    switch (_viewModel.status) {
      case PartidasViewModelStatus.erro:
        return const Center(child: Text('Erro ao carregar partida'));
      case PartidasViewModelStatus.carregando:
        return const Center(child: CircularProgressIndicator());
      case PartidasViewModelStatus.carregou:
        return _bodyPartidasCarregadas();
    }
  }

  Widget _bodyPartidasCarregadas() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 8,
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: _listPartidaWidgetBuilder,
              itemCount: _viewModel.partidas.length,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _viewModel.gerarProximaRodada();
            },
            child: const Text('Gerar próxima rodada'),
          ),
        ],
      ),
    );
  }

  Widget _listPartidaWidgetBuilder(BuildContext context, int index) {
    final partida = _viewModel.partidas.elementAt(index);
    return PartidaWidget(
      contoller: PartidaWidgetContoller(
        partida: partida,
        selecao1: _viewModel.getSelecao(partida.selecao1.trigrama),
        selecao2: _viewModel.getSelecao(partida.selecao2.trigrama),
      ),
    );
  }
}
