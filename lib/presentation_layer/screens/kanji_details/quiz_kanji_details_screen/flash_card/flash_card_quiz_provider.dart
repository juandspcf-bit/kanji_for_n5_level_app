import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

class FlashCardProvider extends Notifier<FlashCardData> {
  @override
  FlashCardData build() {
    return FlashCardData(
        kanjiFromApi: null,
        indexQuestion: 0,
        dataInit: [],
        audioQuestion: [],
        japanese: [],
        english: []);
  }

  List<bool> answers = [];

  void initTheQuiz(KanjiFromApi kanjiFromApi) {
    final dataInit = kanjiFromApi.example
        .map((e) => (
              audioQuestion: e.audio.mp3,
              japaneseMeaning: e.japanese,
              englishMeaning: e.meaning.english,
            ))
        .toList();
    dataInit.shuffle();
    answers =
        List<bool>.filled(kanjiFromApi.example.length, false, growable: true);
    state = FlashCardData(
        kanjiFromApi: kanjiFromApi,
        indexQuestion: 0,
        dataInit: dataInit,
        audioQuestion: dataInit.map((e) => e.audioQuestion).toList(),
        japanese: dataInit.map((e) => e.japaneseMeaning).toList(),
        english: dataInit.map((e) => e.englishMeaning).toList());
  }

  void incrementIndex() {
    final length = state.japanese.length;
    if (length - 1 == state.indexQuestion) {
      final dataInit = state.dataInit;
      dataInit.shuffle();
      state = FlashCardData(
          kanjiFromApi: state.kanjiFromApi,
          indexQuestion: 0,
          dataInit: dataInit,
          audioQuestion: dataInit.map((e) => e.audioQuestion).toList(),
          japanese: dataInit.map((e) => e.japaneseMeaning).toList(),
          english: dataInit.map((e) => e.englishMeaning).toList());
    } else {
      var index = state.indexQuestion;
      state = FlashCardData(
          kanjiFromApi: state.kanjiFromApi,
          indexQuestion: ++index,
          dataInit: state.dataInit,
          audioQuestion: state.audioQuestion,
          japanese: state.japanese,
          english: state.english);
    }
  }

  void setIndex(int index) {
    state = FlashCardData(
        kanjiFromApi: state.kanjiFromApi,
        indexQuestion: index,
        dataInit: state.dataInit,
        audioQuestion: state.audioQuestion,
        japanese: state.japanese,
        english: state.english);
  }
}

final flashCardProvider =
    NotifierProvider<FlashCardProvider, FlashCardData>(FlashCardProvider.new);

class FlashCardData {
  final KanjiFromApi? kanjiFromApi;
  final int indexQuestion;
  final List<String> audioQuestion;
  final List<String> japanese;
  final List<String> english;
  List<({String audioQuestion, String englishMeaning, String japaneseMeaning})>
      dataInit;

  FlashCardData(
      {required this.kanjiFromApi,
      required this.indexQuestion,
      required this.dataInit,
      required this.audioQuestion,
      required this.japanese,
      required this.english});
}
