import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/networking/request_api.dart';

class FavoritesCached extends Notifier<(List<KanjiFromApi>, int)> {
  @override
  (List<KanjiFromApi>, int) build() {
    return ([], 0);
  }

  void setInitialFavorites(List<KanjiFromApi> storedKanjis,
      List<String> myFavoritesCached, int section) {
    if (myFavoritesCached.isEmpty) {
      state = ([], 1);
      return;
    }
    RequestApi.getKanjis(storedKanjis, myFavoritesCached, section,
        onSuccesRequest, onErrorRequest);
  }

  void onSuccesRequest(List<KanjiFromApi> kanjisFromApi) {
    state = (kanjisFromApi, 1);
  }

  void onErrorRequest() {
    state = ([], 2);
  }

  List<KanjiFromApi> getFavorites() {
    return state.$1;
  }

  void addItem(List<KanjiFromApi> storedItems, KanjiFromApi kanjiFromApi) {
    state = ([...state.$1, kanjiFromApi], 1);
  }

  void removeItem(KanjiFromApi favoritekanjiFromApi) {
    final copyState = [...state.$1];
    int index = copyState.indexWhere((element) =>
        element.kanjiCharacter == favoritekanjiFromApi.kanjiCharacter);
    copyState.removeAt(index);
    state = ([...copyState], state.$2);
  }

  String searchInFavorites(String kanji) {
    final copyState = [...state.$1];
    final mappedCopyState = copyState.map((e) => e.kanjiCharacter).toList();
    return mappedCopyState.firstWhere(
      (element) => element == kanji,
      orElse: () => '',
    );
  }

  void updateKanji(KanjiFromApi storedKanji) {
    final copyState = [...state.$1];

    try {
      final kanjiIndex = copyState.indexWhere(
          (element) => element.kanjiCharacter == storedKanji.kanjiCharacter);
      copyState[kanjiIndex] = storedKanji;
      state = (copyState, state.$2);
    } on StateError catch (e) {
      e.message;
    }
  }
}

final favoritesCachedProvider =
    NotifierProvider<FavoritesCached, (List<KanjiFromApi>, int)>(
        FavoritesCached.new);
