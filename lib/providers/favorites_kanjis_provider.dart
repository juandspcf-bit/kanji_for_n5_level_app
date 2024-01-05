import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/main_screen_provider.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_favorites.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_inserting_data.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class FavoritesListProvider extends Notifier<FavoritesKanjisData> {
  @override
  FavoritesKanjisData build() {
    return const FavoritesKanjisData(
      kanjisFromApi: [],
      favoritesFetchingStatus: FavoritesFetchingStatus.noStarted,
    );
  }

  void setInitialFavoritesOnline(List<KanjiFromApi> storedKanjis,
      List<String> myFavoritesCached, int section) async {
    if (myFavoritesCached.isEmpty) {
      state = const FavoritesKanjisData(
        kanjisFromApi: [],
        favoritesFetchingStatus: FavoritesFetchingStatus.succefulFecth,
      );
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
    state = const FavoritesKanjisData(
      kanjisFromApi: [],
      favoritesFetchingStatus: FavoritesFetchingStatus.noStarted,
    );
    List<KanjiFromApi> storedKanjis =
        await ref.read(mainScreenProvider.notifier).loadStoredKanjis();
    final favoritesKanjis = await loadFavorites();
    if (favoritesKanjis.isEmpty) {
      state = const FavoritesKanjisData(
        kanjisFromApi: [],
        favoritesFetchingStatus: FavoritesFetchingStatus.succefulFecth,
      );
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
      state = const FavoritesKanjisData(
        kanjisFromApi: [],
        favoritesFetchingStatus: FavoritesFetchingStatus.succefulFecth,
      );
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
    state = FavoritesKanjisData(
      kanjisFromApi: kanjisFromApi,
      favoritesFetchingStatus: FavoritesFetchingStatus.succefulFecth,
    );
  }

  void onErrorRequest() {
    state = const FavoritesKanjisData(
      kanjisFromApi: [],
      favoritesFetchingStatus: FavoritesFetchingStatus.errorFetch,
    );
  }

  List<KanjiFromApi> getFavorites() {
    return state.kanjisFromApi;
  }

  void addItem(List<KanjiFromApi> storedItems, KanjiFromApi kanjiFromApi) {
    state = FavoritesKanjisData(
      kanjisFromApi: [...state.kanjisFromApi, kanjiFromApi],
      favoritesFetchingStatus: state.favoritesFetchingStatus,
    );
  }

  void removeItem(KanjiFromApi favoritekanjiFromApi) {
    final copyState = [...state.kanjisFromApi];
    int index = copyState.indexWhere((element) =>
        element.kanjiCharacter == favoritekanjiFromApi.kanjiCharacter);
    copyState.removeAt(index);
    state = FavoritesKanjisData(
      kanjisFromApi: [...copyState],
      favoritesFetchingStatus: state.favoritesFetchingStatus,
    );
  }

  bool searchInFavorites(String kanji) {
    final copyState = [...state.kanjisFromApi];
    final mappedCopyState = copyState.map((e) => e.kanjiCharacter).toList();
    final searchResult = mappedCopyState.firstWhere(
      (element) => element == kanji,
      orElse: () => '',
    );
    return searchResult != '';
  }

  void updateKanji(KanjiFromApi storedKanji) {
    final copyState = [...state.kanjisFromApi];

    final kanjiIndex = copyState.indexWhere(
        (element) => element.kanjiCharacter == storedKanji.kanjiCharacter);
    if (kanjiIndex == -1) return;
    copyState[kanjiIndex] = storedKanji;
    state = FavoritesKanjisData(
      kanjisFromApi: copyState,
      favoritesFetchingStatus: state.favoritesFetchingStatus,
    );
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

  Future<void> dismissisFavorite(KanjiFromApi kanjiFromApi) async {
    setOnDismissibleActionStatus(OnDismissibleActionStatus.processing);
    int index = state.kanjisFromApi.indexWhere(
        (element) => kanjiFromApi.kanjiCharacter == element.kanjiCharacter);
    if (index == -1) {
      //TODO improve the logic
      return;
    }

    try {
      removeItem(kanjiFromApi);
      setDismissedKanji(kanjiFromApi, index);
      await deleteFavorite(kanjiFromApi.kanjiCharacter);
      setOnDismissibleActionStatus(OnDismissibleActionStatus.successRemoved);
    } catch (e) {
      logger.e(e);
      setOnDismissibleActionStatus(OnDismissibleActionStatus.noStarted);
    }
  }

  Future<void> restoreFavorite(KanjiFromApi kanjiFromApi, int index) async {
    try {
      await insertFavorite(kanjiFromApi.kanjiCharacter);
      final kanjiList = state.kanjisFromApi;
      logger.d('kanjiList: $kanjiList , $index');

      kanjiList.insert(index, kanjiFromApi);
      logger.d('kanjiList: $kanjiList , ');

      state = FavoritesKanjisData(
        kanjisFromApi: kanjiList,
        favoritesFetchingStatus: state.favoritesFetchingStatus,
        dissmisedKanji: state.dissmisedKanji,
        onDismissibleActionStatus: state.onDismissibleActionStatus,
      );

      setOnDismissibleActionStatus(OnDismissibleActionStatus.successAdded);
    } catch (e) {
      logger.e(e);
      setOnDismissibleActionStatus(OnDismissibleActionStatus.noStarted);
    }
  }

  void setOnDismissibleActionStatus(OnDismissibleActionStatus status) {
    state = FavoritesKanjisData(
      kanjisFromApi: state.kanjisFromApi,
      favoritesFetchingStatus: state.favoritesFetchingStatus,
      dissmisedKanji: state.dissmisedKanji,
      onDismissibleActionStatus: status,
    );
  }

  void setDismissedKanji(KanjiFromApi kanjiFromApi, int index) {
    state = FavoritesKanjisData(
      kanjisFromApi: state.kanjisFromApi,
      favoritesFetchingStatus: state.favoritesFetchingStatus,
      dissmisedKanji: DissmisedKanji(
        kanjiFromApiFromDismisibleAction: kanjiFromApi,
        index: index,
      ),
      onDismissibleActionStatus: state.onDismissibleActionStatus,
    );
  }
}

enum OnDismissibleActionStatus {
  noStarted('Not started'),
  processing('Processing'),
  successAdded('Added to favorites!'),
  successRemoved('Removed from favorites'),
  error('error in storing');

  const OnDismissibleActionStatus(this.message);
  final String message;
  @override
  String toString() => message;
}

class FavoritesKanjisData {
  const FavoritesKanjisData({
    required this.kanjisFromApi,
    required this.favoritesFetchingStatus,
    this.dissmisedKanji,
    this.onDismissibleActionStatus = OnDismissibleActionStatus.noStarted,
  });
  final List<KanjiFromApi> kanjisFromApi;
  final FavoritesFetchingStatus favoritesFetchingStatus;
  final OnDismissibleActionStatus onDismissibleActionStatus;
  final DissmisedKanji? dissmisedKanji;
}

class DissmisedKanji {
  DissmisedKanji(
      {required this.kanjiFromApiFromDismisibleAction, required this.index});
  final KanjiFromApi kanjiFromApiFromDismisibleAction;
  final int index;
}

enum FavoritesFetchingStatus {
  noStarted('no started'),
  succefulFecth('Your favorites were succefully fetched'),
  errorFetch('Error in fecthing favorites');

  const FavoritesFetchingStatus(this.message);
  final String message;
}

final favoriteskanjisProvider =
    NotifierProvider<FavoritesListProvider, FavoritesKanjisData>(
        FavoritesListProvider.new);
