import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExamplesAudiosStatusPlayingProvider
    extends Notifier<ExamplesAudiosPlayingAudioData> {
  @override
  ExamplesAudiosPlayingAudioData build() {
    return ExamplesAudiosPlayingAudioData(isTappedForPlaying: []);
  }

  void setInitList(List<bool> isTappedForPlaying) {
    state =
        ExamplesAudiosPlayingAudioData(isTappedForPlaying: isTappedForPlaying);
  }
}

final examplesAudiosPlayingAudioProvider = NotifierProvider<
    ExamplesAudiosStatusPlayingProvider,
    ExamplesAudiosPlayingAudioData>(ExamplesAudiosStatusPlayingProvider.new);

class ExamplesAudiosPlayingAudioData {
  final List<bool> isTappedForPlaying;

  ExamplesAudiosPlayingAudioData({
    required this.isTappedForPlaying,
  });
}
