import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectQuizDetailsProvider extends Notifier<SelectQuizDetailsData> {
  @override
  SelectQuizDetailsData build() {
    return SelectQuizDetailsData(
        selectedOption: 2, screensQuizDetail: ScreensQuizDetail.welcome);
  }

  void setScreen(ScreensQuizDetail screenNumber) {
    state = SelectQuizDetailsData(
        selectedOption: state.selectedOption, screensQuizDetail: screenNumber);
  }

  void setOption(int? value) {
    state = SelectQuizDetailsData(
        selectedOption: value ?? 2, screensQuizDetail: state.screensQuizDetail);
  }
}

final selectQuizDetailsProvider =
    NotifierProvider<SelectQuizDetailsProvider, SelectQuizDetailsData>(
        SelectQuizDetailsProvider.new);

class SelectQuizDetailsData {
  final ScreensQuizDetail screensQuizDetail;
  final int selectedOption;

  SelectQuizDetailsData(
      {required this.screensQuizDetail, required this.selectedOption});
}

enum ScreensQuizDetail {
  quizSelections,
  scoreSelections,
  quizFlashCard,
  welcome,
}
