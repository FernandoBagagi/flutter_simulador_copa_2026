import 'package:flutter/material.dart';
import 'package:flutter_simulador_copa_2026/views/selecoes_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
              Icons.sports_soccer,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              'Simulador Copa do Mundo 2026',
              style: Theme.of(
                context,
              ).textTheme
              .headlineMedium
              ?.copyWith(
                fontWeight: FontWeight.bold
                ),
            ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SelecoesScreen()),
              );
            },
            icon: const Icon(Icons.list),
            label: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('Ver Seleções Classificadas'),
            ),
          ),
        ],
      ),
    );
  }
}
