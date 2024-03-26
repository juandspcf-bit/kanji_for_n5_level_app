import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class ExampleAudio extends StatefulWidget {
  const ExampleAudio({
    super.key,
    required this.example,
    required this.track,
    required this.index,
    required this.isPlaying,
    required this.statusStorage,
  });

  final Example example;
  final int track;
  final int index;
  final bool isPlaying;
  final StatusStorage statusStorage;

  @override
  State<ExampleAudio> createState() => _ExampleAudioState();
}

class _ExampleAudioState extends State<ExampleAudio> {
  final AssetsAudioPlayer player = AssetsAudioPlayer.newPlayer();
  bool isTaped = false;
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return ClipOval(
          child: SizedBox(
            width: 50,
            height: 50,
            child: Material(
              color: Theme.of(context).colorScheme.primary,
              child: InkWell(
                splashColor: Colors.black38,
                onTap: () async {
                  isPlaying = false;
                  player.stop();
                  player
                      .open(
                    widget.statusStorage == StatusStorage.onlyOnline
                        ? Audio.network(widget.example.audio.mp3)
                        : Audio.file(widget.example.audio.mp3),
                  )
                      .whenComplete(() {
                    logger.d('is playing ${player.isPlaying.value}');
                    isPlaying = true;
                    isTaped = false;
                  });
                  setState(() {
                    isTaped = true;
                  });
                },
                child: widget.track == widget.index && widget.isPlaying
                    ? Icon(
                        Icons.music_note,
                        size: 30,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    : StreamBuilder(
                        stream: player.isPlaying.asBroadcastStream(),
                        builder: (context, asyncSnapshot) {
                          if (asyncSnapshot.hasError) {
                            logger.e('error stream');
                            return Icon(
                              Icons.play_arrow_rounded,
                              size: 30,
                              color: Theme.of(context).colorScheme.onPrimary,
                            );
                          }

                          logger.d(
                              'what is the value ${asyncSnapshot.data ?? -1}');

                          if (asyncSnapshot.data == null) {
                            return Icon(
                              Icons.play_arrow_rounded,
                              size: 30,
                              color: Theme.of(context).colorScheme.onPrimary,
                            );
                          }
                          final bool isPlaying = asyncSnapshot.data!;

                          if (isTaped && !isPlaying) {
                            return Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            );
                          }

                          return Icon(
                            isPlaying
                                ? Icons.music_note
                                : Icons.play_arrow_rounded,
                            size: 30,
                            color: Theme.of(context).colorScheme.onPrimary,
                          );
                        }),
              ),
            ),
          ),
        );
      },
    );
  }
}
