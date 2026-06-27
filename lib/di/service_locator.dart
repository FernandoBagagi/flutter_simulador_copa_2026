import 'package:flutter_simulador_copa_2026/repositories/combinacoes_melhores_terceiros_repository.dart';
import 'package:flutter_simulador_copa_2026/repositories/partida_repository.dart';
import 'package:flutter_simulador_copa_2026/repositories/selecao_repository.dart';
import 'package:flutter_simulador_copa_2026/services/eliminatorias_service.dart';
import 'package:flutter_simulador_copa_2026/viewmodels/partidas_viewmodel.dart';
import 'package:flutter_simulador_copa_2026/viewmodels/selecoes_viewmodel.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupInjecaoDependencias() {
  // SelecoesViewModel
  getIt.registerLazySingleton<SelecaoRepository>(() => SelecaoRepository());
  getIt.registerFactoryParam<SelecoesViewModel, void Function()?, void>(
    _factoryFuncSelecoesViewModel,
  );

  // CombinacoesMelhoresTerceirosRepository
  getIt.registerLazySingleton<CombinacoesMelhoresTerceirosRepository>(
    () => CombinacoesMelhoresTerceirosRepository(),
  );

  // EliminatoriasService
  getIt.registerLazySingleton<EliminatoriasService>(
    () => EliminatoriasService(getIt<CombinacoesMelhoresTerceirosRepository>()),
  );

  // PartidasViewModel
  getIt.registerLazySingleton<PartidaRepository>(() => PartidaRepository());
  getIt.registerFactory<PartidasViewModel>(() {
    return PartidasViewModel(
      getIt<SelecaoRepository>(),
      getIt<PartidaRepository>(),
      getIt<EliminatoriasService>(),
    );
  });
}

SelecoesViewModel _factoryFuncSelecoesViewModel(
  void Function()? param1,
  void param2,
) {
  return SelecoesViewModel(
    getIt<SelecaoRepository>(),
    mostrarMensagemErro: param1,
  );
}
