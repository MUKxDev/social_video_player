import 'package:get_it/get_it.dart';
import 'package:jaar_player/features/player/bloc/preload_bloc.dart';
import 'package:jaar_player/service/api_service.dart';
import 'package:jaar_player/service/navigation_service.dart';

final GetIt getIt = GetIt.instance;

void configureInjection() {
  getIt
    ..registerLazySingleton(NavigationService.new)
    ..registerLazySingleton(ApiService.new)
    ..registerLazySingleton(PreloadBloc.new);
}
