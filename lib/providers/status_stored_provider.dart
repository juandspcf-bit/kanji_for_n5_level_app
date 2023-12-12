import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

class StoredkanjisProvider extends Notifier<Map<int, List<KanjiFromApi>>> {
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

    //copyState = orderElements(copyState);

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

  Map<int, List<KanjiFromApi>> orderElements(
      Map<int, List<KanjiFromApi>> copyState) {
    Map<int, List<KanjiFromApi>> orderedKanjisSections = {};
    copyState.forEach((key, value) {
      logger.d('the ordered kanjis are $key');
      final kanjisSection = sectionsKanjis['section$key']!;
      orderedKanjisSections[key] = [];
      for (var kanjiCharacter in kanjisSection) {
        int index = value
            .indexWhere((element) => element.kanjiCharacter == kanjiCharacter);
        if (index != -1) {
          orderedKanjisSections[key]!.add(value[index]);
        }
      }
    });

    return orderedKanjisSections;
  }
}

final storedKanjisProvider =
    NotifierProvider<StoredkanjisProvider, Map<int, List<KanjiFromApi>>>(
        StoredkanjisProvider.new);

enum StatusStorage {
  onlyOnline,
  stored,
  proccessingStoring,
  proccessingDeleting,
  disableForDownload,
  errorDeleting
}
