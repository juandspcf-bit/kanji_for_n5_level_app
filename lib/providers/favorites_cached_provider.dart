import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/networking/request_api.dart';

class FavoritesCached extends Notifier<List<KanjiFromApi>> {
  @override
  List<KanjiFromApi> build() {
    return [];
  }

  void setInitState(List<String> myFavoritesCached) {
    RequestApi.getKanjis(myFavoritesCached, onSuccesRequest, onErrorRequest);
    //state = myFavoritesCached;
  }

  void onSuccesRequest(List<KanjiFromApi> kanjisFromApi) {
    state = kanjisFromApi;
  }

  void onSuccesAddRequest(List<KanjiFromApi> kanjisFromApi) {
    state = [...state, ...kanjisFromApi];
  }

  void onErrorRequest() {
    print('error');
  }

  void addItem(String item) {
    RequestApi.getKanjis([item], onSuccesAddRequest, onErrorRequest);
  }

  void removeItem(String item) {
    final copyState = [...state];
    int index =
        copyState.indexWhere((element) => element.kanjiCharacter == item);
    copyState.removeAt(index);
    state = [...copyState];
  }

  String searchInFavorites(String kanji) {
    final copyState = [...state];
    final mappedCopyState = copyState.map((e) => e.kanjiCharacter).toList();
    return mappedCopyState.firstWhere(
      (element) => element == kanji,
      orElse: () => '',
    );
  }
}

final favoritesCachedProvider =
    NotifierProvider<FavoritesCached, List<KanjiFromApi>>(FavoritesCached.new);
