import 'package:jaar_player/core/constants.dart';

class ApiService {
  static final List<String> _videos = [
    "https://videos.pexels.com/video-files/8327350/8327350-uhd_1440_2560_30fps.mp4",
    "https://videos.pexels.com/video-files/4114797/4114797-uhd_2560_1440_25fps.mp4",
    "https://videos.pexels.com/video-files/5532765/5532765-uhd_1440_2732_25fps.mp4",
    "https://videos.pexels.com/video-files/5532771/5532771-uhd_1440_2732_25fps.mp4",
    "https://videos.pexels.com/video-files/4620573/4620573-uhd_1440_2732_25fps.mp4",
    "https://videos.pexels.com/video-files/6150148/6150148-hd_1080_1920_30fps.mp4",
    "https://videos.pexels.com/video-files/6127664/6127664-uhd_1440_2732_25fps.mp4",
    "https://videos.pexels.com/video-files/5532873/5532873-uhd_1440_2732_25fps.mp4",
    "https://videos.pexels.com/video-files/7222357/7222357-uhd_1440_2732_25fps.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
    "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4"
  ];

  /// Simulate api call
  static Future<List<String>> getVideos({int id = 0}) async {
    // No more videos
    if (id >= _videos.length) {
      return [];
    }

    await Future<void>.delayed(const Duration(seconds: kLatency));

    if (id + kNextLimit >= _videos.length) {
      return _videos.sublist(id, _videos.length);
    }

    return _videos.sublist(id, id + kNextLimit);
  }
}
