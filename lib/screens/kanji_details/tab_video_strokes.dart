import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/providers/video_status_playing.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/strokes_images.dart';
import 'package:kanji_for_n5_level_app/screens/main_content.dart';
import 'package:video_player/video_player.dart';

class TabVideoStrokes extends ConsumerStatefulWidget {
  const TabVideoStrokes({
    super.key,
    required this.kanjiFromApi,
    required this.statusStorage,
  });

  final KanjiFromApi kanjiFromApi;
  final StatusStorage statusStorage;

  @override
  ConsumerState<TabVideoStrokes> createState() => _TabVideoStrokes();
}

class _TabVideoStrokes extends ConsumerState<TabVideoStrokes> {
  late VideoPlayerController _videoController;
  late Future<void> initializadedVideoPlayer;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.kanjiFromApi.videoLink));
    initializadedVideoPlayer = _videoController.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.pause();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        FutureBuilder(
            future: initializadedVideoPlayer,
            builder: (ctx, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: 370,
                  child: Center(
                    child: SizedBox(
                        height: 100 * _videoController.value.aspectRatio,
                        width: 100,
                        child: const CircularProgressIndicator()),
                  ),
                );
              } else if (snapShot.connectionState == ConnectionState.done) {
                _videoController.setLooping(true);
                _videoController.play();
                return VideoSection(
                  videoController: _videoController,
                );
              } else {
                return const Placeholder();
              }
            }),
        const Divider(
          height: 4,
        ),
        StrokesImages(
          kanjiFromApi: widget.kanjiFromApi,
          statusStorage: widget.statusStorage,
        ),
      ],
    );
  }
}

class VideoSection extends ConsumerStatefulWidget {
  const VideoSection({
    super.key,
    required this.videoController,
  });

  final VideoPlayerController videoController;

  @override
  ConsumerState<VideoSection> createState() => _VideoSection();
}

class _VideoSection extends ConsumerState<VideoSection> {
  @override
  Widget build(BuildContext context) {
    final videoStatus = ref.watch(videoStatusPlaying);
    widget.videoController.setPlaybackSpeed(videoStatus.speed);
    return Column(
      children: [
        LayoutBuilder(
          builder: (ctx, constrains) {
            final widthCard = (constrains.maxWidth * 0.6);
            final widthVideo = widthCard - 30;
            return Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Card(
                    surfaceTintColor: Colors.transparent,
                    color: Colors.white,
                    child: SizedBox(
                      height:
                          widthCard * widget.videoController.value.aspectRatio,
                      width: widthCard,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height:
                        widthVideo * widget.videoController.value.aspectRatio,
                    width: widthVideo,
                    child: AspectRatio(
                      aspectRatio: widget.videoController.value.aspectRatio,
                      child: VideoPlayer(widget.videoController),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.black26),
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primary),
                ),
                onPressed: () async {
/*  */
                  widget.videoController.value.isPlaying
                      ? widget.videoController.pause().then((value) => ref
                          .read(videoStatusPlaying.notifier)
                          .setIsPlaying(false))
                      : widget.videoController.play().then((value) => ref
                          .read(videoStatusPlaying.notifier)
                          .setIsPlaying(true));
                },
                icon: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    videoStatus.isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 30,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(videoStatusPlaying.notifier).setSpeed(1.0);
              },
              child: Text(
                '1.0X',
                style: GoogleFonts.chakraPetch(),
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(videoStatusPlaying.notifier).setSpeed(0.5);
              },
              child: Text(
                '0.5X',
                style: GoogleFonts.chakraPetch(),
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(videoStatusPlaying.notifier).setSpeed(0.25);
              },
              child: Text(
                '0.25X',
                style: GoogleFonts.chakraPetch(),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
