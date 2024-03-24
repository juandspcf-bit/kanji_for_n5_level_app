import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class ExamplesAudiosStatusPlayingProvider
    extends Notifier<ExamplesAudiosPlayingAudioData> {
  @override
  ExamplesAudiosPlayingAudioData build() {
    return ExamplesAudiosPlayingAudioData(
        isTappedForPlaying: [], audioPlayers: [], paths: []);
  }

  void setInitList(KanjiFromApi kanjiFromApi) {
    final isTappedForPlaying =
        List.generate(kanjiFromApi.example.length, (index) => false);
    final audioPlayers = List.generate(
        kanjiFromApi.example.length, (index) => AssetsAudioPlayer());
    final paths = kanjiFromApi.example.map((e) => e.audio.mp3).toList();

    state = ExamplesAudiosPlayingAudioData(
        isTappedForPlaying: isTappedForPlaying,
        audioPlayers: audioPlayers,
        paths: paths);
  }

  void setTapedPlay(int index, StatusStorage statusStorage) {
    final copyIsTappedForPlaying = [...state.isTappedForPlaying];
    if (copyIsTappedForPlaying[index]) {
      return;
    }
    copyIsTappedForPlaying[index] = true;

    final copyAudioPlayers = [...state.audioPlayers];

    if (copyIsTappedForPlaying[index]) {
      if (statusStorage == StatusStorage.onlyOnline) {
        try {
          copyAudioPlayers[index]
              .open(Audio.network(state.paths[index]))
              .timeout(const Duration(seconds: 10))
              .whenComplete(
            () {
              copyIsTappedForPlaying[index] = false;
              state = ExamplesAudiosPlayingAudioData(
                isTappedForPlaying: copyIsTappedForPlaying,
                audioPlayers: copyAudioPlayers,
                paths: state.paths,
              );
            },
          );
        } on TimeoutException {
          copyIsTappedForPlaying[index] = false;
          copyAudioPlayers[index].stop();
          state = ExamplesAudiosPlayingAudioData(
            isTappedForPlaying: copyIsTappedForPlaying,
            audioPlayers: copyAudioPlayers,
            paths: state.paths,
          );
          logger.e('time delay'); // Prints "throws" after 2 seconds.
        } catch (e) {
          copyIsTappedForPlaying[index] = false;
          copyAudioPlayers[index].stop();
          state = ExamplesAudiosPlayingAudioData(
            isTappedForPlaying: copyIsTappedForPlaying,
            audioPlayers: copyAudioPlayers,
            paths: state.paths,
          );
          logger.e(e);
        }
      } else {
        try {
          copyAudioPlayers[index]
              .open(Audio.file(state.paths[index]))
              .timeout(const Duration(seconds: 10))
              .whenComplete(
            () {
              copyIsTappedForPlaying[index] = false;
              state = ExamplesAudiosPlayingAudioData(
                isTappedForPlaying: copyIsTappedForPlaying,
                audioPlayers: copyAudioPlayers,
                paths: state.paths,
              );
            },
          );
        } catch (e) {
          copyAudioPlayers[index].stop();
          copyIsTappedForPlaying[index] = false;
          state = ExamplesAudiosPlayingAudioData(
            isTappedForPlaying: copyIsTappedForPlaying,
            audioPlayers: copyAudioPlayers,
            paths: state.paths,
          );
          logger.e(e);
        }
      }
    }
    state = ExamplesAudiosPlayingAudioData(
        isTappedForPlaying: copyIsTappedForPlaying,
        audioPlayers: copyAudioPlayers,
        paths: state.paths);
  }

  void resetTapStatus(
    List<bool> copyIsTappedForPlaying,
    int index,
    List<AssetsAudioPlayer> copyAudioPlayers,
  ) {
    state = ExamplesAudiosPlayingAudioData(
      isTappedForPlaying: copyIsTappedForPlaying,
      audioPlayers: copyAudioPlayers,
      paths: state.paths,
    );
  }

  bool getTapedPlay(int index) {
    return state.isTappedForPlaying[index];
  }
}

final examplesAudiosPlayingAudioProvider = NotifierProvider<
    ExamplesAudiosStatusPlayingProvider,
    ExamplesAudiosPlayingAudioData>(ExamplesAudiosStatusPlayingProvider.new);

class ExamplesAudiosPlayingAudioData {
  final List<bool> isTappedForPlaying;
  final List<AssetsAudioPlayer> audioPlayers;
  final List<String> paths;

  ExamplesAudiosPlayingAudioData({
    required this.isTappedForPlaying,
    required this.audioPlayers,
    required this.paths,
  });
}
