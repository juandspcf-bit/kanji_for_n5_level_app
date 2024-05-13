import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/quiz_details_provider.dart';

class QuizDetailsScoreProvider extends Notifier<
    ({
      List<StateAnswersQuizDetails> correctAnswers,
      List<StateAnswersQuizDetails> incorrectAnswers,
      List<StateAnswersQuizDetails> omitted
    })> {
  @override
  ({
    List<StateAnswersQuizDetails> correctAnswers,
    List<StateAnswersQuizDetails> incorrectAnswers,
    List<StateAnswersQuizDetails> omitted
  }) build() {
    return (
      correctAnswers: [],
      incorrectAnswers: [],
      omitted: [],
    );
  }

  void resetStateScoreQuizDetails() {
    state = (
      correctAnswers: [],
      incorrectAnswers: [],
      omitted: [],
    );
  }

  void setAnswers() {
    final answers = ref.read(quizDetailsProvider.notifier).getStatusAnswers();

    state = (
      correctAnswers:
          answers.where((e) => e == StateAnswersQuizDetails.correct).toList(),
      incorrectAnswers:
          answers.where((e) => e == StateAnswersQuizDetails.incorrect).toList(),
      omitted:
          answers.where((e) => e == StateAnswersQuizDetails.omitted).toList(),
    );
  }
}

final quizDetailsScoreProvider = NotifierProvider<
    QuizDetailsScoreProvider,
    ({
      List<StateAnswersQuizDetails> correctAnswers,
      List<StateAnswersQuizDetails> incorrectAnswers,
      List<StateAnswersQuizDetails> omitted
    })>(QuizDetailsScoreProvider.new);
