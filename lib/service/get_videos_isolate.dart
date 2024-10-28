import 'dart:isolate';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaar_player/core/build_context.dart';
import 'package:jaar_player/core/constants.dart';
import 'package:jaar_player/features/player/bloc/preload_bloc.dart';
import 'package:jaar_player/service/api_service.dart';
import 'package:jaar_player/service/injection.dart';
import 'package:jaar_player/service/navigation_service.dart';

/// Isolate to fetch videos in the background so that the video
/// experience is not disturbed.
/// Without isolate, the video will be paused whenever there is an API call
/// because the main thread will be busy fetching new video URLs.
///
/// https://blog.codemagic.io/understanding-flutter-isolates/
Future<void> createIsolate(int index) async {
  // Set loading to true
  BlocProvider.of<PreloadBloc>(context).add(const PreloadEvent.setLoading());

  final mainReceivePort = ReceivePort();

  await Isolate.spawn<SendPort>(getVideosTask, mainReceivePort.sendPort);

  final isolateSendPort = await mainReceivePort.first as SendPort;

  final isolateResponseReceivePort = ReceivePort();

  isolateSendPort.send([index, isolateResponseReceivePort.sendPort]);

  final isolateResponse = await isolateResponseReceivePort.first;
  final urls = isolateResponse as List<String>;

  // Update new urls
  BlocProvider.of<PreloadBloc>(
    getIt<NavigationService>().navigationKey.currentContext!,
  ).add(PreloadEvent.updateUrls(urls));
}

Future<void> getVideosTask(SendPort mySendPort) async {
  final isolateReceivePort = ReceivePort();

  mySendPort.send(isolateReceivePort.sendPort);

  await for (final message in isolateReceivePort) {
    if (message is List) {
      final index = message[0] as int;

      final isolateResponseSendPort = message[1] as SendPort;

      final urls = await ApiService.getVideos(id: index + kPreloadLimit);

      isolateResponseSendPort.send(urls);
    }
  }
}
