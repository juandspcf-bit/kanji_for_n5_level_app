import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

class SearchScreenProvider extends Notifier<SearchScreenData> {
  @override
  SearchScreenData build() {
    return SearchScreenData(
        word: '', kanjiFromApi: null, searchState: SearchState.notSearching);
  }

  void setWord(String word) {
    final trimWord = word.trim();
    state = SearchScreenData(
        word: trimWord, kanjiFromApi: null, searchState: SearchState.searching);
    _getKanjiFromEnglishWord(trimWord);
  }

  void setOnErrorTextField() {
    state = SearchScreenData(
        word: '', kanjiFromApi: null, searchState: SearchState.errorForm);
  }

  void onSuccess(List<KanjiFromApi> kanjiList) async {
    final defaultLocale = Platform.localeName;
    logger.d(defaultLocale);
    if (defaultLocale.contains("es_")) {
      final translatedMeaning =
          await ref.read(translationApiServiceProvider).translateText(
                kanjiList[0].englishMeaning,
                "en",
                "es",
              );
      var words = "";

      final length = kanjiList[0].example.length;
      for (var i = 0; i < length; i++) {
        final exam = kanjiList[0].example[i];
        if (i == length - 1) {
          words += exam.meaning.english;
          continue;
        }
        words += "${exam.meaning.english};";
      }

      final translatedExamplesChain =
          await ref.read(translationApiServiceProvider).translateText(
                words,
                "en",
                "es",
              );

      final translatedExamplesList =
          translatedExamplesChain.translatedText.split(";");

      final List<Example> newListExamples = [];

      for (int i = 0; i < translatedExamplesList.length; i++) {
        newListExamples.add(Example(
            japanese: kanjiList[0].example[i].japanese,
            meaning: Meaning(english: translatedExamplesList[i]),
            audio: kanjiList[0].example[i].audio));
      }

      final newKanji = kanjiList[0].copyWith(
        englishMeaning: translatedMeaning.translatedText,
        example: newListExamples,
      );
      state = SearchScreenData(
        word: state.word,
        kanjiFromApi: newKanji,
        searchState: SearchState.stopped,
      );
      return;
    }

    state = SearchScreenData(
      word: state.word,
      kanjiFromApi: kanjiList[0],
      searchState: SearchState.stopped,
    );
  }

  void onError() {
    state = SearchScreenData(
      word: '',
      kanjiFromApi: null,
      searchState: SearchState.stopped,
    );

    logger.e('error getting kanji from english word');
  }

  void _getKanjiFromEnglishWord(String word) {
    ref.read(kanjiApiServiceProvider).getKanjiFromEnglishWord(
          word,
          onSuccess,
          onError,
          ref.read(authServiceProvider).userUuid ?? '',
        );
  }
}

final searchScreenProvider =
    NotifierProvider<SearchScreenProvider, SearchScreenData>(
        SearchScreenProvider.new);

class SearchScreenData {
  final String word;
  final KanjiFromApi? kanjiFromApi;
  final SearchState searchState;

  SearchScreenData(
      {required this.word,
      required this.kanjiFromApi,
      required this.searchState});
}

enum SearchState {
  stopped,
  searching,
  notSearching,
  errorForm,
}
