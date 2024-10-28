import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jaar_player/core/constants.dart';
import 'package:jaar_player/service/api_service.dart';
import 'package:jaar_player/service/get_videos_isolate.dart';
import 'package:video_player/video_player.dart';

part 'preload_event.dart';
part 'preload_state.dart';
part 'preload_bloc.freezed.dart';

class PreloadBloc extends Bloc<PreloadEvent, PreloadState> {
  PreloadBloc() : super(PreloadState.initial()) {
    on<_SetLoading>(_onSetLoading);
    on<_GetVideosFromApi>(_onGetVideosFromApi);
    on<_OnVideoIndexChanged>(_onVideoIndexChanged);
    on<_UpdateUrls>(_onUpdateUrls);
  }

  FutureOr<void> _onSetLoading(_SetLoading event, Emitter<PreloadState> emit) {
    emit(state.copyWith(isLoading: true));
  }

  Future<void> _onGetVideosFromApi(
    _GetVideosFromApi event,
    Emitter<PreloadState> emit,
  ) async {
    /// Fetch first 5 videos from api
    final List<String> urls = await ApiService.getVideos();
    state.urls.addAll(urls);

    /// Initialize 1st video
    await _initializeControllerAtIndex(0);

    /// Play 1st video
    _playControllerAtIndex(0);

    /// Initialize 2nd video
    await _initializeControllerAtIndex(1);

    emit(state.copyWith(reloadCounter: state.reloadCounter + 1));
  }

  FutureOr<void> _onVideoIndexChanged(
      _OnVideoIndexChanged event, Emitter<PreloadState> emit) {
    /// Condition to fetch new videos
    final bool shouldFetch = (event.index + kPreloadLimit) % kNextLimit == 0 &&
        state.urls.length == event.index + kPreloadLimit;

    if (shouldFetch) {
      createIsolate(event.index);
    }

    /// Next / Prev video decider
    if (event.index > state.focusedIndex) {
      _playNext(event.index);
    } else {
      _playPrevious(event.index);
    }

    emit(state.copyWith(focusedIndex: event.index));
  }

  FutureOr<void> _onUpdateUrls(_UpdateUrls event, Emitter<PreloadState> emit) {}

  void _playNext(int index) {
    /// Stop [index - 1] controller
    _stopControllerAtIndex(index - 1);

    /// Dispose [index - 2] controller
    _disposeControllerAtIndex(index - 2);

    /// Play current video (already initialized)
    _playControllerAtIndex(index);

    /// Initialize [index + 1] controller
    _initializeControllerAtIndex(index + 1);
  }

  void _playPrevious(int index) {
    /// Stop [index + 1] controller
    _stopControllerAtIndex(index + 1);

    /// Dispose [index + 2] controller
    _disposeControllerAtIndex(index + 2);

    /// Play current video (already initialized)
    _playControllerAtIndex(index);

    /// Initialize [index - 1] controller
    _initializeControllerAtIndex(index - 1);
  }

  Future<void> _initializeControllerAtIndex(int index) async {
    if (state.urls.length > index && index >= 0) {
      final uri = Uri.parse(state.urls[index]);

      /// Create new controller
      final controller = VideoPlayerController.networkUrl(uri);
      await controller.setLooping(true);

      /// Add to [controllers] list
      state.controllers[index] = controller;

      /// Initialize
      await controller.initialize();

      log('🚀🚀🚀 INITIALIZED $index');
    }
  }

  void _playControllerAtIndex(int index) {
    if (state.urls.length > index && index >= 0) {
      /// Get controller at [index]
      final controller = state.controllers[index]!;

      /// Play controller
      controller.play();

      log('🚀🚀🚀 PLAYING $index');
    }
  }

  void _stopControllerAtIndex(int index) {
    if (state.urls.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController controller = state.controllers[index]!;

      /// Pause
      controller.pause();

      /// Reset postiton to beginning
      controller.seekTo(const Duration());

      log('🚀🚀🚀 STOPPED $index');
    }
  }

  void _disposeControllerAtIndex(int index) {
    if (state.urls.length > index && index >= 0) {
      /// Get controller at [index]
      final VideoPlayerController? controller = state.controllers[index];

      /// Dispose controller
      controller?.dispose();

      if (controller != null) {
        state.controllers.remove(index);
        // state.controllers.remove(controller);
      }

      log('🚀🚀🚀 DISPOSED $index');
    }
  }
}
