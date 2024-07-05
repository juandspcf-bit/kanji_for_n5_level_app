import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/video_widget/video_player_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:video_player/video_player.dart';

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
    final videoStatus = ref.watch(videoPlayerObjectProvider);
    final statusConnectionData = ref.watch(statusConnectionProvider);
    videoController.setPlaybackSpeed(videoStatus.speed);
    var opacity = 1.0;
    if (connectionState == ConnectionState.waiting) opacity = 0.0;

    return Column(
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
                              height:
                                  widthCard * videoController.value.aspectRatio,
                              width: widthCard,
                              child: const RepaintBoundary(
                                child: CircularProgressIndicator(
                                  strokeWidth: 8,
                                ),
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
                              height:
                                  widthCard * videoController.value.aspectRatio,
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
                    overlayColor: WidgetStateProperty.all(Colors.black26),
                    backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                  ),
                  onPressed:
                      statusConnectionData == ConnectionStatus.noConnected
                          ? null
                          : () async {
                              /*  */
                              videoController.value.isPlaying
                                  ? videoController.pause().then((value) => ref
                                      .read(videoPlayerObjectProvider.notifier)
                                      .setIsPlaying(false))
                                  : videoController.play().then((value) => ref
                                      .read(videoPlayerObjectProvider.notifier)
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
                  ref.read(videoPlayerObjectProvider.notifier).setSpeed(1.0);
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
                  ref.read(videoPlayerObjectProvider.notifier).setSpeed(0.5);
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
                  ref.read(videoPlayerObjectProvider.notifier).setSpeed(0.25);
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
      ],
    );
  }
}
