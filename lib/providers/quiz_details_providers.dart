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

  void setQuizState(int index) {
    final dataQuizCopy = dataQuiz;
    dataQuizCopy.shuffle();
    dataQuizCopy.remove(dataQuiz[index]);
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
      selectedAnswer: 0,
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
