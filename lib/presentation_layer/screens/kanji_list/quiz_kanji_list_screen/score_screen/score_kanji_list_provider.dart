import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/quiz_details_provider.dart';

class KanjiListScoreProvider extends Notifier<
    ({
      List<StateAnswersQuizDetails> correctAnswers,
      List<StateAnswersQuizDetails> incorrectAnwers,
      List<StateAnswersQuizDetails> omitted
    })> {
  @override
  ({
    List<StateAnswersQuizDetails> correctAnswers,
    List<StateAnswersQuizDetails> incorrectAnwers,
    List<StateAnswersQuizDetails> omitted,
  }) build() {
    return (
      correctAnswers: [],
      incorrectAnwers: [],
      omitted: [],
    );
  }

  void setAnswers(
    List<bool> isCorrectAnswer,
    List<bool> isOmittedAnswer,
  ) {
    final List<StateAnswersQuizDetails> incorrectAnwers = [];
    for (var i = 0; i < isCorrectAnswer.length; i++) {
      if (!isCorrectAnswer[i] && !isOmittedAnswer[i]) {
        incorrectAnwers.add(StateAnswersQuizDetails.incorrect);
      }
    }

    state = (
      correctAnswers: isCorrectAnswer
          .where((e) => e)
          .map((e) => StateAnswersQuizDetails.correct)
          .toList(),
      incorrectAnwers: incorrectAnwers,
      omitted: isOmittedAnswer
          .where((e) => e)
          .map((e) => StateAnswersQuizDetails.ommitted)
          .toList(),
    ); /**/
  }
}

final kanjiListScoreProvider = NotifierProvider<
    KanjiListScoreProvider,
    ({
      List<StateAnswersQuizDetails> correctAnswers,
      List<StateAnswersQuizDetails> incorrectAnwers,
      List<StateAnswersQuizDetails> omitted
    })>(KanjiListScoreProvider.new);
