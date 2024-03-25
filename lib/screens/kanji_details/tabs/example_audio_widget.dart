import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

class ExampleAudio extends StatefulWidget {
  const ExampleAudio({
    super.key,
    required this.example,
    required this.track,
    required this.index,
    required this.isPlaying,
  });

  final Example example;
  final int track;
  final int index;
  final bool isPlaying;

  @override
  State<ExampleAudio> createState() => _ExampleAudioState();
}

class _ExampleAudioState extends State<ExampleAudio> {
  final AssetsAudioPlayer player = AssetsAudioPlayer.newPlayer();
  bool isTaped = false;

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
                  player.open(Audio.network(widget.example.audio.mp3));

                  isTaped = true;
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

                          if (asyncSnapshot.data == null) {
                            return Icon(
                              Icons.play_arrow_rounded,
                              size: 30,
                              color: Theme.of(context).colorScheme.onPrimary,
                            );
                          }
                          final bool isPlaying = asyncSnapshot.data!;

                          if (isTaped && isPlaying) {
                            return Padding(
                                padding: const EdgeInsets.all(13.0),
                                child: Icon(
                                  Icons.music_note,
                                  size: 30,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ));
                          }

                          if (isTaped && !isPlaying) {
                            return Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: CircularProgressIndicator(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            );
                          }

                          return Icon(
                            Icons.play_arrow_rounded,
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
