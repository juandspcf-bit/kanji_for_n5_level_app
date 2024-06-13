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

  void _getKanjiFromEnglishWord(String word) async {
    try {
      final defaultLocale = Platform.localeName;
      if (defaultLocale.contains("es_")) {
        final kanjiTranslated = await ref
            .read(kanjiApiServiceProvider)
            .getTranslatedKanjiFromSpanishWord(
              word,
              ref.read(authServiceProvider).userUuid ?? '',
            );

        state = SearchScreenData(
          word: state.word,
          kanjiFromApi: kanjiTranslated,
          searchState: SearchState.stopped,
        );

        return;
      }

      final kanjiFromApi =
          await ref.read(kanjiApiServiceProvider).getKanjiFromEnglishWord(
                word,
                ref.read(authServiceProvider).userUuid ?? '',
              );

      state = SearchScreenData(
        word: state.word,
        kanjiFromApi: kanjiFromApi,
        searchState: SearchState.stopped,
      );
    } catch (e) {
      logger.e(e);
      state = SearchScreenData(
        word: '',
        kanjiFromApi: null,
        searchState: SearchState.stopped,
      );
    }
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
