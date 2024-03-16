import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_deleting_data.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/error_storing_database_status.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/favorite_screen/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class KanjiListProvider extends Notifier<KanjiListData> {
  @override
  KanjiListData build() {
    return KanjiListData(kanjiList: [], status: 0, section: 1);
  }

  final List<DownloadedKanji> queuDownloadKanjis = [];

  void onSuccesRequest(List<KanjiFromApi> kanjisFromApi) {
    state = KanjiListData(
        kanjiList: kanjisFromApi,
        status: 1,
        section: kanjisFromApi.first.section);
  }

  void onErrorRequest() {
    state = KanjiListData(kanjiList: [], status: 2, section: state.section);
  }

  bool isAnyProcessingData() {
    try {
      state.kanjiList.firstWhere(
        (element) =>
            element.statusStorage == StatusStorage.proccessingStoring ||
            element.statusStorage == StatusStorage.proccessingDeleting,
      );

      return true;
    } on StateError {
      return false;
    }
  }

  KanjiListData getOfflineKanjiList(KanjiListData kanjiList) {
    final kanjiListFromProvider = kanjiList;
    final storedKanjisFromProvider = ref.read(storedKanjisProvider);

    if (storedKanjisFromProvider[kanjiListFromProvider.section] != null &&
        storedKanjisFromProvider[kanjiListFromProvider.section]!.isNotEmpty) {
      return KanjiListData(
          kanjiList: storedKanjisFromProvider[kanjiListFromProvider.section]!,
          status: 1,
          section: kanjiListFromProvider.section);
    } else {
      return KanjiListData(
          kanjiList: <KanjiFromApi>[],
          status: 1,
          section: kanjiListFromProvider.section);
    }
  }

  Future<void> fetchKanjis(
      {required List<String> kanjisCharacters,
      required int sectionNumber}) async {
    try {
      List<KanjiFromApi> kanjiList = await ref
          .read(kanjiListProvider.notifier)
          .getKanjiListFromRepositories(
            kanjisCharacters,
            sectionNumber,
          );

      for (var kanji in kanjiList) {
        isInTheDownloadQueue(kanji);
      }

      kanjiList.map(
        (kanji) {
          if (isInTheDownloadQueue(kanji)) {
            return updateStatusKanji(
                StatusStorage.proccessingStoring, false, kanji);
          }
        },
      );

      onSuccesRequest(kanjiList);
    } catch (e) {
      onErrorRequest();
    }
  }

  Future<List<KanjiFromApi>> getKanjiListFromRepositories(
    List<String> kanjisCharacteres,
    int section,
  ) {
    final storedKanjis =
        ref.read(storedKanjisProvider.notifier).getStoresItems();

    return applicationApiService.requestKanjiListToApi(
      storedKanjis[section] ?? [],
      kanjisCharacteres,
      section,
    );
  }

  void clearKanjiList(int section) {
    state = KanjiListData(kanjiList: [], status: 0, section: section);
  }

  void insertKanjiToStorage(
    KanjiFromApi kanjiFromApiOnline,
    ScreenSelection selection,
  ) async {
    try {
      final downloadKanji = DownloadedKanji();
      queuDownloadKanjis.add(downloadKanji);

      updateKanjiStatusOnVisibleSectionList(
        updateStatusKanji(
            StatusStorage.proccessingStoring, false, kanjiFromApiOnline),
      );

      final kanjiFromApiStored = await downloadKanji.storeKanjiToLocalDatabase(
          kanjiFromApiOnline, selection);

      if (kanjiFromApiStored == null) return;

      updateProviders(kanjiFromApiStored, selection);

      logger.i(kanjiFromApiStored);
      logger.d('success storing to db');
    } on TimeoutException {
      updateKanjiStatusOnVisibleSectionList(
        kanjiFromApiOnline,
      );

      logger.e('Error storing time out'); // Prints "throws" after 2 seconds.
    } catch (e) {
      updateKanjiStatusOnVisibleSectionList(
        kanjiFromApiOnline,
      );

      logger.e('Error storing');
      logger.e(e.toString());
    }
  }

  bool isInTheDownloadQueue(KanjiFromApi kanji) {
    final copyKanjiList = [...queuDownloadKanjis];

    final kanjiIndex = copyKanjiList.indexWhere((element) =>
        element.kanjiFromApi.kanjiCharacter == kanji.kanjiCharacter);
    return kanjiIndex != -1;
  }

  KanjiFromApi updateStatusKanji(
    StatusStorage statusStorage,
    bool accessToKanjiItemsButtons,
    KanjiFromApi kanjiFromApi,
  ) {
    return KanjiFromApi(
        kanjiCharacter: kanjiFromApi.kanjiCharacter,
        englishMeaning: kanjiFromApi.englishMeaning,
        kanjiImageLink: kanjiFromApi.kanjiImageLink,
        katakanaMeaning: kanjiFromApi.katakanaMeaning,
        hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
        videoLink: kanjiFromApi.videoLink,
        section: kanjiFromApi.section,
        statusStorage: statusStorage,
        accessToKanjiItemsButtons: accessToKanjiItemsButtons,
        example: kanjiFromApi.example,
        strokes: kanjiFromApi.strokes);
  }

  void updateProviders(
    KanjiFromApi kanjiFromApiStored,
    ScreenSelection selection,
  ) {
    ref.read(storedKanjisProvider.notifier).addItem(kanjiFromApiStored);

    ref
        .read(favoriteskanjisProvider.notifier)
        .updateKanjiStatusOnVisibleFavoritesList(kanjiFromApiStored);
    updateKanjiStatusOnVisibleSectionList(kanjiFromApiStored);
  }

  void updateKanjiStatusOnVisibleSectionList(KanjiFromApi storedKanji) {
    final copyState = [...state.kanjiList];

    final kanjiIndex = copyState.indexWhere(
        (element) => element.kanjiCharacter == storedKanji.kanjiCharacter);
    if (kanjiIndex == -1) return;
    copyState[kanjiIndex] = storedKanji;
    state = KanjiListData(
        kanjiList: copyState, status: state.status, section: state.section);
  }

  void updateOnlineKanji(KanjiFromApi storedKanji) {
    final copyState = [...state.kanjiList];

    final kanjiIndex = copyState.indexWhere(
        (element) => element.kanjiCharacter == storedKanji.kanjiCharacter);
    if (kanjiIndex == -1) return;
    copyState[kanjiIndex] = storedKanji;
    state = KanjiListData(
        kanjiList: copyState, status: state.status, section: state.section);
  }

  void deleteKanjiFromStorage(
    KanjiFromApi kanjiFromApi,
    ScreenSelection selection,
  ) async {
    try {
      await localDBService.deleteKanjiFromLocalDatabase(kanjiFromApi);

      ref.read(storedKanjisProvider.notifier).deleteItem(kanjiFromApi);

      final kanjiList = await updateKanjiWithOnliVersion(kanjiFromApi);
      ref
          .read(favoriteskanjisProvider.notifier)
          .updateKanjiStatusOnVisibleFavoritesList(kanjiList[0]);
      if (selection == ScreenSelection.kanjiSections) {
        ref
            .read(kanjiListProvider.notifier)
            .updateKanjiStatusOnVisibleSectionList(kanjiList[0]);
      }
      logger.d('success deleting from db');
    } catch (e) {
      ref
          .read(favoriteskanjisProvider.notifier)
          .updateKanjiStatusOnVisibleFavoritesList(
              updateStatusKanjiComputeVersion(
                  StatusStorage.errorDeleting, true, kanjiFromApi));
      if (selection == ScreenSelection.kanjiSections) {
        ref
            .read(kanjiListProvider.notifier)
            .updateKanjiStatusOnVisibleSectionList(
                updateStatusKanjiComputeVersion(
                    StatusStorage.errorDeleting, true, kanjiFromApi));
      }
      ref.read(errorDatabaseStatusProvider.notifier).setDeletingError(true);

      logger.e('error deleting');
      logger.e(e.toString());
    }
  }
}

final kanjiListProvider =
    NotifierProvider<KanjiListProvider, KanjiListData>(KanjiListProvider.new);

class KanjiListData {
  final List<KanjiFromApi> kanjiList;
  final int status;
  final int section;

  KanjiListData({
    required this.kanjiList,
    required this.status,
    required this.section,
  });
}

class DownloadedKanji {
  late KanjiFromApi kanjiFromApi;
  DownloadedKanji();

  Future<KanjiFromApi?> storeKanjiToLocalDatabase(
    KanjiFromApi kanjiFromApi,
    ScreenSelection selection,
  ) async {
    final kanjiFromApiStored = await localDBService.storeKanjiToLocalDatabase(
      kanjiFromApi,
      authService.user ?? '',
    );

    if (kanjiFromApiStored == null) return null;

    //updateProviders(kanjiFromApiStored, selection);
    logger.i(kanjiFromApiStored);
    logger.d('success storing to db');
    return kanjiFromApiStored;
  }
}

class NoUserFound implements Exception {
  NoUserFound({required this.message});

  final String message;

  @override
  String toString() {
    return message;
  }
}
