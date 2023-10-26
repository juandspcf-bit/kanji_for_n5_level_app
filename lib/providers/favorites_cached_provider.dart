import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/networking/request_api.dart';

class FavoritesCached extends Notifier<List<KanjiFromApi>> {
  @override
  List<KanjiFromApi> build() {
    return [];
  }

  void setInitState(List<(String, String, String)> myFavoritesCached) {
    RequestApi.getKanjis(myFavoritesCached.map((e) => e.$3).toList(),
        onSuccesRequest, onErrorRequest);
    //state = myFavoritesCached;
  }

  void onSuccesRequest(List<KanjiFromApi> kanjisFromApi) {
    state = kanjisFromApi;
  }

  void onErrorRequest() {
    print('error');
  }

/*   void addItem((String, String, String) item) {
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
  } */
}

final favoritesCachedProvider =
    NotifierProvider<FavoritesCached, List<KanjiFromApi>>(FavoritesCached.new);
