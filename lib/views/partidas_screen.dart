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
  late final ScrollController _scrollController;
  late final PartidasViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _viewModel = getIt<PartidasViewModel>();
    _viewModel.carregarPartidas();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Partidas')),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          switch (_viewModel.status) {
            case PartidasViewModelStatus.erro:
              return const Center(child: Text('Erro ao carregar partida'));
            case PartidasViewModelStatus.carregando:
              return const Center(child: CircularProgressIndicator());
            case PartidasViewModelStatus.carregou:
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    PartidaWidget(
                      contoller: PartidaWidgetContoller(
                        partida: _viewModel.partidaAtual,
                        selecao1: _viewModel.getSelecao(_viewModel.partidaAtual.selecao1.trigrama),
                        selecao2: _viewModel.getSelecao(_viewModel.partidaAtual.selecao2.trigrama),
                      ),
                    ),

                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _viewModel.hasPartidaAnterior()
                                ? _viewModel.partidaAnterior
                                : null,
                            child: const Text('Partida Anterior'),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _viewModel.hasProximaPartida()
                                ? _viewModel.proximaPartida
                                : null,
                            child: const Text('Próxima Partida'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
