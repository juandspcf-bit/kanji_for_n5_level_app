import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlashCardProvider extends Notifier<FlashCardData> {
  @override
  FlashCardData build() {
    return FlashCardData(indexQuestion: 0, audioQuestion: [], answer: []);
  }
}

void initTheQuiz() {}

class FlashCardData {
  final int indexQuestion;
  final List<String> audioQuestion;
  final List<String> answer;

  FlashCardData(
      {required this.indexQuestion,
      required this.audioQuestion,
      required this.answer});
}
