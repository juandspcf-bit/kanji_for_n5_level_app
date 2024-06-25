import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AudioExamplesTrackList extends Notifier<AudioExamplesTrackListData> {
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

final audioExamplesTrackListProvider =
    NotifierProvider<AudioExamplesTrackList, AudioExamplesTrackListData>(
        AudioExamplesTrackList.new);

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
