import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/quiz_details_provider.dart';

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
/*     isCorrectAnswer
        .where((e) => e)
        .map((e) => StateAnswersQuizDetails.correct)
        .toList();
    isCorrectAnswer
        .where((e) => !e)
        .map((e) => StateAnswersQuizDetails.incorrect)
        .toList();
    isOmittedAnswer
        .where((e) => e)
        .map((e) => StateAnswersQuizDetails.ommitted)
        .toList(); */

    state = (
      correctAnswers: isCorrectAnswer
          .where((e) => e)
          .map((e) => StateAnswersQuizDetails.correct)
          .toList(),
      incorrectAnwers: isCorrectAnswer
          .where((e) => !e)
          .map((e) => StateAnswersQuizDetails.incorrect)
          .toList(),
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
