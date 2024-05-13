import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/apis/kanji_alive/request_english_word_to_kanji.dart';

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

  void onSucces(List<KanjiFromApi> kanjiList) {
    state = SearchScreenData(
      word: state.word,
      kanjiFromApi: kanjiList[0],
      searchState: SearchState.stoped,
    );
  }

  void onError() {
    state = SearchScreenData(
      word: '',
      kanjiFromApi: null,
      searchState: SearchState.stoped,
    );

    logger.e('error getting kanji from english word');
  }

  void _getKanjiFromEnglishWord(String word) {
    RequestEnglishWordToKanji.getKanjiFromEnglishWord(
      word,
      onSucces,
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
  stoped,
  searching,
  notSearching,
  errorForm,
}
