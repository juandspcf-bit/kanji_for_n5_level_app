import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_deleting_data.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/favorite_screen/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class KanjiListProvider extends Notifier<KanjiListData> {
  @override
  KanjiListData build() {
    return KanjiListData(
      kanjiList: [],
      status: 0,
      section: 1,
      errorDownload: ErrorDownload(
        kanjiCharacter: '',
        status: false,
      ),
      errorDeleting: ErrorDeleting(
        kanjiCharacter: '',
        status: false,
      ),
    );
  }

  final List<DownloadKanji> queuDownloadKanjis = [];
  final List<DeleteKanji> queuDeleteKanjis = [];

  void setErrorDownload(ErrorDownload errorDownload) {
    state = KanjiListData(
      kanjiList: state.kanjiList,
      section: state.section,
      status: state.status,
      errorDownload: errorDownload,
      errorDeleting: state.errorDeleting,
    );
  }

  void setErrorDelete(ErrorDeleting errorDeleting) {
    state = KanjiListData(
      kanjiList: state.kanjiList,
      section: state.section,
      status: state.status,
      errorDownload: state.errorDownload,
      errorDeleting: errorDeleting,
    );
  }

  void onSuccesRequest(List<KanjiFromApi> kanjisFromApi) {
    state = KanjiListData(
      kanjiList: kanjisFromApi,
      status: 1,
      section: kanjisFromApi.first.section,
      errorDownload: state.errorDownload,
      errorDeleting: state.errorDeleting,
    );
  }

  void onErrorRequest() {
    state = KanjiListData(
      kanjiList: [],
      status: 2,
      section: state.section,
      errorDownload: state.errorDownload,
      errorDeleting: state.errorDeleting,
    );
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
        section: kanjiListFromProvider.section,
        errorDownload: state.errorDownload,
        errorDeleting: state.errorDeleting,
      );
    } else {
      return KanjiListData(
        kanjiList: <KanjiFromApi>[],
        status: 1,
        section: kanjiListFromProvider.section,
        errorDownload: state.errorDownload,
        errorDeleting: state.errorDeleting,
      );
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

      kanjiList = kanjiList.map(
        (kanji) {
          if (isInTheDownloadQueue(kanji)) {
            return updateStatusKanji(
                StatusStorage.proccessingStoring, false, kanji);
          }
          return kanji;
        },
      ).toList();

      onSuccesRequest(kanjiList);
    } catch (e) {
      logger.e(e);
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
    state = KanjiListData(
      kanjiList: [],
      status: 0,
      section: section,
      errorDownload: ErrorDownload(
        kanjiCharacter: '',
        status: false,
      ),
      errorDeleting: ErrorDeleting(
        kanjiCharacter: '',
        status: false,
      ),
    );
  }

  void insertKanjiToStorage(
    KanjiFromApi kanjiFromApiOnline,
    ScreenSelection selection,
  ) async {
    try {
      final downloadKanji = DownloadKanji();
      queuDownloadKanjis.add(downloadKanji);

      updateKanjiStatusOnVisibleSectionList(
        updateStatusKanji(
          StatusStorage.proccessingStoring,
          false,
          kanjiFromApiOnline,
        ),
        state.errorDownload,
        state.errorDeleting,
      );

      final kanjiFromApiStored = await downloadKanji.storeKanjiToLocalDatabase(
        kanjiFromApiOnline,
        selection,
      );

      queuDownloadKanjis.remove(downloadKanji);

      if (kanjiFromApiStored == null) return;

      updateProviders(kanjiFromApiStored, selection);

      logger.i(kanjiFromApiStored);
      logger.d('success storing to db');
    } on TimeoutException {
      updateKanjiStatusOnVisibleSectionList(
        kanjiFromApiOnline,
        ErrorDownload(
          kanjiCharacter: kanjiFromApiOnline.kanjiCharacter,
          status: true,
        ),
        state.errorDeleting,
      );

      logger.e('Error storing time out'); // Prints "throws" after 2 seconds.
    } catch (e) {
      updateKanjiStatusOnVisibleSectionList(
        kanjiFromApiOnline,
        ErrorDownload(
          kanjiCharacter: kanjiFromApiOnline.kanjiCharacter,
          status: true,
        ),
        state.errorDeleting,
      );

      logger.e('Error storing');
      logger.e(e.toString());
    } finally {
      queuDownloadKanjis.removeWhere((element) =>
          element.kanjiCharacter == kanjiFromApiOnline.kanjiCharacter);
    }
  }

  bool isInTheDownloadQueue(KanjiFromApi kanji) {
    final copyKanjiList = [...queuDownloadKanjis];

    final kanjiIndex = copyKanjiList.indexWhere((element) {
      return element.kanjiCharacter == kanji.kanjiCharacter;
    });
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
    updateKanjiStatusOnVisibleSectionList(
      kanjiFromApiStored,
      state.errorDownload,
      state.errorDeleting,
    );
  }

  void updateKanjiStatusOnVisibleSectionList(
    KanjiFromApi kanji,
    ErrorDownload errorDownload,
    ErrorDeleting errorDeleting,
  ) {
    final copyState = [...state.kanjiList];

    final kanjiIndex = copyState.indexWhere(
        (element) => element.kanjiCharacter == kanji.kanjiCharacter);
    if (kanjiIndex == -1) return;
    copyState[kanjiIndex] = kanji;
    state = KanjiListData(
      kanjiList: copyState,
      status: state.status,
      section: state.section,
      errorDownload: errorDownload,
      errorDeleting: errorDeleting,
    );
  }

  void updateOnlineKanji(KanjiFromApi storedKanji) {
    final copyState = [...state.kanjiList];

    final kanjiIndex = copyState.indexWhere(
        (element) => element.kanjiCharacter == storedKanji.kanjiCharacter);
    if (kanjiIndex == -1) return;
    copyState[kanjiIndex] = storedKanji;
    state = KanjiListData(
      kanjiList: copyState,
      status: state.status,
      section: state.section,
      errorDownload: state.errorDownload,
      errorDeleting: state.errorDeleting,
    );
  }

  void deleteKanjiFromStorage(
    KanjiFromApi kanjiFromApiStored,
    ScreenSelection selection,
  ) async {
    KanjiFromApi? kanjiFromApiOnline;
    try {
      final deleteKanji = DeleteKanji();
      queuDeleteKanjis.add(deleteKanji);

      updateKanjiStatusOnVisibleSectionList(
        updateStatusKanji(
          StatusStorage.proccessingStoring,
          false,
          kanjiFromApiStored,
        ),
        state.errorDownload,
        state.errorDeleting,
      );

      kanjiFromApiOnline = await updateKanjiWithOnliVersion(kanjiFromApiStored);

      await deleteKanji.deleteKanjiFromLocalDatabase(
          kanjiFromApiStored, selection);

      queuDeleteKanjis.remove(deleteKanji);

      ref.read(storedKanjisProvider.notifier).deleteItem(kanjiFromApiStored);

      ref
          .read(favoriteskanjisProvider.notifier)
          .updateKanjiStatusOnVisibleFavoritesList(kanjiFromApiOnline);
      if (selection == ScreenSelection.kanjiSections) {
        ref
            .read(kanjiListProvider.notifier)
            .updateKanjiStatusOnVisibleSectionList(
              kanjiFromApiOnline,
              ErrorDownload(
                kanjiCharacter: kanjiFromApiStored.kanjiCharacter,
                status: false,
              ),
              ErrorDeleting(
                kanjiCharacter: '',
                status: false,
              ),
            );
      }
      logger.d('success deleting from db');
    } on TimeoutException {
      updateKanjiStatusOnVisibleSectionList(
        updateStatusKanji(
          StatusStorage.stored,
          false,
          kanjiFromApiStored,
        ),
        state.errorDownload,
        ErrorDeleting(
          kanjiCharacter: kanjiFromApiStored.kanjiCharacter,
          status: true,
        ),
      );

      logger.e('Error deleting time out');
    } catch (e) {
      ref.read(storedKanjisProvider.notifier).deleteItem(kanjiFromApiStored);
      if (kanjiFromApiOnline == null) return;
      ref
          .read(favoriteskanjisProvider.notifier)
          .updateKanjiStatusOnVisibleFavoritesList(kanjiFromApiOnline);
      if (selection == ScreenSelection.kanjiSections) {
        ref
            .read(kanjiListProvider.notifier)
            .updateKanjiStatusOnVisibleSectionList(
              kanjiFromApiOnline,
              state.errorDownload,
              ErrorDeleting(
                kanjiCharacter: kanjiFromApiOnline.kanjiCharacter,
                status: true,
              ),
            );
      }
      logger.e('error deleting');
      logger.e(e.toString());
    } finally {
      queuDeleteKanjis.removeWhere((element) =>
          element.kanjiCharacter == kanjiFromApiStored.kanjiCharacter);
    }
  }
}

