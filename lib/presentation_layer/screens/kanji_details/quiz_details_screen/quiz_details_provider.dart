import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/score_quiz_details/quiz_details_score_provider.dart';

class QuizDetailsProvider extends Notifier<QuizDetailsData> {
  @override
  QuizDetailsData build() {
    return QuizDetailsData(
      kanjiFromApi: null,
      indexQuestion: 0,
      audioQuestion: "",
      selectedAnswer: 4,
      answer1: AnswerData(hiraganaMeaning: "", englishMeaning: ""),
      answer2: AnswerData(hiraganaMeaning: "", englishMeaning: ""),
      answer3: AnswerData(hiraganaMeaning: "", englishMeaning: ""),
      currentScreenType: Screen.welcome,
      selectedOption: 2,
    );
  }

  List<Answer> _dataQuiz = [];
  List<StateAnswersQuizDetails> _answers = [];

  void resetValues() {
    _dataQuiz.shuffle();
    _answers = List.filled(_dataQuiz.length, StateAnswersQuizDetails.ommitted);

    setQuizState(0);
  }

  KanjiFromApi? geKanjiFromApi() {
    return state.kanjiFromApi;
  }

  int getQuizStateCurrentIndex() {
    return state.indexQuestion;
  }

  int getQuizStateLenght() {
    return _dataQuiz.length;
  }

  bool onNext() {
    if (isQuizDataLenghtReached()) {
      ref.read(quizDetailsScoreProvider.notifier).setAnswers();
      return true;
    }

    setQuizState(getQuizStateCurrentIndex() + 1);
    return false;
  }

  bool isQuizDataLenghtReached() {
    int currentIndex =
        ref.read(quizDetailsProvider.notifier).getQuizStateCurrentIndex();

    final length = getQuizStateLenght();
    return (length - 1) == currentIndex;
  }

  void setScreen(Screen screen) {
    state = QuizDetailsData(
      kanjiFromApi: state.kanjiFromApi,
      indexQuestion: state.indexQuestion,
      audioQuestion: state.audioQuestion,
      selectedAnswer: state.selectedAnswer,
      answer1: state.answer1,
      answer2: state.answer2,
      answer3: state.answer3,
      currentScreenType: screen,
      selectedOption: state.selectedOption,
    );
  }

  void setOption(int? value) {
    state = QuizDetailsData(
      kanjiFromApi: state.kanjiFromApi,
      indexQuestion: state.indexQuestion,
      audioQuestion: state.audioQuestion,
      selectedAnswer: state.selectedAnswer,
      answer1: state.answer1,
      answer2: state.answer2,
      answer3: state.answer3,
      currentScreenType: state.currentScreenType,
      selectedOption: value ?? 2,
    );
  }

  void setQuizState(int index) {
    final dataQuizCopy = [..._dataQuiz];
    dataQuizCopy.shuffle();
    int indexToRemove = dataQuizCopy.indexWhere((element) =>
        element.hiraganaMeaning == _dataQuiz[index].hiraganaMeaning);
    dataQuizCopy.removeAt(indexToRemove);
    dataQuizCopy.shuffle();
    final posibleAnswers = [
      Answer(
        audioQuestion: _dataQuiz[index].audioQuestion,
        hiraganaMeaning: _dataQuiz[index].hiraganaMeaning,
        englishMeaning: _dataQuiz[index].englishMeaning,
      ),
      Answer(
        audioQuestion: '',
        hiraganaMeaning: dataQuizCopy[0].hiraganaMeaning,
        englishMeaning: dataQuizCopy[0].englishMeaning,
      ),
      Answer(
        audioQuestion: '',
        hiraganaMeaning: dataQuizCopy[1].hiraganaMeaning,
        englishMeaning: dataQuizCopy[1].englishMeaning,
      ),
    ];

    posibleAnswers.shuffle();

    //logger.d('the possible answers are $posibleAnswers');

    final value = QuizDetailsData(
      kanjiFromApi: state.kanjiFromApi,
      indexQuestion: index,
      audioQuestion: _dataQuiz[index].audioQuestion,
      selectedAnswer: 4,
      answer1: AnswerData(
        hiraganaMeaning: posibleAnswers[0].hiraganaMeaning,
        englishMeaning: posibleAnswers[0].englishMeaning,
      ),
      answer2: AnswerData(
        hiraganaMeaning: posibleAnswers[1].hiraganaMeaning,
        englishMeaning: posibleAnswers[1].englishMeaning,
      ),
      answer3: AnswerData(
        hiraganaMeaning: posibleAnswers[2].hiraganaMeaning,
        englishMeaning: posibleAnswers[2].englishMeaning,
      ),
      currentScreenType: state.currentScreenType,
      selectedOption: state.selectedOption,
    );

    state = value;
  }

