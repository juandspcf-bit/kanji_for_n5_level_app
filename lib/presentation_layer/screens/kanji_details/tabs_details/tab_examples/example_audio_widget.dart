import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class AudioExampleButtonWidget extends StatefulWidget {
  const AudioExampleButtonWidget({
    super.key,
    required this.sizeOval,
    required this.sizeIcon,
    required this.statusStorage,
    required this.audioQuestion,
    required this.onPrimaryColor,
  });

  final double sizeOval;
  final double sizeIcon;
  final StatusStorage statusStorage;
  final String audioQuestion;

  final Color onPrimaryColor;

  @override
  State<AudioExampleButtonWidget> createState() =>
      _AudioExampleButtonWidgetState();
}

class _AudioExampleButtonWidgetState extends State<AudioExampleButtonWidget> {
  final AssetsAudioPlayer player = AssetsAudioPlayer.newPlayer();
  bool isPlaying = false;
  late Widget iconStatus;
  @override
  void initState() {
    super.initState();

    iconStatus = Icon(
      Icons.play_arrow,
      size: widget.sizeIcon,
      color: widget.onPrimaryColor,
    );

    player.isPlaying.asBroadcastStream().listen((event) {
      if (isPlaying && !event) {
        setState(() {
          iconStatus = Icon(
            Icons.play_arrow,
            size: widget.sizeIcon,
            color: widget.onPrimaryColor,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return ClipOval(
          child: SizedBox(
            width: widget.sizeOval,
            height: widget.sizeOval,
            child: Material(
              color: Theme.of(context).colorScheme.primary,
              child: InkWell(
                splashColor: Colors.black38,
                onTap: () {
                  isPlaying = false;
                  player.stop();
                  player
                      .open(
                        widget.statusStorage == StatusStorage.onlyOnline
                            ? Audio.network(widget.audioQuestion)
                            : Audio.file(widget.audioQuestion),
                      )
                      .whenComplete(() {
                        logger.d('is playing ${player.isPlaying.value}');
                        if (player.isPlaying.value) {
                          isPlaying = true;
                          setState(() {
                            iconStatus = Icon(
                              Icons.music_note,
                              size: widget.sizeIcon,
                              color: widget.onPrimaryColor,
                            );
                          });
                        }
                      })
                      .timeout(const Duration(seconds: 10))
                      .onError((error, stackTrace) {
                        logger.e(error);
                        setState(() {
                          isPlaying = false;
                          player.stop();
                          iconStatus = Icon(
                            Icons.play_arrow,
                            size: widget.sizeIcon,
                            color: widget.onPrimaryColor,
                          );
                        });
                      });
                  setState(() {
                    iconStatus = Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: CircularProgressIndicator(
                          color: widget.onPrimaryColor),
                    );
                  });
                },
                child: iconStatus,
              ),
            ),
          ),
        );
      },
    );
  }
}
