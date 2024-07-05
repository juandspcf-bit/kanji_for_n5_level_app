import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/video_widget/video_player_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/video_widget/video_section.dart';

class VideoWrapper extends ConsumerWidget {
  const VideoWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoPlayerController = ref.watch(videoPlayerObjectProvider);
    logger.d("reset build");
    return FutureBuilder(
      future: videoPlayerController.initializedVideoPlayer,
      builder: (ctx, snapShot) {
        if (snapShot.connectionState == ConnectionState.done &&
            !snapShot.hasError) {
          videoPlayerController.videoPlayerController!.setLooping(true);
          if (videoPlayerController.isPlaying) {
            videoPlayerController.videoPlayerController!.play();
          }
          videoPlayerController.videoPlayerController!
              .setPlaybackSpeed(videoPlayerController.speed);
        }
        return VideoSection(
          videoController: videoPlayerController.videoPlayerController!,
          connectionState: snapShot.connectionState,
          hasError: snapShot.hasError,
        );
      },
    );
  }
}
