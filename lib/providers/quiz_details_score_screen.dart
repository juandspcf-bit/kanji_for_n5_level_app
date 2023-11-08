import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_details_providers.dart';

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
    final answers = ref.read(quizDetailsProvider.notifier).getStatusAnswers();

    return (
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