  void setDataQuiz(KanjiFromApi kanjiFromApi) {
    final dataInit = kanjiFromApi.example
        .map((e) => Answer(
              audioQuestion: e.audio.mp3,
              hiraganaMeaning: e.japanese,
              englishMeaning: e.meaning.english,
            ))
        .toList();
    dataInit.shuffle();
    _dataQuiz = dataInit;
    _answers = List.filled(_dataQuiz.length, StateAnswersQuizDetails.ommitted);

    state = QuizDetailsData(
      kanjiFromApi: kanjiFromApi,
      indexQuestion: state.indexQuestion,
      audioQuestion: state.audioQuestion,
      selectedAnswer: state.selectedAnswer,
      answer1: state.answer1,
      answer2: state.answer2,
      answer3: state.answer3,
      currentScreenType: state.currentScreenType,
      selectedOption: state.selectedOption,
    );
  }

  void setAnswer(int selectedAnswer) {
    final stateCopy = QuizDetailsData(
      kanjiFromApi: state.kanjiFromApi,
      indexQuestion: state.indexQuestion,
      audioQuestion: state.audioQuestion,
      selectedAnswer: selectedAnswer,
      answer1: AnswerData(
        hiraganaMeaning: state.answer1.hiraganaMeaning,
        englishMeaning: state.answer1.englishMeaning,
      ),
      answer2: AnswerData(
        hiraganaMeaning: state.answer2.hiraganaMeaning,
        englishMeaning: state.answer2.englishMeaning,
      ),
      answer3: AnswerData(
        hiraganaMeaning: state.answer3.hiraganaMeaning,
        englishMeaning: state.answer3.englishMeaning,
      ),
      currentScreenType: state.currentScreenType,
      selectedOption: state.selectedOption,
    );

    //logger.d('answer type: $stateCopy');

    final correct = _dataQuiz.firstWhere(
        (element) => element.audioQuestion == stateCopy.audioQuestion);

    AnswerData answerRadioTiles;
    if (selectedAnswer == 0) {
      answerRadioTiles = AnswerData(
        hiraganaMeaning: stateCopy.answer1.hiraganaMeaning,
        englishMeaning: stateCopy.answer1.englishMeaning,
      );
    } else if (selectedAnswer == 1) {
      answerRadioTiles = AnswerData(
        hiraganaMeaning: stateCopy.answer2.hiraganaMeaning,
        englishMeaning: stateCopy.answer2.englishMeaning,
      );
    } else if (selectedAnswer == 2) {
      answerRadioTiles = AnswerData(
        hiraganaMeaning: stateCopy.answer3.hiraganaMeaning,
        englishMeaning: stateCopy.answer3.englishMeaning,
      );
    } else {
      answerRadioTiles = AnswerData(hiraganaMeaning: '', englishMeaning: '');
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

class QuizDetailsData {
  final KanjiFromApi? kanjiFromApi;
  final int indexQuestion;
  final String audioQuestion;
  final int selectedAnswer;
  final AnswerData answer1;
  final AnswerData answer2;
  final AnswerData answer3;
  final Screen currentScreenType;
  final int selectedOption;

  QuizDetailsData({
    required this.kanjiFromApi,
    required this.indexQuestion,
    required this.audioQuestion,
    required this.selectedAnswer,
    required this.answer1,
    required this.answer2,
    required this.answer3,
    required this.currentScreenType,
    required this.selectedOption,
  });
}

class AnswerData {
  final String hiraganaMeaning;
  final String englishMeaning;

  AnswerData({
    required this.hiraganaMeaning,
    required this.englishMeaning,
  });
}

class Answer {
  final String audioQuestion;
  final String hiraganaMeaning;
  final String englishMeaning;

  Answer({
    required this.audioQuestion,
    required this.hiraganaMeaning,
    required this.englishMeaning,
  });
}

final quizDetailsProvider =
    NotifierProvider<QuizDetailsProvider, QuizDetailsData>(
        QuizDetailsProvider.new);

enum StateAnswersQuizDetails { correct, incorrect, ommitted }

enum Screen { question, score, welcome, flashCards }
