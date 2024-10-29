import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaar_player/features/player/video_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          VideoPage(),
          FeedHeader(),
        ],
      ),
    );
  }
}

class FeedHeader extends StatelessWidget {
  const FeedHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton.filled(
                color: Colors.amber,
                onPressed: () {
                  print('ABC');
                },
                icon: Icon(
                  Icons.abc,
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => print('Tapped InkWell'),
                  onLongPress: () => print('long pressed InkWell'),
                  onDoubleTap: () => print('double Tapped InkWell'),
                  child: SizedBox(
                    width: 60,
                    height: 40,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => print('Tapped pp'),
                onLongPress: () => showModalBottomSheet<void>(
                    context: context,
                    // anchorPoint: Offset(100, 300),
                    // barrierDismissible: true,
                    // semanticsDismissible: true,
                    builder: (context) => Material(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                          child: SizedBox(
                            height: 300,
                            width: double.infinity,
                            // decoration: BoxDecoration(color: Colors.white),
                            child: Column(
                              children: [Text("This is a bottomSheet")],
                            ),
                          ),
                        )),
                onDoubleTap: () => print('double Tapped pp'),
                onVerticalDragEnd: (details) {
                  print(details.localPosition);
                },
                child: Container(
                  width: 60,
                  height: 40,
                  color: Colors.pink,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
