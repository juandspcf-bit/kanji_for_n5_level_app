import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/flash_card_widget_provider.dart';

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

  void selectScreen() {
    if (state.selectedOption == 0) {
      setScreen(ScreensQuizDetail.quizSelections);
    } else if (state.selectedOption == 1) {
      ref.read(flashCardWidgetProvider.notifier).restartSide();
      setScreen(ScreensQuizDetail.quizFlashCard);
    }
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
