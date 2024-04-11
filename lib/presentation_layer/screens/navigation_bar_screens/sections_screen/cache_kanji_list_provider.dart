import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

class CacheKanjiList extends Notifier<Map<int, List<KanjiFromApi>>> {
  @override
  Map<int, List<KanjiFromApi>> build() {
    return {};
  }

  int currentIndex = 0;

  void addToCache(List<KanjiFromApi> listKanjiFromApi) {
    state[currentIndex % 3] = listKanjiFromApi;
    currentIndex++;
    currentIndex = currentIndex % 3;
  }

  bool isInCache(int section) {
    final list = state.entries
        .where((element) => element.value.first.section == section);
    return list.isNotEmpty;
  }

  void updateKanjiOnCache(
    KanjiFromApi kanjiFromApi,
  ) {
    final list = state.entries
        .where((element) => element.value.first.section == kanjiFromApi.section)
        .toList();
    if (list.isEmpty) return;
    final index = list.first.value.indexWhere(
        (element) => element.kanjiCharacter == kanjiFromApi.kanjiCharacter);
    list.first.value[index] = kanjiFromApi;
    state[list.first.key] = list.first.value;
  }

  void updateListOnCache(
    List<KanjiFromApi> kanjiFromApiList,
  ) {
    var list = state.entries
        .where((element) =>
            element.value.first.section == kanjiFromApiList.first.section)
        .toList();
    if (list.isEmpty) return;

    state[list.first.key] = kanjiFromApiList;
  }

  List<KanjiFromApi> getFromCache(int section) {
    return state.entries
        .where((element) => element.value.first.section == section)
        .first
        .value;
  }
}

final cacheKanjiListProvider =
    NotifierProvider<CacheKanjiList, Map<int, List<KanjiFromApi>>>(
        CacheKanjiList.new);
