import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

class StatusStorageProvider extends Notifier<Map<int, List<KanjiFromApi>>> {
  @override
  Map<int, List<KanjiFromApi>> build() {
    return {};
  }

  Map<int, List<KanjiFromApi>> getStoresItems() {
    return state;
  }

  void setInitialStoredKanjis(List<KanjiFromApi> items) {
    Map<int, List<KanjiFromApi>> copyState = {};

    for (var element in items) {
      var list = copyState[element.section];
      if (list == null) copyState[element.section] = [];
      copyState[element.section]!.add(element);
    }

    state = copyState;
  }

  void addItem(KanjiFromApi kanjiFromApi) {
    Map<int, List<KanjiFromApi>> copyState = Map.from(state);
    var list = copyState[kanjiFromApi.section];
    if (list == null) copyState[kanjiFromApi.section] = [];
    copyState[kanjiFromApi.section]!.add(kanjiFromApi);
    state = copyState;
  }

  void deleteItem(KanjiFromApi kanjiFromApi) {
    Map<int, List<KanjiFromApi>> copyStateMap = Map.from(state);

    if (copyStateMap[kanjiFromApi.section] == null) {
      copyStateMap[kanjiFromApi.section] = [];
    }
    var list = copyStateMap[kanjiFromApi.section];
    final copyState = [...list!];
    var copyState2 = [...list];
    bool isThere = false;

    for (int i = 0; i < copyState.length; i++) {
      isThere = kanjiFromApi.kanjiCharacter == copyState[i].kanjiCharacter;
      if (isThere) {
        copyState2.removeAt(i);
        break;
      }
    }

    copyStateMap[kanjiFromApi.section] = copyState2;
    state = copyStateMap;
  }

  (KanjiFromApi, StatusStorage) isInStorage(KanjiFromApi kanjiFromApi) {
    Map<int, List<KanjiFromApi>> copyStateMap = Map.from(state);
    if (copyStateMap[kanjiFromApi.section] == null) {
      copyStateMap[kanjiFromApi.section] = [];
    }
    final copyState = [...copyStateMap[kanjiFromApi.section]!];

    late KanjiFromApi kanjiQuery;

    StatusStorage inStorage;
    try {
      kanjiQuery = copyState.firstWhere(
          (element) => element.kanjiCharacter == kanjiFromApi.kanjiCharacter);
      inStorage = StatusStorage.stored;
    } on StateError catch (e) {
      e.message;
      kanjiQuery = kanjiFromApi;
      inStorage = StatusStorage.onlyOnline;
    }

    return (kanjiQuery, inStorage);
  }
}

final statusStorageProvider =
    NotifierProvider<StatusStorageProvider, Map<int, List<KanjiFromApi>>>(
        StatusStorageProvider.new);

enum StatusStorage { onlyOnline, stored, dowloading }
