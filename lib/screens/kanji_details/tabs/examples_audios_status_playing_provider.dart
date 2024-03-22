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

  void setTapedPlay(int index) {
    final copyList = [...state.isTappedForPlaying];
    copyList[index] = !copyList[index];
    state = ExamplesAudiosPlayingAudioData(isTappedForPlaying: copyList);
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

  ExamplesAudiosPlayingAudioData({
    required this.isTappedForPlaying,
  });
}
