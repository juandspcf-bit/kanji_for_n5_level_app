import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
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

/*     _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.kanjiFromApi.videoLink))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _videoController.setLooping(true);
          _videoController.play();
        });
      }); */
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
          height: 20,
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
                return SizedBox(
                  height: 370,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Card(
                              surfaceTintColor: Colors.transparent,
                              color: Colors.white,
                              child: SizedBox(
                                height:
                                    230 * _videoController.value.aspectRatio,
                                width: 230,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 200 * _videoController.value.aspectRatio,
                              width: 200,
                              child: AspectRatio(
                                aspectRatio: _videoController.value.aspectRatio,
                                child: VideoPlayer(_videoController),
                              ),
                            ),
                          ),
                        ],
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
                                overlayColor:
                                    MaterialStateProperty.all(Colors.black26),
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary),
                              ),
                              onPressed: () async {
/*                                 _videoController.value.isPlaying;
                                logger.d(_videoController.value.isPlaying);
                                _videoController.pause();
                                _videoController.value.isPlaying; */
                                _videoController.value.isPlaying
                                    ? _videoController.pause()
                                    : _videoController.play();
                              },
                              icon: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  _videoController.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 30,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                _videoController.setPlaybackSpeed(0.5);
                              },
                              child: Text(
                                '0.5X',
                                style: GoogleFonts.chakraPetch(),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
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
