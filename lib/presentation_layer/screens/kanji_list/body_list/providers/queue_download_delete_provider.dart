import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/providers/error_delete_providers.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/providers/error_download_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/favorite_screen/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/cache_kanji_list_provider.dart';

import '../kanjis_list_provider.dart';

class QueueDownloadDelete extends Notifier<QueueData> {
  void removeDownload(String kanjiCharacter) {
    final downloadKanjiQueue = [...state.downloadKanjiQueue];
    downloadKanjiQueue
        .removeWhere((element) => element.kanjiCharacter == kanjiCharacter);
    state = QueueData(
      downloadKanjiQueue: downloadKanjiQueue,
      deleteKanjiQueue: state.deleteKanjiQueue,
    );
  }

  void removeDelete(String kanjiCharacter) {
    final deleteKanjiQueue = [...state.deleteKanjiQueue];
    deleteKanjiQueue
        .removeWhere((element) => element.kanjiCharacter == kanjiCharacter);
    state = QueueData(
      downloadKanjiQueue: state.downloadKanjiQueue,
      deleteKanjiQueue: deleteKanjiQueue,
    );
  }

  bool addDownload(String kanjiCharacter, DownloadKanji downloadKanji) {
    final downloadKanjiQueue = [...state.downloadKanjiQueue];
    int index = downloadKanjiQueue
        .indexWhere((element) => element.kanjiCharacter == kanjiCharacter);
    if (index != -1) return false;

    downloadKanjiQueue.add(downloadKanji);
    state = QueueData(
      downloadKanjiQueue: downloadKanjiQueue,
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
      downloadKanjiQueue: state.downloadKanjiQueue,
      deleteKanjiQueue: deleteKanjiQueue,
    );
    return true;
  }

  bool isInTheDownloadQueue(String kanjiCharacter) {
    int index = state.downloadKanjiQueue
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
          StatusStorage.processingStoring,
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
          StatusStorage.processingDeleting,
          false,
          kanjiFromApiStored,
        ),
      );

      kanjiFromApiOnline =
          await ref.read(kanjiApiServiceProvider).requestSingleKanjiToApi(
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

      ref
          .read(errorDeleteProvider.notifier)
          .setKanjiError(kanjiFromApiStored.kanjiCharacter);

      logger.e('Error storing time out'); // Prints "throws" after 2 seconds.
    } catch (e) {
      ref.read(storedKanjisProvider.notifier).deleteItem(kanjiFromApiStored);
      if (kanjiFromApiOnline == null) return;
      updateKanjisOnVisibleList(kanjiFromApiOnline);

      ref
          .read(errorDeleteProvider.notifier)
          .setKanjiError(kanjiFromApiStored.kanjiCharacter);

      logger.e('Error storing');
      logger.e(e.toString());
    } finally {
      removeDelete(kanjiFromApiStored.kanjiCharacter);
    }
  }

  void updateKanjisOnVisibleList(KanjiFromApi kanjiFromApi) {
    ref
        .read(favoritesKanjisProvider.notifier)
        .updateKanjiStatusOnVisibleFavoritesList(
          kanjiFromApi,
        );
    ref
        .read(
            kanjiListProvider(kanjisCharacters: [], sectionNumber: 0).notifier)
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
        katakanaRomaji: kanjiFromApi.katakanaRomaji,
        katakanaMeaning: kanjiFromApi.katakanaMeaning,
        hiraganaRomaji: kanjiFromApi.hiraganaRomaji,
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
      downloadKanjiQueue: [],
      deleteKanjiQueue: [],
    );
  }
}

final queueDownloadDeleteProvider =
    NotifierProvider<QueueDownloadDelete, QueueData>(QueueDownloadDelete.new);

class QueueData {
  final List<DownloadKanji> downloadKanjiQueue;
  final List<DeleteKanji> deleteKanjiQueue;

  QueueData({
    required this.downloadKanjiQueue,
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
