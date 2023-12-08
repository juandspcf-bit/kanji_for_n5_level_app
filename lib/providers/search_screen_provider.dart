import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreenProvider extends Notifier<SearchScreenData> {
  @override
  SearchScreenData build() {
    return SearchScreenData(word: '');
  }

  void setWord(String word) {
    state = SearchScreenData(word: word);
  }
}

final searchScreenProvider =
    NotifierProvider<SearchScreenProvider, SearchScreenData>(
        SearchScreenProvider.new);

class SearchScreenData {
  final String word;

  SearchScreenData({required this.word});
}
