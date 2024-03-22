import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExamplesAudiosTrackListProvider
    extends Notifier<ExamplesAudiosTrackListData> {
  @override
  ExamplesAudiosTrackListData build() {
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
      state = ExamplesAudiosTrackListData(
          track: track,
          isPlaying: state.isPlaying,
          assetsAudioPlayer: state.assetsAudioPlayer);
    });

    return ExamplesAudiosTrackListData(
        track: 0, isPlaying: false, assetsAudioPlayer: assetAudioPlayer);
  }

  void setIsPlaying(bool value) {
    state = ExamplesAudiosTrackListData(
        track: state.track,
        isPlaying: value,
        assetsAudioPlayer: state.assetsAudioPlayer);
  }
}

final examplesAudiosTrackListProvider = NotifierProvider<
    ExamplesAudiosTrackListProvider,
    ExamplesAudiosTrackListData>(ExamplesAudiosTrackListProvider.new);

class ExamplesAudiosTrackListData {
  final int track;
  final bool isPlaying;
  final AssetsAudioPlayer assetsAudioPlayer;

  ExamplesAudiosTrackListData({
    required this.track,
    required this.isPlaying,
    required this.assetsAudioPlayer,
  });
}
