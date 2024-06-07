import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class AudioExampleBlock {
  final AssetsAudioPlayer player = AssetsAudioPlayer.newPlayer();
  bool isPlaying = false;
  final _generatePlayEventController = StreamController<void>();
  final _iconStatusController = StreamController<Widget>();

  Sink<void> get play => _generatePlayEventController.sink;
  Stream<Widget> get statusIcon => _iconStatusController.stream;

  final StatusStorage statusStorage;
  final String audioQuestion;
  final double sizeIcon;
  final Color onPrimaryColor;

  AudioExampleBlock({
    required this.statusStorage,
    required this.audioQuestion,
    required this.sizeIcon,
    required this.onPrimaryColor,
  }) {
    player.isPlaying.asBroadcastStream().listen((event) {
      if (isPlaying && !event) {
        _iconStatusController.sink.add(
          Icon(
            Icons.play_arrow,
            size: sizeIcon,
            color: onPrimaryColor,
          ),
        );
      }
    });
    _generatePlayEventController.stream.listen((_) {
      isPlaying = false;
      player.stop();
      player
          .open(
            statusStorage == StatusStorage.onlyOnline
                ? Audio.network(audioQuestion)
                : Audio.file(audioQuestion),
          )
          .whenComplete(() {
            logger.d('is playing ${player.isPlaying.value}');
            if (player.isPlaying.value) {
              isPlaying = true;
              _iconStatusController.sink.add(
                Icon(
                  Icons.music_note,
                  size: sizeIcon,
                  color: onPrimaryColor,
                ),
              );
            }
          })
          .timeout(const Duration(seconds: 10))
          .onError((error, stackTrace) {
            logger.e(error);

            isPlaying = false;
            player.stop();

            _iconStatusController.sink.add(
              Icon(
                Icons.play_arrow,
                size: sizeIcon,
                color: onPrimaryColor,
              ),
            );
          });

      _iconStatusController.sink.add(
        Padding(
          padding: const EdgeInsets.all(13.0),
          child: CircularProgressIndicator(color: onPrimaryColor),
        ),
      );
    });
  }

  void dispose() {
    _generatePlayEventController.close();
    _iconStatusController.close();
  }
}
