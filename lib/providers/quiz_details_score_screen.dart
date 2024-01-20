import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/quiz_details_provider.dart';

class QuizDetailsScoreProvider extends Notifier<
    ({
      List<StateAnswersQuizDetails> correctAnswers,
      List<StateAnswersQuizDetails> incorrectAnwers,
      List<StateAnswersQuizDetails> omitted
    })> {
  @override
  ({
    List<StateAnswersQuizDetails> correctAnswers,
    List<StateAnswersQuizDetails> incorrectAnwers,
    List<StateAnswersQuizDetails> omitted
  }) build() {
    return (
      correctAnswers: [],
      incorrectAnwers: [],
      omitted: [],
    );
  }

  void resetStateScoreQuizDetails() {
    state = (
      correctAnswers: [],
      incorrectAnwers: [],
      omitted: [],
    );
  }

  void setAnswers() {
    final answers = ref.read(quizDetailsProvider.notifier).getStatusAnswers();

    state = (
      correctAnswers:
          answers.where((e) => e == StateAnswersQuizDetails.correct).toList(),
      incorrectAnwers:
          answers.where((e) => e == StateAnswersQuizDetails.incorrect).toList(),
      omitted:
          answers.where((e) => e == StateAnswersQuizDetails.ommitted).toList(),
    );
  }
}

final quizDetailsScoreProvider = NotifierProvider<
    QuizDetailsScoreProvider,
    ({
      List<StateAnswersQuizDetails> correctAnswers,
      List<StateAnswersQuizDetails> incorrectAnwers,
      List<StateAnswersQuizDetails> omitted
    })>(QuizDetailsScoreProvider.new);
