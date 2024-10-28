import 'dart:isolate';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaar_player/core/build_context.dart';
import 'package:jaar_player/core/constants.dart';
import 'package:jaar_player/features/player/bloc/preload_bloc.dart';
import 'package:jaar_player/service/api_service.dart';

/// Isolate to fetch videos in the background so that the video experience is not disturbed.
/// Without isolate, the video will be paused whenever there is an API call
/// because the main thread will be busy fetching new video URLs.
///
/// https://blog.codemagic.io/understanding-flutter-isolates/
Future<void> createIsolate(int index) async {
  // Set loading to true
  BlocProvider.of<PreloadBloc>(context, listen: false)
      .add(PreloadEvent.setLoading());

  ReceivePort mainReceivePort = ReceivePort();

  Isolate.spawn<SendPort>(getVideosTask, mainReceivePort.sendPort);

  SendPort isolateSendPort = await mainReceivePort.first as SendPort;

  ReceivePort isolateResponseReceivePort = ReceivePort();

  isolateSendPort.send([index, isolateResponseReceivePort.sendPort]);

  final isolateResponse = await isolateResponseReceivePort.first;
  final _urls = isolateResponse as List<String>;

  // Update new urls
  BlocProvider.of<PreloadBloc>(context, listen: false)
      .add(PreloadEvent.updateUrls(_urls));
}

void getVideosTask(SendPort mySendPort) async {
  ReceivePort isolateReceivePort = ReceivePort();

  mySendPort.send(isolateReceivePort.sendPort);

  await for (var message in isolateReceivePort) {
    if (message is List) {
      final int index = message[0] as int;

      final SendPort isolateResponseSendPort = message[1] as SendPort;

      final List<String> _urls =
          await ApiService.getVideos(id: index + kPreloadLimit);

      isolateResponseSendPort.send(_urls);
    }
  }
}
