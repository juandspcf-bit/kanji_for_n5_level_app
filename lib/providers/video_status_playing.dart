import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';

part 'video_status_playing.g.dart';

@Riverpod(keepAlive: false)
class VideoStatusPlaying extends _$VideoStatusPlaying {
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

class VideoStatus {
  final VideoPlayerController videoController;
  final bool isPlaying;
  final double speed;

  VideoStatus(
      {required this.videoController,
      required this.isPlaying,
      required this.speed});
}