final kanjiListProvider =
    NotifierProvider<KanjiListProvider, KanjiListData>(KanjiListProvider.new);

class KanjiListData {
  final List<KanjiFromApi> kanjiList;
  final int status;
  final int section;
  final ErrorDownload errorDownload;
  final ErrorDeleting errorDeleting;

  KanjiListData({
    required this.kanjiList,
    required this.status,
    required this.section,
    required this.errorDownload,
    required this.errorDeleting,
  });
}

class DownloadKanji {
  late String kanjiCharacter;

  Future<KanjiFromApi?> storeKanjiToLocalDatabase(
    KanjiFromApi kanjiFromApi,
    ScreenSelection selection,
  ) async {
    kanjiCharacter = kanjiFromApi.kanjiCharacter;
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

class ErrorDownload {
  final String kanjiCharacter;
  final bool status;

  ErrorDownload({required this.kanjiCharacter, required this.status});
}

class ErrorDeleting {
  final String kanjiCharacter;
  final bool status;

  ErrorDeleting({required this.kanjiCharacter, required this.status});
}

class DeleteKanji {
  late String kanjiCharacter;

  Future<void> deleteKanjiFromLocalDatabase(
    KanjiFromApi kanjiFromApi,
    ScreenSelection selection,
  ) async {
    kanjiCharacter = kanjiFromApi.kanjiCharacter;
    await localDBService.deleteKanjiFromLocalDatabase(
      kanjiFromApi,
      authService.user ?? '',
    );
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
