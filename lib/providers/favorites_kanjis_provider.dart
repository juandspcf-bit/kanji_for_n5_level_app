import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/main_screen_provider.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_favorites.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_inserting_data.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class FavoritesListProvider extends Notifier<(List<KanjiFromApi>, int)> {
  @override
  (List<KanjiFromApi>, int) build() {
    return ([], 0);
  }

  void setInitialFavoritesOnline(List<KanjiFromApi> storedKanjis,
      List<String> myFavoritesCached, int section) async {
    if (myFavoritesCached.isEmpty) {
      state = ([], 1);
      return;
    }

    try {
      final kanjiList = await applicationApiService.requestKanjiListToApi(
        storedKanjis,
        myFavoritesCached,
        section,
      );
      onSuccesRequest(kanjiList);
    } catch (e) {
      onErrorRequest();
    }
  }

  Future<void> fetchFavoritesOnRefresh() async {
    state = ([], 0);
    List<KanjiFromApi> storedKanjis =
        await ref.read(mainScreenProvider.notifier).loadStoredKanjis();
    final favoritesKanjis = await loadFavorites();
    if (favoritesKanjis.isEmpty) {
      state = ([], 1);
      return;
    }

    try {
      final kanjiList = await applicationApiService.requestKanjiListToApi(
        storedKanjis,
        favoritesKanjis,
        10,
      );
      onSuccesRequest(kanjiList);
    } catch (e) {
      onErrorRequest();
    }
  }

  void setInitialFavoritesOffline(List<KanjiFromApi> storedKanjis,
      List<String> myFavoritesCached, int section) {
    if (myFavoritesCached.isEmpty) {
      state = ([], 1);
      return;
    }

    List<KanjiFromApi> favoriteKanjisStored = [];

    for (var favorite in myFavoritesCached) {
      try {
        final favoriteStored =
            storedKanjis.firstWhere((e) => e.kanjiCharacter == favorite);
        favoriteKanjisStored.add(favoriteStored);
      } catch (e) {
        continue;
      }
    }

    onSuccesRequest(favoriteKanjisStored);
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

  bool searchInFavorites(String kanji) {
    final copyState = [...state.$1];
    final mappedCopyState = copyState.map((e) => e.kanjiCharacter).toList();
    final searchResult = mappedCopyState.firstWhere(
      (element) => element == kanji,
      orElse: () => '',
    );
    return searchResult != '';
  }

  void updateKanji(KanjiFromApi storedKanji) {
    final copyState = [...state.$1];

    final kanjiIndex = copyState.indexWhere(
        (element) => element.kanjiCharacter == storedKanji.kanjiCharacter);
    if (kanjiIndex == -1) return;
    copyState[kanjiIndex] = storedKanji;
    state = (copyState, state.$2);
  }

  void insertKanjiToStorage(KanjiFromApi kanjiFromApi) async {
    try {
      final kanjiFromApiStored = await storeKanjiToSqlDB(kanjiFromApi);

      if (kanjiFromApiStored == null) return;

      logger.d(
          '${kanjiFromApiStored.section}, ${kanjiFromApiStored.kanjiCharacter} , ${kanjiFromApiStored.statusStorage}');

      updateProviders(kanjiFromApiStored);

      logger.i(kanjiFromApiStored);
      logger.d('success');
    } catch (e) {
      logger.e('error sotoring');
      logger.e(e.toString());
    }
  }

  void updateProviders(KanjiFromApi kanjiFromApiStored) {
    ref.read(storedKanjisProvider.notifier).addItem(kanjiFromApiStored);

    ref.read(favoriteskanjisProvider.notifier).updateKanji(kanjiFromApiStored);
  }
}

class FavoritesKanjisData {
  const FavoritesKanjisData({
    required this.kanjisFromApi,
    required this.favoritesFetchingStatus,
  });
  final List<KanjiFromApi> kanjisFromApi;
  final FavoritesFetchingStatus favoritesFetchingStatus;
}

enum FavoritesFetchingStatus {
  noStarted('no started'),
  succefulFecth('Your favorites were succefully fetched'),
  errorFetch('Error in fecthing favorites');

  const FavoritesFetchingStatus(this.message);
  final String message;
}

final favoriteskanjisProvider =
    NotifierProvider<FavoritesListProvider, (List<KanjiFromApi>, int)>(
        FavoritesListProvider.new);
