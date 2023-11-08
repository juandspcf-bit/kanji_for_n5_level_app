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
    return (
      indexQuestion: 0,
      audioQuestion: "",
      selectedAnswer: 4,
      answer1: (hiraganaMeaning: '', englishMeaning: ''),
      answer2: (hiraganaMeaning: '', englishMeaning: ''),
      answer3: (hiraganaMeaning: '', englishMeaning: ''),
    );
  }

  List<({String audioQuestion, String englishMeaning, String hiraganaMeaning})>
      _dataQuiz = [];
  List<StateAnswersQuizDetails> _answers = [];

  void resetValues() {
    _dataQuiz.shuffle();
    _answers = List.filled(_dataQuiz.length, StateAnswersQuizDetails.ommitted);

    setQuizState(0);
  }

  int getQuizStateCurrentIndex() {
    return state.indexQuestion;
  }

  int getQuizStateLenght() {
    return _dataQuiz.length;
  }

  bool isQuizDataLenghtReached() {
    int currentIndex =
        ref.read(quizDetailsProvider.notifier).getQuizStateCurrentIndex();

    final length = getQuizStateLenght();
    return (length - 1) == currentIndex;
  }

  void setQuizState(int index) {
    final dataQuizCopy = [..._dataQuiz];
    dataQuizCopy.shuffle();
    int indexToRemove = dataQuizCopy.indexWhere((element) =>
        element.hiraganaMeaning == _dataQuiz[index].hiraganaMeaning);
    dataQuizCopy.removeAt(indexToRemove);
    dataQuizCopy.shuffle();
    final List<
        ({
          String audioQuestion,
          String hiraganaMeaning,
          String englishMeaning
        })> posibleAnswers = [
      (
        audioQuestion: _dataQuiz[index].audioQuestion,
        hiraganaMeaning: _dataQuiz[index].hiraganaMeaning,
        englishMeaning: _dataQuiz[index].englishMeaning,
      ),
      (
        audioQuestion: '',
        hiraganaMeaning: dataQuizCopy[0].hiraganaMeaning,
        englishMeaning: dataQuizCopy[0].englishMeaning,
      ),
      (
        audioQuestion: '',
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
      audioQuestion: _dataQuiz[index].audioQuestion,
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

  void setDataQuiz(KanjiFromApi kanjiFromApi) {
    final dataInit = kanjiFromApi.example
        .map((e) => (
              audioQuestion: e.audio.mp3,
              hiraganaMeaning: e.japanese,
              englishMeaning: e.meaning.english,
            ))
        .toList();
    dataInit.shuffle();
    _dataQuiz = dataInit;
    _answers = List.filled(_dataQuiz.length, StateAnswersQuizDetails.ommitted);
    logger.d(_dataQuiz);
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

    logger.d('answer type: $stateCopy');

    final correct = _dataQuiz.firstWhere(
        (element) => element.audioQuestion == stateCopy.audioQuestion);

    ({String hiraganaMeaning, String englishMeaning}) answerRadioTiles;
    if (selectedAnswer == 0) {
      answerRadioTiles = (
        hiraganaMeaning: stateCopy.answer1.hiraganaMeaning,
        englishMeaning: stateCopy.answer1.englishMeaning
      );
    } else if (selectedAnswer == 1) {
      answerRadioTiles = (
        hiraganaMeaning: stateCopy.answer2.hiraganaMeaning,
        englishMeaning: stateCopy.answer2.englishMeaning
      );
    } else if (selectedAnswer == 2) {
      answerRadioTiles = (
        hiraganaMeaning: stateCopy.answer3.hiraganaMeaning,
        englishMeaning: stateCopy.answer3.englishMeaning
      );
    } else {
      answerRadioTiles = (hiraganaMeaning: '', englishMeaning: '');
    }

    if (answerRadioTiles.hiraganaMeaning == '') {
      _answers[stateCopy.indexQuestion] = StateAnswersQuizDetails.ommitted;
    } else if (answerRadioTiles.hiraganaMeaning == correct.hiraganaMeaning) {
      _answers[stateCopy.indexQuestion] = StateAnswersQuizDetails.correct;
    } else {
      _answers[stateCopy.indexQuestion] = StateAnswersQuizDetails.incorrect;
    }
    logger.d('answer type: ${_answers[stateCopy.indexQuestion]}');
    state = stateCopy;
  }

  List<StateAnswersQuizDetails> getStatusAnswers() {
    return _answers;
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
