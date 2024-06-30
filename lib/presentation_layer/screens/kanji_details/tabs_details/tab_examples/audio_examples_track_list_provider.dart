import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "audio_examples_track_list_provider.g.dart";

@Riverpod(keepAlive: false)
class AudioExamplesTrackList extends _$AudioExamplesTrackList {
  @override
  AudioExamplesTrackListData build() {
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

      //logger.d(track);
      state = AudioExamplesTrackListData(
          track: track,
          isPlaying: state.isPlaying,
          assetsAudioPlayer: state.assetsAudioPlayer);
    });

    return AudioExamplesTrackListData(
        track: 0, isPlaying: false, assetsAudioPlayer: assetAudioPlayer);
  }

  void setIsPlaying(bool value) {
    state = AudioExamplesTrackListData(
        track: state.track,
        isPlaying: value,
        assetsAudioPlayer: state.assetsAudioPlayer);
  }
}

class AudioExamplesTrackListData {
  final int track;
  final bool isPlaying;
  final AssetsAudioPlayer assetsAudioPlayer;

  AudioExamplesTrackListData({
    required this.track,
    required this.isPlaying,
    required this.assetsAudioPlayer,
  });
}
