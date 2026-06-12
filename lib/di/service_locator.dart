import 'package:flutter_simulador_copa_2026/repositories/selecao_repository.dart';
import 'package:flutter_simulador_copa_2026/viewmodels/selecoes_viewmodel.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupInjecaoDependencias() {
  // SelecoesViewModel
  getIt.registerLazySingleton<SelecaoRepository>(() => SelecaoRepository());
  getIt.registerFactory<SelecoesViewModel>(
    () => SelecoesViewModel(getIt<SelecaoRepository>()),
  );
}
