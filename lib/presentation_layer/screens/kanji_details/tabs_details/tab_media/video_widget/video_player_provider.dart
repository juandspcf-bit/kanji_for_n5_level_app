import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:video_player/video_player.dart';

part 'video_player_provider.g.dart';

@Riverpod(keepAlive: true)
class VideoPlayerObject extends _$VideoPlayerObject {
  @override
  ({VideoPlayerController? videoPlayerController}) build() {
    return (videoPlayerController: null);
  }

  void setController(VideoPlayerController? controller) {
    state = (videoPlayerController: controller);
  }
}
