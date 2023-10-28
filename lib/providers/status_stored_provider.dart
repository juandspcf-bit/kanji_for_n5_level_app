import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

class StatusStorageProvider extends Notifier<List<KanjiFromApi>> {
  @override
  List<KanjiFromApi> build() {
    return [];
  }

  void addSetItems(List<KanjiFromApi> items) {
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

  StatusStorage isInStorage(KanjiFromApi kanjiFromApi) {
    final copyState = [...state];
    final kanjiQuery = copyState.map((e) => e.kanjiCharacter).firstWhere(
        (element) => element == kanjiFromApi.kanjiCharacter,
        orElse: () => '');

    if (kanjiQuery != '') {
      return StatusStorage.stored;
    } else {
      return StatusStorage.onlyOnline;
    }
  }
}

final statusStorageProvider =
    NotifierProvider<StatusStorageProvider, List<KanjiFromApi>>(
        StatusStorageProvider.new);

enum StatusStorage { onlyOnline, stored, dowloading }
