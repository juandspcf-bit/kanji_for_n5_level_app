import 'package:flutter_riverpod/flutter_riverpod.dart';

class VideoStatusPlaying extends Notifier<({bool isPlaying, double speed})> {
  @override
  ({bool isPlaying, double speed}) build() {
    return (isPlaying: true, speed: 1.0);
  }

  void setIsPlaying(bool value) {
    state = (isPlaying: value, speed: state.speed);
  }

  void setSpeed(double value) {
    state = (isPlaying: state.isPlaying, speed: value);
  }
}

final videoStatusPlaying =
    NotifierProvider<VideoStatusPlaying, ({bool isPlaying, double speed})>(
        VideoStatusPlaying.new);
