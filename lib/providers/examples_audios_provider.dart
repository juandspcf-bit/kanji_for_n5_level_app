import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';

class ExamplesAudiosProvider extends Notifier<ExamplesAudiosData> {
  @override
  ExamplesAudiosData build() {
    final assetAudioPlayer = AssetsAudioPlayer();

    assetAudioPlayer.playlistFinished.listen((event) {
      if (event) {
        setIsPlaying(false);
      }
    });

    assetAudioPlayer.current.listen((event) {
      int track;
      if (event != null) {
        track = event.index;
      } else {
        track = 0;
      }

      logger.d(track);
      state = ExamplesAudiosData(
          track: track,
          isPlaying: state.isPlaying,
          assetsAudioPlayer: state.assetsAudioPlayer);
    });

    return ExamplesAudiosData(
        track: 0, isPlaying: false, assetsAudioPlayer: assetAudioPlayer);
  }

  void setIsPlaying(bool value) {
    state = ExamplesAudiosData(
        track: state.track,
        isPlaying: value,
        assetsAudioPlayer: state.assetsAudioPlayer);
  }

  void setTrack(int value) {
    state = ExamplesAudiosData(
        track: value,
        isPlaying: state.isPlaying,
        assetsAudioPlayer: state.assetsAudioPlayer);
  }

  void onFinish() {
    state.assetsAudioPlayer.playlistFinished.listen((event) {
      if (event) {
        setIsPlaying(false);
      }
    });
  }

  void currenTrack() {
    state.assetsAudioPlayer.current.listen((event) {
      int track;
      if (event != null) {
        track = event.index;
      } else {
        track = 0;
      }

      logger.d(track);
      state = ExamplesAudiosData(
          track: track,
          isPlaying: state.isPlaying,
          assetsAudioPlayer: state.assetsAudioPlayer);
    });
  }

  void initState() {
    state = ExamplesAudiosData(
        track: 0, isPlaying: false, assetsAudioPlayer: state.assetsAudioPlayer);
  }

  void stopAudio() {
    state.assetsAudioPlayer.stop().then((value) => setIsPlaying(false));
  }
}

final examplesAudiosProvider =
    NotifierProvider<ExamplesAudiosProvider, ExamplesAudiosData>(
        ExamplesAudiosProvider.new);

class ExamplesAudiosData {
  final int track;
  final bool isPlaying;
  final AssetsAudioPlayer assetsAudioPlayer;

  ExamplesAudiosData({
    required this.track,
    required this.isPlaying,
    required this.assetsAudioPlayer,
  });
}
