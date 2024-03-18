import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/favorite_screen/favorites_kanjis_provider.dart';

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
    if (index == -1) return false;

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
    if (index == -1) return false;

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
    return index == -1;
  }

  void insertKanjiToStorage(
    KanjiFromApi kanjiFromApiOnline,
    ScreenSelection selection,
  ) async {
    try {
      final downloadKanji = DownloadKanji();
      addDownload(
        kanjiFromApiOnline.kanjiCharacter,
        downloadKanji,
      );

      ref
          .read(kanjiListProvider.notifier)
          .updateKanjiStatusOnVisibleSectionListFromOthers(
            updateStatusKanji(
              StatusStorage.proccessingStoring,
              false,
              kanjiFromApiOnline,
            ),
          );

      ref
          .read(favoriteskanjisProvider.notifier)
          .updateKanjiStatusOnVisibleFavoritesListFromOthers(
            updateStatusKanji(
              StatusStorage.proccessingStoring,
              false,
              kanjiFromApiOnline,
            ),
          );

      final kanjiFromApiStored = await downloadKanji.storeKanjiToLocalDatabase(
        kanjiFromApiOnline,
        selection,
      );

      if (kanjiFromApiStored == null) return;
      logger.i(kanjiFromApiStored);
      logger.d('success storing to db');
      ref.read(storedKanjisProvider.notifier).addItem(kanjiFromApiStored);

      ref
          .read(favoriteskanjisProvider.notifier)
          .updateKanjiStatusOnVisibleFavoritesList(kanjiFromApiStored);
      ref
          .read(kanjiListProvider.notifier)
          .updateKanjiStatusOnVisibleSectionListFromOthers(
            updateStatusKanji(
              StatusStorage.proccessingStoring,
              false,
              kanjiFromApiStored,
            ),
          );

/*      _queueDownloadKanjis.remove(downloadKanji);

      if (kanjiFromApiStored == null) return;

      updateProviders(kanjiFromApiStored, selection); 
*/
    } on TimeoutException {
/*       updateKanjiStatusOnVisibleSectionList(
        kanjiFromApiOnline,
        ErrorDownload(
          kanjiCharacter: kanjiFromApiOnline.kanjiCharacter,
          status: true,
        ),
        state.errorDeleting,
      ); */

      logger.e('Error storing time out'); // Prints "throws" after 2 seconds.
    } catch (e) {
/*       updateKanjiStatusOnVisibleSectionList(
        kanjiFromApiOnline,
        ErrorDownload(
          kanjiCharacter: kanjiFromApiOnline.kanjiCharacter,
          status: true,
        ),
        state.errorDeleting,
      ); */

      logger.e('Error storing');
      logger.e(e.toString());
    } finally {
      removeDownload(kanjiFromApiOnline.kanjiCharacter);
    }
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
