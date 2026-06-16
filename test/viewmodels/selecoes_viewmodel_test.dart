import 'package:flutter_simulador_copa_2026/models/selecao.dart';
import 'package:flutter_simulador_copa_2026/repositories/selecao_repository.dart';
import 'package:flutter_simulador_copa_2026/viewmodels/selecoes_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSelecaoRepository extends Mock implements SelecaoRepository {}

abstract class MostrarMensagemErroCallback {
  void mostrarMensagemErro();
}

class MockMostrarMensagemErro extends Mock
    implements MostrarMensagemErroCallback {}

void main() {
  late MockSelecaoRepository mockSelecaoRepository;
  late MockMostrarMensagemErro mockMostrarMensagemErro;
  late SelecoesViewModel viewModel;

  setUp(() {
    mockSelecaoRepository = MockSelecaoRepository();

    mockMostrarMensagemErro = MockMostrarMensagemErro();

    viewModel = SelecoesViewModel(
      mockSelecaoRepository,
      mostrarMensagemErro: mockMostrarMensagemErro.mostrarMensagemErro,
    );
  });

  test('Deve carregar seleções e atualizar o estado de isCarregando', () async {
    when(() => mockSelecaoRepository.findAll()).thenAnswer((_) async {
      return [const Selecao(trigrama: 'bra', codigoPais: 'br', nome: 'Brasil')];
    });

    verifyNever(() => mockSelecaoRepository.findAll());

    // Deve começar carregando
    expect(viewModel.isCarregando, isTrue);

    // Act: Executa a função
    await viewModel.carregarSelecoes();

    // Verifica se chamou somente uma vez
    verify(() => mockSelecaoRepository.findAll()).called(1);

    // Verifica se não deu erro
    verifyNever(() => mockMostrarMensagemErro.mostrarMensagemErro());

    // Assert final: Deve ter 1 item e não estar mais carregando
    expect(viewModel.selecoes.length, 1);
    expect(viewModel.selecoes.first.nome, 'Brasil');
    expect(viewModel.isCarregando, isFalse);
  });

  test(
    'Deve chamar mostrarMensagemErro ao ter erro em carregarSelecoes',
    () async {
      when(() => mockSelecaoRepository.findAll()).thenThrow(Exception());

      // Assert inicial: Deve começar carregando
      expect(viewModel.isCarregando, isTrue);

      verifyNever(() => mockSelecaoRepository.findAll());
      verifyNever(() => mockMostrarMensagemErro.mostrarMensagemErro());

      // Act: Executa a função
      await viewModel.carregarSelecoes();

      // Verifica se chamou somente uma vez
      verify(() => mockSelecaoRepository.findAll()).called(1);

      // Verifica se deu erro e chamou mostrarMensagemErro
      verify(() => mockMostrarMensagemErro.mostrarMensagemErro()).called(1);

      // Assert final: Não deve ser null, deve estar vazia e não estar mais carregando
      expect(viewModel.selecoes, isNotNull);
      expect(viewModel.selecoes.isEmpty, isTrue);
      expect(viewModel.isCarregando, isFalse);
    },
  );
}
