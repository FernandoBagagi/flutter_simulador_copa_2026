import 'package:flutter/material.dart';
import 'package:flutter_simulador_copa_2026/di/service_locator.dart';
import 'package:flutter_simulador_copa_2026/viewmodels/selecoes_viewmodel.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelecoesScreen extends StatefulWidget {
  const SelecoesScreen({super.key});

  @override
  State<SelecoesScreen> createState() => _SelecoesScreenState();
}

class _SelecoesScreenState extends State<SelecoesScreen> {
  late final ScrollController _scrollController;
  late final SelecoesViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _viewModel = getIt<SelecoesViewModel>(param1: _mostrarMensagemErro);
    _viewModel.carregarSelecoes();
  }

  void _mostrarMensagemErro() {
    ScaffoldMessenger //
        .of(context)
        .showSnackBar(
          const SnackBar(content: Text('Erro ao carregar seleções!')),
        );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seleções de 2026')),
      body: _body(),
    );
  }

  Widget _body() {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (BuildContext context, Widget? _) {
        return _viewModel.isCarregando
            ? _widgetCarregando()
            : _widgetConteudo();
      },
    );
  }

  Widget _widgetCarregando() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _widgetConteudo() {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: LayoutBuilder(builder: _builderConteudo),
    );
  }

  Widget _builderConteudo(BuildContext context, BoxConstraints constraints) {
    return constraints.maxHeight > constraints.maxWidth
        ? _buildMobileList()
        : _buildDesktopGrid(constraints.maxWidth);
  }

  Widget _buildMobileList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: _viewModel.selecoes.length,
      itemBuilder: (context, index) {
        final selecao = _viewModel.selecoes[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: _buildFlag(selecao.pathBandeira, width: 60, height: 45),
            title: Text(
              selecao.nome,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              selecao.trigrama.toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopGrid(double width) {
    // Calcula dinamicamente quantas colunas cabem na janela atual
    int crossAxisCount = (width / 220).floor();
    if (crossAxisCount < 2) crossAxisCount = 2;

    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _viewModel.selecoes.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1, // Controla proporção largura/altura do card
      ),
      itemBuilder: (context, index) {
        final selecao = _viewModel.selecoes[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          // InkWell adiciona efeitos nativos de clique e hover no Desktop
          child: InkWell(
            onTap: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFlag(selecao.pathBandeira, width: 145, height: 100),
                const SizedBox(height: 12),
                Text(
                  selecao.nome,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '(${selecao.trigrama.toUpperCase()})',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFlag(
    String path, {
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.black12, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: SvgPicture.asset(
        path,
        fit: BoxFit.cover,
        placeholderBuilder: (_) => Container(color: Colors.grey[200]),
      ),
    );
  }
}
