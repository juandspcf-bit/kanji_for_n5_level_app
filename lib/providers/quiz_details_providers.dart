import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

class QuizDetailsProvider extends Notifier<
    ({
      int indexQuestion,
      String audioQuestion,
      ({String hiraganaMeaning, String englishMeaning}) answer1,
      ({String hiraganaMeaning, String englishMeaning}) answer2,
      ({String hiraganaMeaning, String englishMeaning}) answer3,
    })> {
  @override
  ({
    ({String hiraganaMeaning, String englishMeaning}) answer1,
    ({String hiraganaMeaning, String englishMeaning}) answer2,
    ({String hiraganaMeaning, String englishMeaning}) answer3,
    String audioQuestion,
    int indexQuestion
  }) build() {
    // TODO: implement build
    return (
      indexQuestion: 0,
      audioQuestion: "",
      answer1: (hiraganaMeaning: '', englishMeaning: ''),
      answer2: (hiraganaMeaning: '', englishMeaning: ''),
      answer3: (hiraganaMeaning: '', englishMeaning: ''),
    );
  }

  List<({String audioQuestion, String englishMeaning, String hiraganaMeaning})>
      dataQuiz = [];

  void setQuizState(int index, KanjiFromApi kanjiFromApi) {
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
        englishMeaning: dataQuizCopy[1].englishMeaning,
      ),
      (
        audioQuestion: dataQuizCopy[index].audioQuestion,
        hiraganaMeaning: dataQuizCopy[0].hiraganaMeaning,
        englishMeaning: dataQuizCopy[1].englishMeaning,
      ),
    ];

    posibleAnswers.shuffle();

    ({
      int indexQuestion,
      String audioQuestion,
      ({String hiraganaMeaning, String englishMeaning}) answer1,
      ({String hiraganaMeaning, String englishMeaning}) answer2,
      ({String hiraganaMeaning, String englishMeaning}) answer3,
    }) value = (
      indexQuestion: index,
      audioQuestion: dataQuiz[index].audioQuestion,
      answer1: (
        hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
        englishMeaning: kanjiFromApi.englishMeaning,
      ),
      answer2: (
        hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
        englishMeaning: kanjiFromApi.englishMeaning,
      ),
      answer3: (
        hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
        englishMeaning: kanjiFromApi.englishMeaning,
      ),
    );
  }

  void suffleExamples(KanjiFromApi kanjiFromApi) {
    final dataInit = kanjiFromApi.example
        .map((e) => (
              audioQuestion: e.audio.mp3,
              hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
              englishMeaning: kanjiFromApi.englishMeaning,
            ))
        .toList();
    dataInit.shuffle();
    dataQuiz = dataInit;
    //mp3Audios = mp3AudiosInit;
  }
}
