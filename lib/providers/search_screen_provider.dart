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

  void onSuccess(List<KanjiFromApi> kanjiList) {
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
