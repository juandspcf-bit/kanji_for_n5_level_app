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

  Future<void> storeToFavorites(KanjiFromApi kanjiFromApi) async {
    setOnDismissibleActionStatus(OnDismissibleActionStatus.processing);
    final queryKanji = ref
        .read(favoriteskanjisProvider.notifier)
        .searchInFavorites(kanjiFromApi.kanjiCharacter);

    if (!queryKanji) {
      try {
        await insertFavorite(kanjiFromApi.kanjiCharacter);
        final storedItems =
            ref.read(storedKanjisProvider.notifier).getStoresItems();
        addItem(
            storedItems.values.fold([], (previousValue, element) {
              previousValue.addAll(element);
              return previousValue;
            }),
            kanjiFromApi);
        setOnDismissibleActionStatus(OnDismissibleActionStatus.successAdded);
      } catch (e) {
        setOnDismissibleActionStatus(OnDismissibleActionStatus.noStarted);
      }
    } else {
      try {
        removeItem(kanjiFromApi);
        await deleteFavorite(kanjiFromApi.kanjiCharacter);
        setOnDismissibleActionStatus(OnDismissibleActionStatus.successRemoved);
      } catch (e) {
        logger.e(e);
        setOnDismissibleActionStatus(OnDismissibleActionStatus.noStarted);
      }
    }
  }

  void setOnDismissibleActionStatus(OnDismissibleActionStatus status) {
    state = FavoritesKanjisData(
        kanjisFromApi: state.kanjisFromApi,
        favoritesFetchingStatus: state.favoritesFetchingStatus,
        onDismissibleActionStatus: status);
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
    this.onDismissibleActionStatus = OnDismissibleActionStatus.noStarted,
  });
  final List<KanjiFromApi> kanjisFromApi;
  final FavoritesFetchingStatus favoritesFetchingStatus;
  final OnDismissibleActionStatus onDismissibleActionStatus;
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
