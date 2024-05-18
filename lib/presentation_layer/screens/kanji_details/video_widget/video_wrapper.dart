import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/video_widget/video_section.dart';
import 'package:video_player/video_player.dart';

class VideoWrapper extends ConsumerStatefulWidget {
  const VideoWrapper({super.key});

  @override
  ConsumerState<VideoWrapper> createState() => _VideoWrapperState();
}

class _VideoWrapperState extends ConsumerState<VideoWrapper> {
  late VideoPlayerController _videoController;
  late Future<void> initializedVideoPlayer;

  @override
  void initState() {
    super.initState();
    final kanjiDetailsData = ref.read(kanjiDetailsProvider);
    _videoController = VideoPlayerController.networkUrl(
        Uri.parse(kanjiDetailsData!.kanjiFromApi.videoLink));
    initializedVideoPlayer = _videoController.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.pause();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializedVideoPlayer,
      builder: (ctx, snapShot) {
        if (snapShot.connectionState == ConnectionState.done &&
            !snapShot.hasError) {
          _videoController.setLooping(true);
          _videoController.play();
        }
        return VideoSection(
          videoController: _videoController,
          connectionState: snapShot.connectionState,
          hasError: snapShot.hasError,
        );
      },
    );
  }
}
