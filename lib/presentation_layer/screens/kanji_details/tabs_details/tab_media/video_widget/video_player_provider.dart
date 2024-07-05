import 'dart:io';

import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';

part 'video_player_provider.g.dart';

@Riverpod(keepAlive: false)
class VideoPlayerObject extends _$VideoPlayerObject {
  @override
  ({
    VideoPlayerController? videoPlayerController,
    Future<void> initializedVideoPlayer,
    bool isPlaying,
    double speed,
  }) build() {
    final kanjiDetailsData = ref.read(kanjiDetailsProvider);

    late VideoPlayerController videoController;
    late Future<void> initializedVideoPlayer;

    if (kanjiDetailsData!.statusStorage == StatusStorage.onlyOnline) {
      videoController = VideoPlayerController.networkUrl(
          Uri.parse(kanjiDetailsData.kanjiFromApi.videoLink));
    } else {
      videoController = VideoPlayerController.file(
          File(kanjiDetailsData.kanjiFromApi.videoLink));
    }

    initializedVideoPlayer = videoController.initialize();

    ref.onDispose(
      () {
        videoController.pause();
        videoController.dispose();
      },
    );

    logger.d("reset build provider");

    return (
      videoPlayerController: videoController,
      initializedVideoPlayer: initializedVideoPlayer,
      isPlaying: true,
      speed: 1.0,
    );
  }

  void setIsPlaying(bool value) {
    state = (
      videoPlayerController: state.videoPlayerController,
      initializedVideoPlayer: state.initializedVideoPlayer,
      isPlaying: value,
      speed: state.speed
    );
  }

  void setSpeed(double value) {
    state = (
      videoPlayerController: state.videoPlayerController,
      initializedVideoPlayer: state.initializedVideoPlayer,
      isPlaying: state.isPlaying,
      speed: value,
    );
  }
}
