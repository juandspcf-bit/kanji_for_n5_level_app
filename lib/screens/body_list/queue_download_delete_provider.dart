import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_deleting_data.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/favorite_screen/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/sections_screen/cache_kanji_list_provider.dart';

class QueueDownloadDeleteProvider extends Notifier<QueueData> {
  void removeDownload(String kanjiCharacter) {
    final downloadKankiQueue = [...state.downloadKankiQueue];
    downloadKankiQueue
        .removeWhere((element) => element.kanjiCharacter == kanjiCharacter);
    state = QueueData(
      downloadKankiQueue: downloadKankiQueue,
      deleteKanjiQueue: state.deleteKanjiQueue,
    );
  }

  void removeDelete(String kanjiCharacter) {
    final deleteKanjiQueue = [...state.deleteKanjiQueue];
    deleteKanjiQueue
        .removeWhere((element) => element.kanjiCharacter == kanjiCharacter);
    state = QueueData(
      downloadKankiQueue: state.downloadKankiQueue,
      deleteKanjiQueue: deleteKanjiQueue,
    );
  }

  bool addDownload(String kanjiCharacter, DownloadKanji downloadKanji) {
    final downloadKankiQueue = [...state.downloadKankiQueue];
    int index = downloadKankiQueue
        .indexWhere((element) => element.kanjiCharacter == kanjiCharacter);
    if (index != -1) return false;

    downloadKankiQueue.add(downloadKanji);
    state = QueueData(
      downloadKankiQueue: downloadKankiQueue,
      deleteKanjiQueue: state.deleteKanjiQueue,
    );
    return true;
  }

  bool addDelete(String kanjiCharacter, DeleteKanji deleteKanji) {
    final deleteKanjiQueue = [...state.deleteKanjiQueue];
    int index = deleteKanjiQueue
        .indexWhere((element) => element.kanjiCharacter == kanjiCharacter);
    if (index != -1) return false;

    deleteKanjiQueue.add(deleteKanji);
    state = QueueData(
      downloadKankiQueue: state.downloadKankiQueue,
      deleteKanjiQueue: deleteKanjiQueue,
    );
    return true;
  }

  bool isInTheDownloadQueue(String kanjiCharacter) {
    int index = state.downloadKankiQueue
        .indexWhere((element) => element.kanjiCharacter == kanjiCharacter);
    return index != -1;
  }

  void insertKanjiToStorage(
    KanjiFromApi kanjiFromApiOnline,
  ) async {
    try {
      final downloadKanji = DownloadKanji(
        kanjiCharacter: kanjiFromApiOnline.kanjiCharacter,
        kanjiFromApi: kanjiFromApiOnline,
      );
      addDownload(
        kanjiFromApiOnline.kanjiCharacter,
        downloadKanji,
      );

      updateKanjisOnVisibleList(
        updateStatusKanji(
          StatusStorage.proccessingStoring,
          false,
          kanjiFromApiOnline,
        ),
      );

      final kanjiFromApiStored =
          await downloadKanji.storeKanjiToLocalDatabase();

      if (kanjiFromApiStored == null) {
        updateKanjisOnVisibleList(kanjiFromApiOnline);
        return;
      }

      logger.i(kanjiFromApiStored);
      logger.d('success storing to db');
      ref.read(storedKanjisProvider.notifier).addItem(kanjiFromApiStored);

      updateKanjisOnVisibleList(kanjiFromApiStored);
    } on TimeoutException {
      updateKanjisOnVisibleList(kanjiFromApiOnline);

      logger.e('Error storing time out'); // Prints "throws" after 2 seconds.
    } catch (e) {
      updateKanjisOnVisibleList(kanjiFromApiOnline);

      logger.e('Error storing');
      logger.e(e.toString());
    } finally {
      removeDownload(kanjiFromApiOnline.kanjiCharacter);
    }
  }

  void deleteKanjiFromStorage(
    KanjiFromApi kanjiFromApiStored,
  ) async {
    KanjiFromApi? kanjiFromApiOnline;
    try {
      final deleteKanji = DeleteKanji(
        kanjiCharacter: kanjiFromApiStored.kanjiCharacter,
        kanjiFromApi: kanjiFromApiStored,
      );
      addDelete(
        kanjiFromApiStored.kanjiCharacter,
        deleteKanji,
      );

      updateKanjisOnVisibleList(
        updateStatusKanji(
          StatusStorage.proccessingDeleting,
          false,
          kanjiFromApiStored,
        ),
      );

      kanjiFromApiOnline = await updateKanjiWithOnliVersion(kanjiFromApiStored);

      await deleteKanji.deleteKanjiFromLocalDatabase();

      logger.d('success storing to db');
      ref.read(storedKanjisProvider.notifier).deleteItem(kanjiFromApiStored);

      updateKanjisOnVisibleList(kanjiFromApiOnline);
    } on TimeoutException {
      updateKanjisOnVisibleList(kanjiFromApiStored);

      logger.e('Error storing time out'); // Prints "throws" after 2 seconds.
    } catch (e) {
      ref.read(storedKanjisProvider.notifier).deleteItem(kanjiFromApiStored);
      if (kanjiFromApiOnline == null) return;
      updateKanjisOnVisibleList(kanjiFromApiOnline);

      logger.e('Error storing');
      logger.e(e.toString());
    } finally {
      removeDelete(kanjiFromApiStored.kanjiCharacter);
    }
  }

  void updateKanjisOnVisibleList(KanjiFromApi kanjiFromApi) {
    ref
        .read(favoriteskanjisProvider.notifier)
        .updateKanjiStatusOnVisibleFavoritesList(
          kanjiFromApi,
        );
    ref
        .read(kanjiListProvider.notifier)
        .updateKanjiStatusOnVisibleSectionListFromOthers(
          kanjiFromApi,
        );
    ref.read(cacheKanjiListProvider.notifier).updateKanjiOnCache(kanjiFromApi);
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

  @override
  QueueData build() {
    return QueueData(
      downloadKankiQueue: [],
      deleteKanjiQueue: [],
    );
  }
}

final queueDownloadDeleteProvider =
    NotifierProvider<QueueDownloadDeleteProvider, QueueData>(
        QueueDownloadDeleteProvider.new);

class QueueData {
  final List<DownloadKanji> downloadKankiQueue;
  final List<DeleteKanji> deleteKanjiQueue;

  QueueData({
    required this.downloadKankiQueue,
    required this.deleteKanjiQueue,
  });
}

class DownloadKanji {
  final String kanjiCharacter;
  final KanjiFromApi kanjiFromApi;

  DownloadKanji({
    required this.kanjiCharacter,
    required this.kanjiFromApi,
  });

  Future<KanjiFromApi?> storeKanjiToLocalDatabase() async {
    final kanjiFromApiStored = await localDBService.storeKanjiToLocalDatabase(
      kanjiFromApi,
      authService.user ?? '',
    );

    if (kanjiFromApiStored == null) return null;

    return kanjiFromApiStored;
  }
}

class DeleteKanji {
  final String kanjiCharacter;
  final KanjiFromApi kanjiFromApi;

  DeleteKanji({
    required this.kanjiCharacter,
    required this.kanjiFromApi,
  });

  Future<void> deleteKanjiFromLocalDatabase() async {
    await localDBService.deleteKanjiFromLocalDatabase(
      kanjiFromApi,
      authService.user ?? '',
    );
  }
}
