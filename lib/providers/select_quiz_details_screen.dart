import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectQuizDetailsProvider extends Notifier<ScreensQuizDetail> {
  @override
  ScreensQuizDetail build() {
    return ScreensQuizDetail.welcome;
  }

  void setScreen(ScreensQuizDetail screenNumber) {
    state = screenNumber;
  }
}

final selectQuizDetailsProvider =
    NotifierProvider<SelectQuizDetailsProvider, ScreensQuizDetail>(
        SelectQuizDetailsProvider.new);

enum ScreensQuizDetail {
  quizSelections,
  scoreSelections,
  quizFlashCard,
  welcome,
}
