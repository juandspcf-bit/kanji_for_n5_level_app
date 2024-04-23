import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/queue_download_delete_provider.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/cache_kanji_list_provider.dart';

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

  Future<void> fetchKanjis({
    required List<String> kanjisCharacters,
    required int sectionNumber,
  }) async {
    try {
      clearKanjiList(sectionNumber);

      if (ref.read(cacheKanjiListProvider.notifier).isInCache(sectionNumber)) {
        final kanjiList = ref
            .read(cacheKanjiListProvider.notifier)
            .getFromCache(sectionNumber);
        onSuccesRequest(kanjiList);
        return;
      }

      final connectivityData = ref.read(statusConnectionProvider);
      if (connectivityData == ConnectivityResult.none) {
        final storedKanjisFromProvider = ref.read(storedKanjisProvider);

        if (storedKanjisFromProvider[state.section] != null &&
            storedKanjisFromProvider[state.section]!.isNotEmpty) {
          onSuccesRequest(storedKanjisFromProvider[state.section]!);
          return;
        }
        state = KanjiListData(
          kanjiList: <KanjiFromApi>[],
          status: 1,
          section: sectionNumber,
          errorDownload: state.errorDownload,
          errorDeleting: state.errorDeleting,
        );
        return;
      }

      List<KanjiFromApi> kanjiList = await ref
          .read(kanjiListProvider.notifier)
          .getKanjiListFromRepositories(
            kanjisCharacters,
            sectionNumber,
          );

      kanjiList = kanjiList.map(
        (kanji) {
          if (ref
              .read(queueDownloadDeleteProvider.notifier)
              .isInTheDownloadQueue(kanji.kanjiCharacter)) {
            logger.d('isn in the download queue ${kanji.kanjiCharacter}');
            return updateStatusKanji(
                StatusStorage.proccessingStoring, false, kanji);
          }
          return kanji;
        },
      ).toList();

      ref.read(cacheKanjiListProvider.notifier).addToCache(kanjiList);

      onSuccesRequest(kanjiList);
    } catch (e) {
      logger.e(e);
      onErrorRequest();
    }
  }

  Future<void> fetchKanjisOnRefresh({
    required List<String> kanjisCharacters,
    required int sectionNumber,
  }) async {
    try {
      clearKanjiList(sectionNumber);

      List<KanjiFromApi> kanjiList = await ref
          .read(kanjiListProvider.notifier)
          .getKanjiListFromRepositories(
            kanjisCharacters,
            sectionNumber,
          );

      kanjiList = kanjiList.map(
        (kanji) {
          if (ref
              .read(queueDownloadDeleteProvider.notifier)
              .isInTheDownloadQueue(kanji.kanjiCharacter)) {
            logger.d('isn in the download queue ${kanji.kanjiCharacter}');
            return updateStatusKanji(
                StatusStorage.proccessingStoring, false, kanji);
          }
          return kanji;
        },
      ).toList();

      final isInCache =
          ref.read(cacheKanjiListProvider.notifier).isInCache(sectionNumber);
      if (isInCache) {
        ref.read(cacheKanjiListProvider.notifier).updateListOnCache(kanjiList);
      } else {
        ref.read(cacheKanjiListProvider.notifier).addToCache(kanjiList);
      }

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

  void updateKanjiStatusOnVisibleSectionListFromOthers(
    KanjiFromApi kanji,
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
      errorDownload: state.errorDownload,
      errorDeleting: state.errorDeleting,
    );
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

class NoUserFound implements Exception {
  NoUserFound({required this.message});

  final String message;

  @override
  String toString() {
    return message;
  }
}
