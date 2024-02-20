import 'package:flutter_riverpod/flutter_riverpod.dart';

class VisibleLottieFileProvider extends Notifier<VisibleLottieFileData> {
  @override
  VisibleLottieFileData build() {
    return VisibleLottieFileData(
      opacity: 1.0,
      visibility: true,
    );
  }

  void setOpacity(double opacity) {
    state = VisibleLottieFileData(
      opacity: opacity,
      visibility: state.visibility,
    );
  }

  void setVisibility(bool visibility) {
    state = VisibleLottieFileData(
      opacity: state.opacity,
      visibility: visibility,
    );
  }

  void reset() {
    state = VisibleLottieFileData(
      opacity: 1.0,
      visibility: true,
    );
  }
}

final visibleLottieFileProvider =
    NotifierProvider<VisibleLottieFileProvider, VisibleLottieFileData>(
        VisibleLottieFileProvider.new);

class VisibleLottieFileData {
  VisibleLottieFileData({
    required this.opacity,
    required this.visibility,
  });

  final bool visibility;
  final double opacity;
}
