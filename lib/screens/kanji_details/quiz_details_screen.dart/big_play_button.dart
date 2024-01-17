import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/providers/video_status_playing.dart';

class BigPlayButton extends ConsumerWidget {
  BigPlayButton({
    super.key,
    required this.sizeOval,
    required this.sizeIcon,
    required this.statusStorage,
    required this.audioQuestion,
  });

  final double sizeOval;
  final double sizeIcon;
  final StatusStorage statusStorage;
  final String audioQuestion;

  final assetsAudioPlayer = AssetsAudioPlayer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipOval(
      child: SizedBox(
        width: sizeOval,
        height: sizeOval,
        child: Material(
          color: Theme.of(context).colorScheme.primary,
          child: InkWell(
            splashColor: Colors.black38,
            onTap: () async {
              ref.read(videoStatusPlaying.notifier).setIsPlaying(false);

              try {
                if (statusStorage == StatusStorage.onlyOnline) {
                  await assetsAudioPlayer.open(
                    Audio.network(audioQuestion),
                  );
                } else if (statusStorage == StatusStorage.stored) {
                  await assetsAudioPlayer.open(
                    Audio.file(audioQuestion),
                  );
                }
              } catch (t) {
                //mp3 unreachable
              }
            },
            child: StreamBuilder(
                stream: assetsAudioPlayer.isPlaying,
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.data == null) {
                    return Icon(
                      Icons.play_arrow_rounded,
                      size: sizeIcon,
                      color: Theme.of(context).colorScheme.onPrimary,
                    );
                  }
                  final bool isPlaying = asyncSnapshot.data!;
                  return Icon(
                    isPlaying ? Icons.music_note : Icons.play_arrow_rounded,
                    size: sizeIcon,
                    color: Theme.of(context).colorScheme.onPrimary,
                  );
                }),
          ),
        ),
      ),
    );
  }
}
