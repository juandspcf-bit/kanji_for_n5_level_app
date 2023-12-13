import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_deleting_data.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/repositories/apis/kanji_alive/request_kanji_list_api.dart';
import 'package:kanji_for_n5_level_app/providers/error_storing_database_status.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

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
    KanjiAliveApi.getKanjiList(
      storedKanjis,
      kanjisCharacteres,
      section,
      onSuccesRequest,
      onErrorRequest,
    );
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

  void getKanjiListFromRepositories(
    List<String> kanjisCharacteres,
    int section,
  ) {
    clearKanjiList(section);
    final storedKanjis =
        ref.read(storedKanjisProvider.notifier).getStoresItems();

    applicationApiService.requestKanjiListToApi(
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

  void insertKanjiToStorage(KanjiFromApi kanjiFromApi, int selection) async {
    try {
      final kanjiFromApiStored =
          await applicationDBService.storeKanjiToLocalDatabase(kanjiFromApi);

      if (kanjiFromApiStored == null) return;

      updateProviders(kanjiFromApiStored, selection);

      logger.i(kanjiFromApiStored);
      logger.d('success storing to db');
    } catch (e) {
      logger.e('error storing');
      logger.e(e.toString());
    }
  }

  void updateProviders(KanjiFromApi kanjiFromApiStored, int selection) {
    ref.read(storedKanjisProvider.notifier).addItem(kanjiFromApiStored);

    ref.read(favoritesListProvider.notifier).updateKanji(kanjiFromApiStored);

    if (selection == 0) {
      updateKanji(kanjiFromApiStored);
    }
  }

  void deleteKanjiFromStorage(
    KanjiFromApi kanjiFromApi,
    int selection,
  ) async {
    try {
      await applicationDBService.deleteKanjiFromLocalDatabase(kanjiFromApi);

      ref.read(storedKanjisProvider.notifier).deleteItem(kanjiFromApi);

      onSuccess(List<KanjiFromApi> list) {
        ref.read(favoritesListProvider.notifier).updateKanji(list[0]);
        if (selection == 0) {
          ref.read(kanjiListProvider.notifier).updateKanji(list[0]);
        }
        logger.d('success deleting from db');
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

      updateKanjiWithOnliVersion(
        kanjiFromApi,
        onSuccess,
        onError,
      );
    } catch (e) {
      ref.read(errorStoringDatabaseStatus.notifier).setError(true);

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
