import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/screens/main_content.dart';

class QuizDetailsProvider extends Notifier<
    ({
      int indexQuestion,
      String audioQuestion,
      int selectedAnswer,
      ({String hiraganaMeaning, String englishMeaning}) answer1,
      ({String hiraganaMeaning, String englishMeaning}) answer2,
      ({String hiraganaMeaning, String englishMeaning}) answer3,
    })> {
  @override
  ({
    ({String hiraganaMeaning, String englishMeaning}) answer1,
    ({String hiraganaMeaning, String englishMeaning}) answer2,
    ({String hiraganaMeaning, String englishMeaning}) answer3,
    int selectedAnswer,
    String audioQuestion,
    int indexQuestion
  }) build() {
    // TODO: implement build
    return (
      indexQuestion: 0,
      audioQuestion: "",
      selectedAnswer: 0,
      answer1: (hiraganaMeaning: '', englishMeaning: ''),
      answer2: (hiraganaMeaning: '', englishMeaning: ''),
      answer3: (hiraganaMeaning: '', englishMeaning: ''),
    );
  }

  List<({String audioQuestion, String englishMeaning, String hiraganaMeaning})>
      dataQuiz = [];
  List<StateAnswersQuizDetails> answers = [];

  int getQuizStateCurrentIndex() {
    return state.indexQuestion;
  }

  void setQuizState(int index) {
    final dataQuizCopy = [...dataQuiz];
    dataQuizCopy.shuffle();
    int indexToRemove = dataQuizCopy.indexWhere((element) =>
        element.hiraganaMeaning == dataQuiz[index].hiraganaMeaning);
    dataQuizCopy.removeAt(indexToRemove);
    dataQuizCopy.shuffle();
    final posibleAnswers = [
      (
        audioQuestion: dataQuiz[index].audioQuestion,
        hiraganaMeaning: dataQuiz[index].hiraganaMeaning,
        englishMeaning: dataQuiz[index].englishMeaning,
      ),
      (
        audioQuestion: dataQuizCopy[index].audioQuestion,
        hiraganaMeaning: dataQuizCopy[0].hiraganaMeaning,
        englishMeaning: dataQuizCopy[0].englishMeaning,
      ),
      (
        audioQuestion: dataQuizCopy[index].audioQuestion,
        hiraganaMeaning: dataQuizCopy[1].hiraganaMeaning,
        englishMeaning: dataQuizCopy[1].englishMeaning,
      ),
    ];

    posibleAnswers.shuffle();

    logger.d('the possible answers are $posibleAnswers');

    ({
      int indexQuestion,
      String audioQuestion,
      int selectedAnswer,
      ({String hiraganaMeaning, String englishMeaning}) answer1,
      ({String hiraganaMeaning, String englishMeaning}) answer2,
      ({String hiraganaMeaning, String englishMeaning}) answer3,
    }) value = (
      indexQuestion: index,
      audioQuestion: dataQuiz[index].audioQuestion,
      selectedAnswer: 4,
      answer1: (
        hiraganaMeaning: posibleAnswers[0].hiraganaMeaning,
        englishMeaning: posibleAnswers[0].englishMeaning,
      ),
      answer2: (
        hiraganaMeaning: posibleAnswers[1].hiraganaMeaning,
        englishMeaning: posibleAnswers[1].englishMeaning,
      ),
      answer3: (
        hiraganaMeaning: posibleAnswers[2].hiraganaMeaning,
        englishMeaning: posibleAnswers[2].englishMeaning,
      ),
    );

    state = value;
  }

  void suffleExamples(KanjiFromApi kanjiFromApi) {
    final dataInit = kanjiFromApi.example
        .map((e) => (
              audioQuestion: e.audio.mp3,
              hiraganaMeaning: e.japanese,
              englishMeaning: e.meaning.english,
            ))
        .toList();
    dataInit.shuffle();
    dataQuiz = dataInit;
    logger.d(dataQuiz);
    //mp3Audios = mp3AudiosInit;
  }

  void setAnswer(int selectedAnswer) {
    ({
      int indexQuestion,
      String audioQuestion,
      int selectedAnswer,
      ({String hiraganaMeaning, String englishMeaning}) answer1,
      ({String hiraganaMeaning, String englishMeaning}) answer2,
      ({String hiraganaMeaning, String englishMeaning}) answer3,
    }) stateCopy = (
      indexQuestion: state.indexQuestion,
      audioQuestion: state.audioQuestion,
      selectedAnswer: selectedAnswer,
      answer1: (
        hiraganaMeaning: state.answer1.hiraganaMeaning,
        englishMeaning: state.answer1.englishMeaning,
      ),
      answer2: (
        hiraganaMeaning: state.answer2.hiraganaMeaning,
        englishMeaning: state.answer2.englishMeaning,
      ),
      answer3: (
        hiraganaMeaning: state.answer3.hiraganaMeaning,
        englishMeaning: state.answer3.englishMeaning,
      ),
    );

    final correct = dataQuiz.firstWhere(
        (element) => element.audioQuestion == stateCopy.audioQuestion);

    ({String englishMeaning, String hiraganaMeaning}) answerRadioTiles;
    if (selectedAnswer == 0) {
      answerRadioTiles = stateCopy.answer1;
    } else if (selectedAnswer == 1) {
      answerRadioTiles = stateCopy.answer2;
    }
    if (selectedAnswer == 2) {
      answerRadioTiles = stateCopy.answer3;
    } else {
      answerRadioTiles = (hiraganaMeaning: '', englishMeaning: '');
    }

    if (answerRadioTiles.hiraganaMeaning == '') {
      answers[stateCopy.indexQuestion] = StateAnswersQuizDetails.ommitted;
    } else if (answerRadioTiles.hiraganaMeaning == correct.hiraganaMeaning) {
      answers[stateCopy.indexQuestion] = StateAnswersQuizDetails.correct;
    } else {
      answers[stateCopy.indexQuestion] = StateAnswersQuizDetails.incorrect;
    }

    state = stateCopy;
  }
}

final quizDetailsProvider = NotifierProvider<
    QuizDetailsProvider,
    ({
      int indexQuestion,
      String audioQuestion,
      int selectedAnswer,
      ({String hiraganaMeaning, String englishMeaning}) answer1,
      ({String hiraganaMeaning, String englishMeaning}) answer2,
      ({String hiraganaMeaning, String englishMeaning}) answer3,
    })>(QuizDetailsProvider.new);

enum StateAnswersQuizDetails { correct, incorrect, ommitted }
