import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/favorite.dart';
import 'package:kanji_for_n5_level_app/models/section_model.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
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

  void setInitialFavoritesWithInternetConnection(
    List<KanjiFromApi> storedKanjis,
    List<Favorite> myFavorites,
    int section,
  ) async {
    if (myFavorites.isEmpty) {
      state = const FavoritesKanjisData(
        favoritesKanjisFromApi: [],
        favoritesFetchingStatus: FavoritesFetchingStatus.successfulFetch,
      );
      return;
    }

    try {
      var kanjiList =
          await ref.read(kanjiApiServiceProvider).requestKanjiListToApi(
                storedKanjis,
                myFavorites.map((e) => e.kanji).toList(),
                section,
                ref.read(authServiceProvider).userUuid ?? '',
              );

      kanjiList = updateSectionInKanjiList(kanjiList);

      final List<FavoriteKanji> favoritesKanjiList = [];
      for (var i = 0; i < kanjiList.length; i++) {
        favoritesKanjiList.add(
          FavoriteKanji(
              kanjiFromApi: kanjiList[i], timeStamp: myFavorites[i].timeStamp),
        );
      }

      favoritesKanjiList.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));

      onSuccessRequest(favoritesKanjiList);
    } catch (e) {
      logger.e(e);
      onErrorRequest();
    }
  }

  List<KanjiFromApi> updateSectionInKanjiList(List<KanjiFromApi> kanjiList) {
    kanjiList = kanjiList.map((kanji) {
      final kanjiCharacter = kanji.kanjiCharacter;
      final sectionsEntries = sectionsKanjis.entries.where((element) {
        return element.value
                .indexWhere((character) => character == kanjiCharacter) !=
            -1;
      }).toList();
      var section = sectionsEntries.isNotEmpty ? sectionsEntries.first.key : '';

      section = section.replaceAll('section', '').trim();

      return KanjiFromApi(
          kanjiCharacter: kanji.kanjiCharacter,
          englishMeaning: kanji.englishMeaning,
          kanjiImageLink: kanji.kanjiImageLink,
          katakanaRomaji: kanji.katakanaRomaji,
          katakanaMeaning: kanji.katakanaMeaning,
          hiraganaRomaji: kanji.hiraganaRomaji,
          hiraganaMeaning: kanji.hiraganaMeaning,
          section: int.parse(section),
          videoLink: kanji.videoLink,
          statusStorage: kanji.statusStorage,
          accessToKanjiItemsButtons: kanji.accessToKanjiItemsButtons,
          example: kanji.example,
          strokes: kanji.strokes);
    }).toList();
    return kanjiList;
  }

  Future<void> fetchFavoritesOnRefresh() async {
    state = const FavoritesKanjisData(
      favoritesKanjisFromApi: [],
      favoritesFetchingStatus: FavoritesFetchingStatus.noStarted,
    );
    List<KanjiFromApi> storedKanjis =
        await ref.read(mainScreenProvider.notifier).loadStoredKanjis();
    final favoritesKanjisFromDB = await ref
        .read(localDBServiceProvider)
        .loadFavoritesDatabase(ref.read(authServiceProvider).userUuid ?? '');
    if (favoritesKanjisFromDB.isEmpty) {
      state = const FavoritesKanjisData(
        favoritesKanjisFromApi: [],
        favoritesFetchingStatus: FavoritesFetchingStatus.successfulFetch,
      );
      return;
    }

    try {
      var kanjiListFromAPI =
          await ref.read(kanjiApiServiceProvider).requestKanjiListToApi(
                storedKanjis,
                favoritesKanjisFromDB.map((e) => e.kanji).toList(),
                10,
                ref.read(authServiceProvider).userUuid ?? '',
              );

      kanjiListFromAPI = updateSectionInKanjiList(kanjiListFromAPI);

      final List<FavoriteKanji> favoritesKanjiList = [];
      for (var i = 0; i < favoritesKanjisFromDB.length; i++) {
        favoritesKanjiList.add(
          FavoriteKanji(
              kanjiFromApi: kanjiListFromAPI[i],
              timeStamp: favoritesKanjisFromDB[i].timeStamp),
        );
      }

      favoritesKanjiList.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));

      onSuccessRequest(favoritesKanjiList);
    } catch (e) {
      onErrorRequest();
    }
  }

  void setInitialFavoritesWithNoInternetConnection(
    List<KanjiFromApi> storedKanjis,
    List<Favorite> myFavoritesCached,
    int section,
  ) {
    if (myFavoritesCached.isEmpty) {
      state = const FavoritesKanjisData(
        favoritesKanjisFromApi: [],
        favoritesFetchingStatus: FavoritesFetchingStatus.successfulFetch,
      );
      return;
    }

    List<KanjiFromApi> favoriteKanjisStored = [];

    for (var favorite in myFavoritesCached) {
      try {
        final favoriteStored =
            storedKanjis.firstWhere((e) => e.kanjiCharacter == favorite.kanji);
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

    onSuccessRequest(favoritesKanjiList);
  }

  void onSuccessRequest(List<FavoriteKanji> kanjisFromApi) {
    state = FavoritesKanjisData(
      favoritesKanjisFromApi: kanjisFromApi,
      favoritesFetchingStatus: FavoritesFetchingStatus.successfulFetch,
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

  void removeItem(KanjiFromApi favoriteKanjiFromApi) {
    final copyState = [...state.favoritesKanjisFromApi];
    int index = copyState.indexWhere((element) =>
        element.kanjiFromApi.kanjiCharacter ==
        favoriteKanjiFromApi.kanjiCharacter);
    copyState.removeAt(index);
    state = FavoritesKanjisData(
      favoritesKanjisFromApi: [...copyState],
      favoritesFetchingStatus: state.favoritesFetchingStatus,
      dismissedKanji: state.dismissedKanji,
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

  void updateKanjiStatusOnVisibleFavoritesList(KanjiFromApi storedKanji) {
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

  void updateKanjiStatusOnVisibleFavoritesListFromOthers(
      KanjiFromApi storedKanji) {
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

  void updateProviders(KanjiFromApi kanjiFromApiStored) {
    ref.read(storedKanjisProvider.notifier).addItem(kanjiFromApiStored);

    ref
        .read(favoritesKanjisProvider.notifier)
        .updateKanjiStatusOnVisibleFavoritesList(kanjiFromApiStored);
  }

  Future<void> dismissFavorite(KanjiFromApi kanjiFromApi) async {
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

      await ref.read(cloudDBServiceProvider).deleteFavoriteCloudDB(
            kanjiFromApi.kanjiCharacter,
            ref.read(authServiceProvider).userUuid ?? '',
          );

      await ref
          .read(localDBServiceProvider)
          .deleteFavorite(kanjiFromApi.kanjiCharacter);
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
      dismissedKanji: state.dismissedKanji,
      onDismissibleActionStatus: status,
    );
  }

  Future<void> restoreFavorite(FavoriteKanji favoriteKanji, int index) async {
    try {
      await ref.read(cloudDBServiceProvider).insertFavoriteCloudDB(
            favoriteKanji.kanjiFromApi.kanjiCharacter,
            favoriteKanji.timeStamp,
            ref.read(authServiceProvider).userUuid ?? '',
          );

      await ref.read(localDBServiceProvider).insertFavorite(
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
        dismissedKanji: state.dismissedKanji,
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
      dismissedKanji: DismissedKanji(
        kanjiFromApiFromDismissibleAction: kanjiFromApi,
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
                StatusStorage.processingStoring ||
            element.kanjiFromApi.statusStorage ==
                StatusStorage.processingDeleting,
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
    this.dismissedKanji,
    this.onDismissibleActionStatus = OnDismissibleActionStatus.noStarted,
  });
  final List<FavoriteKanji> favoritesKanjisFromApi;
  final FavoritesFetchingStatus favoritesFetchingStatus;
  final OnDismissibleActionStatus onDismissibleActionStatus;
  final DismissedKanji? dismissedKanji;
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

class DismissedKanji {
  DismissedKanji(
      {required this.kanjiFromApiFromDismissibleAction, required this.index});
  final FavoriteKanji kanjiFromApiFromDismissibleAction;
  final int index;
}

enum FavoritesFetchingStatus {
  noStarted('no started'),
  successfulFetch('Your favorites were successfully fetched'),
  errorFetch('Error in fetching favorites');

  const FavoritesFetchingStatus(this.message);
  final String message;
}

final favoritesKanjisProvider =
    NotifierProvider<FavoritesListProvider, FavoritesKanjisData>(
        FavoritesListProvider.new);
