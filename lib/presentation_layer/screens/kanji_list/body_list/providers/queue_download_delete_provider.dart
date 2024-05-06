import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/providers/error_download_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/favorite_screen/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/cache_kanji_list_provider.dart';

class QueueDownloadDelete extends Notifier<QueueData> {
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

      final kanjiData = await ref
          .read(cloudDBServiceProvider)
          .fetchKanjiData(kanjiFromApiOnline.kanjiCharacter);

      final imageMeaningData = ImageDetailsLink(
        kanji: kanjiData['kanji'] as String,
        link: kanjiData['link'] as String,
        linkHeight: kanjiData['linkHeight'],
        linkWidth: kanjiData['linkWidth'],
      );

      final kanjiFromApiStored =
          await ref.read(localDBServiceProvider).storeKanjiToLocalDatabase(
                kanjiFromApiOnline,
                imageMeaningData,
                ref.read(authServiceProvider).userUuid ?? '',
              );

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

      ref
          .read(errorDownloadProvider.notifier)
          .setKanjiError(kanjiFromApiOnline.kanjiCharacter);

      logger.e('Error storing time out');
    } catch (e) {
      updateKanjisOnVisibleList(kanjiFromApiOnline);

      ref
          .read(errorDownloadProvider.notifier)
          .setKanjiError(kanjiFromApiOnline.kanjiCharacter);

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

      kanjiFromApiOnline =
          await ref.read(applicationApiServiceProvider).requestSingleKanjiToApi(
                kanjiFromApiStored.kanjiCharacter,
                kanjiFromApiStored.section,
                ref.read(authServiceProvider).userUuid ?? '',
              );

      await ref.read(localDBServiceProvider).deleteKanjiFromLocalDatabase(
            kanjiFromApiStored,
            ref.read(authServiceProvider).userUuid ?? '',
          );

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
    NotifierProvider<QueueDownloadDelete, QueueData>(QueueDownloadDelete.new);

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
}

class DeleteKanji {
  final String kanjiCharacter;
  final KanjiFromApi kanjiFromApi;

  DeleteKanji({
    required this.kanjiCharacter,
    required this.kanjiFromApi,
  });
}
