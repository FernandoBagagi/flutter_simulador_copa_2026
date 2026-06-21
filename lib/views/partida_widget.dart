import 'package:flutter/material.dart';
import 'package:flutter_simulador_copa_2026/models/selecao.dart';
import 'package:flutter_simulador_copa_2026/views/partida_widget_contoller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PartidaWidget extends StatelessWidget {
  final PartidaWidgetContoller contoller;
  const PartidaWidget({super.key, required this.contoller});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        '${contoller.partida.numero}',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSelecaoInfo(
            selecao: contoller.selecao1,
            gols: contoller.partida.selecao1.golsMarcados,
          ),
          const Text(
            'X',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          _buildSelecaoInfo(
            selecao: contoller.selecao2,
            gols: contoller.partida.selecao2.golsMarcados,
            espelhar: true,
          ),
        ],
      ),
      subtitle: Center(child: Text(contoller.partida.local)),
    );
  }

  Widget _buildSelecaoInfo({
    required Selecao selecao,
    required int gols,
    bool espelhar = false,
  }) {
    List<Widget> children = [
      _bandeiraSelecao(selecao),
      _labelSelecao(selecao.trigrama),
      _inputGolsSelecao(gols),
    ];

    if (espelhar) {
      children = children.reversed.toList();
    }

    return Row(spacing: 16, mainAxisSize: MainAxisSize.min, children: children);
  }

  Widget _bandeiraSelecao(Selecao selecao) {
    final assetName = selecao.pathBandeira;

    if (assetName.isEmpty || !assetName.endsWith('.svg')) {
      return _placeholderBandeiraSelecao(selecao.trigrama);
    }

    return SvgPicture.asset(
      assetName,
      width: 60,
      height: 40,
      fit: BoxFit.cover,
      placeholderBuilder: (_) {
        return _placeholderBandeiraSelecao(selecao.trigrama);
      },
    );
  }

  Widget _placeholderBandeiraSelecao(String trigrama) {
    return Container(
      width: 60,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        border: Border.all(color: Colors.black12),
      ),
      alignment: Alignment.center,
      child: Text(
        trigrama,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _labelSelecao(String trigrama) {
    return Text(
      trigrama.toUpperCase(),
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _inputGolsSelecao(int gols) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        controller: TextEditingController(text: '$gols'),
        enabled: false,
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 8),
        ),
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
