import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/providers/video_status_playing.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/error_connection_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/image_meaning_kanji.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs/meaning_definition.dart';
import 'package:video_player/video_player.dart';

class TabVideoStrokes extends ConsumerWidget {
  const TabVideoStrokes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityData = ref.watch(statusConnectionProvider);
    final kanjiFromApi = ref.watch(kanjiDetailsProvider)!.kanjiFromApi;

    return connectivityData == ConnectionStatus.noConnected &&
            kanjiFromApi.statusStorage == StatusStorage.onlyOnline
        ? const ErrorConnectionDetailsScreen()
        : SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const VideoWrapper(),
                const SizedBox(
                  height: 10,
                ),
                MeaningAndDefinition(
                  englishMeaning: kanjiFromApi.englishMeaning,
                  hiraganaRomaji: kanjiFromApi.hiraganaRomaji,
                  hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
                  katakanaRomaji: kanjiFromApi.katakanaRomaji,
                  katakanaMeaning: kanjiFromApi.katakanaMeaning,
                ),
                const ImageMeaningKanji(),
              ],
            ),
          );
  }
}

class VideoWrapper extends ConsumerStatefulWidget {
  const VideoWrapper({super.key});

  @override
  ConsumerState<VideoWrapper> createState() => _VideoWrapperState();
}

class _VideoWrapperState extends ConsumerState<VideoWrapper> {
  late VideoPlayerController _videoController;
  late Future<void> initializadedVideoPlayer;

  @override
  void initState() {
    super.initState();
    final kanjiDetailsData = ref.read(kanjiDetailsProvider);
    _videoController = VideoPlayerController.networkUrl(
        Uri.parse(kanjiDetailsData!.kanjiFromApi.videoLink));
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
    return FutureBuilder(
      future: initializadedVideoPlayer,
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

class VideoSection extends ConsumerWidget {
  const VideoSection({
    super.key,
    required this.videoController,
    required this.connectionState,
    required this.hasError,
  });

  final VideoPlayerController videoController;
  final ConnectionState connectionState;
  final bool hasError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoStatus = ref.watch(videoStatusPlaying);
    videoController.setPlaybackSpeed(videoStatus.speed);
    var opacity = 1.0;
    if (connectionState == ConnectionState.waiting) opacity = 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(221, 62, 61, 64),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LayoutBuilder(
            builder: (ctx, constrains) {
              final widthCard = (constrains.maxWidth * 0.5);
              final widthVideo = widthCard - 30;
              return Stack(
                alignment: Alignment.center,
                children: connectionState == ConnectionState.done && !hasError
                    ? [
                        Align(
                          alignment: Alignment.center,
                          child: Card(
                            surfaceTintColor: Colors.transparent,
                            color: Colors.white,
                            child: SizedBox(
                              height:
                                  widthCard * videoController.value.aspectRatio,
                              width: widthCard,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height:
                                widthVideo * videoController.value.aspectRatio,
                            width: widthVideo,
                            child: AspectRatio(
                              aspectRatio: videoController.value.aspectRatio,
                              child: VideoPlayer(videoController),
                            ),
                          ),
                        ),
                      ]
                    : [
                        if (connectionState == ConnectionState.waiting)
                          Align(
                            alignment: Alignment.center,
                            child: Card(
                              shadowColor: Colors.transparent,
                              surfaceTintColor: Colors.transparent,
                              color: Colors.transparent,
                              child: SizedBox(
                                height: widthCard *
                                    videoController.value.aspectRatio,
                                width: widthCard,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 8,
                                ),
                              ),
                            ),
                          )
                        else
                          Align(
                            alignment: Alignment.center,
                            child: Card(
                              shadowColor: Colors.transparent,
                              surfaceTintColor: Colors.transparent,
                              color: Colors.transparent,
                              child: SizedBox(
                                height: widthCard *
                                    videoController.value.aspectRatio,
                                width: widthCard,
                                child: const Icon(
                                  Icons.error,
                                  color: Colors.amberAccent,
                                ),
                              ),
                            ),
                          )
                      ],
              );
            },
          ),
          Opacity(
            opacity: opacity,
            child: Row(
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
                      videoController.value.isPlaying
                          ? videoController.pause().then((value) => ref
                              .read(videoStatusPlaying.notifier)
                              .setIsPlaying(false))
                          : videoController.play().then((value) => ref
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
                    style: GoogleFonts.chakraPetch(
                        color: videoStatus.speed == 1.0
                            ? Colors.amber
                            : Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(videoStatusPlaying.notifier).setSpeed(0.5);
                  },
                  child: Text(
                    '0.5X',
                    style: GoogleFonts.chakraPetch(
                        color: videoStatus.speed == 0.5
                            ? Colors.amber
                            : Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref.read(videoStatusPlaying.notifier).setSpeed(0.25);
                  },
                  child: Text(
                    '0.25X',
                    style: GoogleFonts.chakraPetch(
                        color: videoStatus.speed == 0.25
                            ? Colors.amber
                            : Theme.of(context).colorScheme.onPrimaryContainer),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
