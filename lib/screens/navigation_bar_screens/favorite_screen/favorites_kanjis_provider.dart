import 'package:cloud_firestore/cloud_firestore.dart';
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
      favoritesKanjisFromApi: [],
      favoritesFetchingStatus: FavoritesFetchingStatus.noStarted,
    );
  }

  void setInitialFavoritesOnline(List<KanjiFromApi> storedKanjis,
      List<Favorite> myFavoritesCached, int section) async {
    logger.d('set initial favorites online');
    if (myFavoritesCached.isEmpty) {
      state = const FavoritesKanjisData(
        favoritesKanjisFromApi: [],
        favoritesFetchingStatus: FavoritesFetchingStatus.succefulFecth,
      );
      return;
    }

    try {
      final kanjiList = await applicationApiService.requestKanjiListToApi(
        storedKanjis,
        myFavoritesCached.map((e) => e.kanjis).toList(),
        section,
      );

      final List<FavoriteKanji> favoritesKanjiList = [];
      for (var i = 0; i < kanjiList.length; i++) {
        favoritesKanjiList.add(
          FavoriteKanji(
              kanjiFromApi: kanjiList[i],
              timeStamp: myFavoritesCached[i].timeStamp),
        );
      }

      favoritesKanjiList.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));

      logger.d('the initial favorites kanjilist is: $favoritesKanjiList');

      onSuccesRequest(favoritesKanjiList);
    } catch (e) {
      logger.e(e);
      onErrorRequest();
    }
  }

  Future<void> fetchFavoritesOnRefresh() async {
    state = const FavoritesKanjisData(
      favoritesKanjisFromApi: [],
      favoritesFetchingStatus: FavoritesFetchingStatus.noStarted,
    );
    List<KanjiFromApi> storedKanjis =
        await ref.read(mainScreenProvider.notifier).loadStoredKanjis();
    final favoritesKanjisFromDB = await loadFavorites();
    if (favoritesKanjisFromDB.isEmpty) {
      state = const FavoritesKanjisData(
        favoritesKanjisFromApi: [],
        favoritesFetchingStatus: FavoritesFetchingStatus.succefulFecth,
      );
      return;
    }

    try {
      final kanjiListFromAPI =
          await applicationApiService.requestKanjiListToApi(
        storedKanjis,
        favoritesKanjisFromDB.map((e) => e.kanjis).toList(),
        10,
      );

      final List<FavoriteKanji> favoritesKanjiList = [];
      for (var i = 0; i < favoritesKanjisFromDB.length; i++) {
        favoritesKanjiList.add(
          FavoriteKanji(
              kanjiFromApi: kanjiListFromAPI[i],
              timeStamp: favoritesKanjisFromDB[i].timeStamp),
        );
      }

      favoritesKanjiList.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));

      onSuccesRequest(favoritesKanjiList);
    } catch (e) {
      onErrorRequest();
    }
  }

  void setInitialFavoritesOffline(List<KanjiFromApi> storedKanjis,
      List<Favorite> myFavoritesCached, int section) {
    if (myFavoritesCached.isEmpty) {
      state = const FavoritesKanjisData(
        favoritesKanjisFromApi: [],
        favoritesFetchingStatus: FavoritesFetchingStatus.succefulFecth,
      );
      return;
    }

    List<KanjiFromApi> favoriteKanjisStored = [];

    for (var favorite in myFavoritesCached) {
      try {
        final favoriteStored =
            storedKanjis.firstWhere((e) => e.kanjiCharacter == favorite.kanjis);
        favoriteKanjisStored.add(favoriteStored);
      } catch (e) {
        continue;
      }
    }

    final List<FavoriteKanji> favoritesKanjiList = [];
    for (var i = 0; i < favoriteKanjisStored.length; i++) {
      favoritesKanjiList.add(
        FavoriteKanji(
            kanjiFromApi: favoriteKanjisStored[i],
            timeStamp: myFavoritesCached[i].timeStamp),
      );
    }

    favoritesKanjiList.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));

    onSuccesRequest(favoritesKanjiList);
  }

  void onSuccesRequest(List<FavoriteKanji> kanjisFromApi) {
    state = FavoritesKanjisData(
      favoritesKanjisFromApi: kanjisFromApi,
      favoritesFetchingStatus: FavoritesFetchingStatus.succefulFecth,
    );
  }

  void onErrorRequest() {
    state = const FavoritesKanjisData(
      favoritesKanjisFromApi: [],
      favoritesFetchingStatus: FavoritesFetchingStatus.errorFetch,
    );
  }

  List<FavoriteKanji> getFavorites() {
    return state.favoritesKanjisFromApi;
  }

  void addItem(List<KanjiFromApi> storedItems, FavoriteKanji kanjiFromApi) {
    state = FavoritesKanjisData(
      favoritesKanjisFromApi: [...state.favoritesKanjisFromApi, kanjiFromApi],
      favoritesFetchingStatus: state.favoritesFetchingStatus,
    );
  }

  void removeItem(KanjiFromApi favoritekanjiFromApi) {
    final copyState = [...state.favoritesKanjisFromApi];
    int index = copyState.indexWhere((element) =>
        element.kanjiFromApi.kanjiCharacter ==
        favoritekanjiFromApi.kanjiCharacter);
    copyState.removeAt(index);
    state = FavoritesKanjisData(
      favoritesKanjisFromApi: [...copyState],
      favoritesFetchingStatus: state.favoritesFetchingStatus,
      dissmisedKanji: state.dissmisedKanji,
      onDismissibleActionStatus: state.onDismissibleActionStatus,
    );
  }

  bool searchInFavorites(String kanji) {
    final copyState = [...state.favoritesKanjisFromApi];
    final mappedCopyState =
        copyState.map((e) => e.kanjiFromApi.kanjiCharacter).toList();
    final searchResult = mappedCopyState.firstWhere(
      (element) => element == kanji,
      orElse: () => '',
    );
    return searchResult != '';
  }

  void updateKanji(KanjiFromApi storedKanji) {
    final copyState = [...state.favoritesKanjisFromApi];

    final index = copyState.indexWhere((element) =>
        element.kanjiFromApi.kanjiCharacter == storedKanji.kanjiCharacter);
    if (index == -1) return;
    copyState[index] = FavoriteKanji(
      kanjiFromApi: storedKanji,
      timeStamp: state.favoritesKanjisFromApi[index].timeStamp,
    );
    state = FavoritesKanjisData(
      favoritesKanjisFromApi: copyState,
      favoritesFetchingStatus: state.favoritesFetchingStatus,
    );
  }

  void insertKanjiToStorage(KanjiFromApi kanjiFromApi) async {
    try {
      final kanjiFromApiStored = await storeKanjiToSqlDB(kanjiFromApi);

      if (kanjiFromApiStored == null) return;

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
    int index = state.favoritesKanjisFromApi.indexWhere((element) =>
        kanjiFromApi.kanjiCharacter == element.kanjiFromApi.kanjiCharacter);
    if (index == -1) {
      logger.d('index -1');
      //TODO improve the logic
      return;
    }
    logger.d('index found $index');
    try {
      setDismissedKanji(state.favoritesKanjisFromApi[index], index);
      removeItem(kanjiFromApi);

      await deleteFavorite(kanjiFromApi.kanjiCharacter);
      setOnDismissibleActionStatus(OnDismissibleActionStatus.successRemoved);
    } catch (e) {
      logger.e(e);
      setOnDismissibleActionStatus(OnDismissibleActionStatus.noStarted);
    }
  }

  void setOnDismissibleActionStatus(OnDismissibleActionStatus status) {
    state = FavoritesKanjisData(
      favoritesKanjisFromApi: state.favoritesKanjisFromApi,
      favoritesFetchingStatus: state.favoritesFetchingStatus,
      dissmisedKanji: state.dissmisedKanji,
      onDismissibleActionStatus: status,
    );
  }

  Future<void> restoreFavorite(FavoriteKanji favoriteKanji, int index) async {
    try {
      await insertFavorite(
        favoriteKanji.kanjiFromApi.kanjiCharacter,
        favoriteKanji.timeStamp,
      );
      final kanjiList = state.favoritesKanjisFromApi;
      logger.d('kanjiList: $kanjiList , $index');

      kanjiList.insert(
        index,
        FavoriteKanji(
          kanjiFromApi: favoriteKanji.kanjiFromApi,
          timeStamp: favoriteKanji.timeStamp,
        ),
      );

      state = FavoritesKanjisData(
        favoritesKanjisFromApi: kanjiList,
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

  void setDismissedKanji(FavoriteKanji kanjiFromApi, int index) {
    state = FavoritesKanjisData(
      favoritesKanjisFromApi: state.favoritesKanjisFromApi,
      favoritesFetchingStatus: state.favoritesFetchingStatus,
      dissmisedKanji: DissmisedKanji(
        kanjiFromApiFromDismisibleAction: kanjiFromApi,
        index: index,
      ),
      onDismissibleActionStatus: state.onDismissibleActionStatus,
    );
  }

  bool isAnyProcessingData() {
    try {
      state.favoritesKanjisFromApi.firstWhere(
        (element) =>
            element.kanjiFromApi.statusStorage ==
                StatusStorage.proccessingStoring ||
            element.kanjiFromApi.statusStorage ==
                StatusStorage.proccessingDeleting,
      );

      return true;
    } on StateError {
      return false;
    }
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
    required this.favoritesKanjisFromApi,
    required this.favoritesFetchingStatus,
    this.dissmisedKanji,
    this.onDismissibleActionStatus = OnDismissibleActionStatus.noStarted,
  });
  final List<FavoriteKanji> favoritesKanjisFromApi;
  final FavoritesFetchingStatus favoritesFetchingStatus;
  final OnDismissibleActionStatus onDismissibleActionStatus;
  final DissmisedKanji? dissmisedKanji;
}

class FavoriteKanji {
  final KanjiFromApi kanjiFromApi;
  final int timeStamp;

  FavoriteKanji({required this.kanjiFromApi, required this.timeStamp});

  @override
  String toString() {
    return '${kanjiFromApi.kanjiCharacter}, ${DateTime.fromMillisecondsSinceEpoch(timeStamp)}';
  }
}

class DissmisedKanji {
  DissmisedKanji(
      {required this.kanjiFromApiFromDismisibleAction, required this.index});
  final FavoriteKanji kanjiFromApiFromDismisibleAction;
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
