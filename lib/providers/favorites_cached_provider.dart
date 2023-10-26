import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesCached extends Notifier<List<(String, String, String)>> {
  @override
  List<(String, String, String)> build() {
    return [];
  }

  void setInitState(List<(String, String, String)> myFavoritesCached) {
    state = myFavoritesCached;
  }

  void addItem((String, String, String) item) {
    state = [...state, item];
  }

  void removeItem((String, String, String) item) {
    final copyState = [...state];
    copyState.remove(item);
    state = [...copyState];
  }

  (String, String, String) searchInFavorites(String kanji) {
    final copyState = [...state];
    var queryKanji = copyState.firstWhere((element) => element.$3 == kanji,
        orElse: () => ("", "", ""));
    return queryKanji;
  }
}

final favoritesCachedProvider =
    NotifierProvider<FavoritesCached, List<(String, String, String)>>(
        FavoritesCached.new);
