import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

class StatusStorageProvider extends Notifier<List<KanjiFromApi>> {
  @override
  List<KanjiFromApi> build() {
    return [];
  }

  List<KanjiFromApi> getStoresItems() {
    return state;
  }

  void setInitialStoredKanjis(List<KanjiFromApi> items) {
    state = items;
  }

  void addItem(KanjiFromApi kanjiFromApi) {
    state = [...state, kanjiFromApi];
  }

  void deleteItem(KanjiFromApi kanjiFromApi) {
    final copyState = [...state];
    var copyState2 = [...state];
    bool isThere = false;

    for (int i = 0; i < copyState.length; i++) {
      isThere = kanjiFromApi.kanjiCharacter == copyState[i].kanjiCharacter;
      if (isThere) {
        copyState2.removeAt(i);
        break;
      }
    }

    state = copyState2;
  }

  (KanjiFromApi, StatusStorage) isInStorage(KanjiFromApi kanjiFromApi) {
    final copyState = [...state];

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

    print('my stored kanji is $kanjiFromApi, in storage ? : $inStorage');
    return (kanjiQuery, inStorage);
  }
}

final statusStorageProvider =
    NotifierProvider<StatusStorageProvider, List<KanjiFromApi>>(
        StatusStorageProvider.new);

enum StatusStorage { onlyOnline, stored, dowloading }
