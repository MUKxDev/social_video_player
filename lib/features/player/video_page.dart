import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaar_player/features/player/bloc/preload_bloc.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreloadBloc, PreloadState>(
      builder: (context, state) {
        return PageView.builder(
          controller: controller,
          itemCount: state.urls.length,
          scrollDirection: Axis.vertical,
          onPageChanged: (index) => context.read<PreloadBloc>()
            ..add(PreloadEvent.onVideoIndexChanged(index)),
          itemBuilder: (context, index) {
            // Is at end and isLoading
            final isLoading = state.isLoading && index == state.urls.length - 1;

            return AnimatedCrossFade(
              alignment: Alignment.center,
              sizeCurve: Curves.decelerate,
              duration: const Duration(milliseconds: 400),
              firstChild: const Padding(
                padding: EdgeInsets.all(10),
                child: CupertinoActivityIndicator(
                  color: Colors.white,
                  radius: 8,
                ),
              ),
              secondChild: PageView(
                onPageChanged: (i) {
                  state.controllers[index]?.pause();
                },
                children: [
                  SizedBox.expand(
                    child: state.focusedIndex == index
                        ? VideoWidget(
                            isLoading: isLoading,
                            controller: state.controllers[index]!,
                          )
                        : (index >= 0 && index < state.urls.length
                            ? VideoWidget(
                                isLoading: isLoading,
                                controller: state.controllers[index]!,
                              )
                            : const SizedBox()),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              crossFadeState: (isLoading && state.focusedIndex == 0)
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            );

            // : const SizedBox();
          },
        );
      },
    );
  }
}

/// Custom Feed Widget consisting video
class VideoWidget extends StatefulWidget {
  const VideoWidget({
    required this.isLoading,
    required this.controller,
    super.key,
  });

  final bool isLoading;
  final VideoPlayerController controller;

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  void initState() {
    widget.controller.addListener(_onChange);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => widget.controller.value.isPlaying
                ? widget.controller.pause()
                : widget.controller.play(),
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(child: VideoPlayer(widget.controller)),
                    VideoProgressIndicator(
                      widget.controller,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: Colors.orange,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                if (!widget.controller.value.isPlaying)
                  Center(
                    child: Text(
                      'Paused',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(color: Colors.white),
                    ),
                  )
                else
                  const SizedBox(),
              ],
            ),
          ),
        ),

        // Loader
        AnimatedCrossFade(
          alignment: Alignment.bottomCenter,
          sizeCurve: Curves.decelerate,
          duration: const Duration(milliseconds: 400),
          firstChild: const Padding(
            padding: EdgeInsets.all(10),
            child: CupertinoActivityIndicator(
              color: Colors.white,
              radius: 8,
            ),
          ),
          secondChild: const SizedBox(),
          crossFadeState: widget.isLoading
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
        ),
      ],
    );
  }

  void _onChange() {
    setState(() {});
  }
}
