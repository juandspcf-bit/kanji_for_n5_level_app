import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/networking/request_english_word_to_kanji.dart';

class SearchScreenProvider extends Notifier<SearchScreenData> {
  @override
  SearchScreenData build() {
    return SearchScreenData(
        word: '', kanjiFromApi: null, searchState: SearchState.notSearching);
  }

  void setWord(String word) {
    state = SearchScreenData(
        word: word, kanjiFromApi: null, searchState: SearchState.searching);
    _getKanjiFromEnglishWord(word);
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
  }

  void _getKanjiFromEnglishWord(String word) {
    RequestEnglishWordToKanji.getKanjiFromEnglishWord(word, onSucces, onError);
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
}
