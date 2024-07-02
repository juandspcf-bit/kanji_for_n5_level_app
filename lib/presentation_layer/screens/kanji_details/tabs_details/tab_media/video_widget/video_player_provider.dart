/* import 'dart:io';

import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';

part 'video_player_provider.g.dart';

@Riverpod(keepAlive: false)
class VideoPlayerObject extends _$VideoPlayerObject {
  @override
  ({VideoPlayerController videoPlayerController}) build() {
    final kanjiDetailsData = ref.read(kanjiDetailsProvider);
    VideoPlayerController videoController;

    if (kanjiDetailsData!.statusStorage == StatusStorage.onlyOnline) {
      videoController = VideoPlayerController.networkUrl(
          Uri.parse(kanjiDetailsData.kanjiFromApi.videoLink));
    } else {
      videoController = VideoPlayerController.file(
          File(kanjiDetailsData.kanjiFromApi.videoLink));
    }

    ref.onDispose(() {
      logger.d("disposed");
      videoController.dispose();
    });
    return (videoPlayerController: videoController);
  }
} */
