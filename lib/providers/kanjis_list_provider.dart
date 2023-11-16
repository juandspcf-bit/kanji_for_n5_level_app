import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/Databases/db_computes_functions_for_deleting_data.dart';
import 'package:kanji_for_n5_level_app/Databases/db_computes_functions_for_inserting_data.dart';
import 'package:kanji_for_n5_level_app/Databases/download_db_utils.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/networking/request_api.dart';
import 'package:kanji_for_n5_level_app/providers/error_storing_database_status.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_cached_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_content.dart';
import 'package:path_provider/path_provider.dart';

class KanjiListProvider extends Notifier<KanjiListData> {
  @override
  KanjiListData build() {
    return KanjiListData(kanjiList: [], status: 0, section: 1);
  }

  void onSuccesRequest(List<KanjiFromApi> kanjisFromApi) {
    state = KanjiListData(
        kanjiList: kanjisFromApi,
        status: 1,
        section: kanjisFromApi.first.section);
  }

  void onErrorRequest() {
    state = KanjiListData(kanjiList: [], status: 2, section: state.section);
  }

  void updateKanji(KanjiFromApi storedKanji) {
    final copyState = [...state.kanjiList];

    final kanjiIndex = copyState.indexWhere(
        (element) => element.kanjiCharacter == storedKanji.kanjiCharacter);
    if (kanjiIndex == -1) return;
    copyState[kanjiIndex] = storedKanji;
    state = KanjiListData(
        kanjiList: copyState, status: state.status, section: state.section);
  }

  void setKanjiList(
    List<KanjiFromApi> storedKanjis,
    List<String> kanjisCharacteres,
    int section,
  ) {
    RequestApi.getKanjis(
      storedKanjis,
      kanjisCharacteres,
      section,
      onSuccesRequest,
      onErrorRequest,
    );
  }

  void setKanjiListFromRepositories(
    List<String> kanjisCharacteres,
    int section,
  ) {
    clearKanjiList(section);
    final storedKanjis =
        ref.read(statusStorageProvider.notifier).getStoresItems();

    RequestApi.getKanjis(
      storedKanjis[section] ?? [],
      kanjisCharacteres,
      section,
      onSuccesRequest,
      onErrorRequest,
    );
  }

  void clearKanjiList(int section) {
    state = KanjiListData(kanjiList: [], status: 0, section: section);
  }

  void insertKanjiToStorageComputeVersion(
      KanjiFromApi kanjiFromApi, int selection) async {
    try {
      final dirDocumentPath = await getApplicationDocumentsDirectory();
      final kanjiFromApiStored = await compute(
          insertKanjiFromApiComputeVersion,
          ParametersCompute(
            kanjiFromApi: kanjiFromApi,
            path: dirDocumentPath,
          ));

      insertPathsInDB(kanjiFromApiStored);
      ref.read(statusStorageProvider.notifier).addItem(kanjiFromApiStored);

      ref.read(favoritesListProvider.notifier).updateKanji(kanjiFromApiStored);

      if (selection == 0) {
        ref.read(kanjiListProvider.notifier).updateKanji(kanjiFromApiStored);
      }
      logger.i(kanjiFromApiStored);
      logger.d('success');
    } catch (e) {
      logger.e('error sotoring');
      logger.e(e.toString());
    }
  }

  void deleteKanjiFromStorageComputeVersion(
    KanjiFromApi kanjiFromApi,
    int selection,
  ) async {
    try {
      final db = await kanjiFromApiDatabase;

      final listKanjiMapFromDb = await db.rawQuery(
          'SELECT * FROM kanji_FromApi WHERE kanjiCharacter = ? ',
          [kanjiFromApi.kanjiCharacter]);
      final listMapExamplesFromDb = await db.rawQuery(
          'SELECT * FROM examples WHERE kanjiCharacter = ? ',
          [kanjiFromApi.kanjiCharacter]);
      final listMapStrokesImagesLisnkFromDb = await db.rawQuery(
          'SELECT * FROM strokes WHERE kanjiCharacter = ? ',
          [kanjiFromApi.kanjiCharacter]);

      final parametersDelete = ParametersDelete(
          listKanjiMapFromDb: listKanjiMapFromDb,
          listMapExamplesFromDb: listMapExamplesFromDb,
          listMapStrokesImagesLisnkFromDb: listMapStrokesImagesLisnkFromDb);

      await compute(deleteKanjiFromApiComputeVersion, parametersDelete);

      await db.rawDelete('DELETE FROM kanji_FromApi WHERE kanjiCharacter = ?',
          [kanjiFromApi.kanjiCharacter]);
      await db.rawDelete('DELETE FROM examples WHERE kanjiCharacter = ?',
          [kanjiFromApi.kanjiCharacter]);
      await db.rawDelete('DELETE FROM strokes WHERE kanjiCharacter = ?',
          [kanjiFromApi.kanjiCharacter]);

      ref.read(statusStorageProvider.notifier).deleteItem(kanjiFromApi);

      onSuccess(List<KanjiFromApi> list) {
        ref.read(favoritesListProvider.notifier).updateKanji(list[0]);
        if (selection == 0) {
          ref.read(kanjiListProvider.notifier).updateKanji(list[0]);
        }
      }

      onError() {
        //TODO handle error connection online
        ref.read(favoritesListProvider.notifier).updateKanji(
            updateStatusKanjiComputeVersion(
                StatusStorage.errorDeleting, true, kanjiFromApi));
        if (selection == 0) {
          ref.read(kanjiListProvider.notifier).updateKanji(
              updateStatusKanjiComputeVersion(
                  StatusStorage.errorDeleting, true, kanjiFromApi));
        }
        ref.read(errorStoringDatabaseStatus.notifier).setError(true);
      }

      updateKanjiWithOnliVersionComputeVersion(
          kanjiFromApi, onSuccess, onError);

      logger.d('success');
    } catch (e) {
      ref.read(errorStoringDatabaseStatus.notifier).setError(true);

      logger.e('error sotoring');
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
