import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';

class KanjisScectionsListProvider
    extends Notifier<Map<int, (List<KanjiFromApi>, int)>> {
  @override
  Map<int, (List<KanjiFromApi>, int)> build() {
    final Map<int, (List<KanjiFromApi>, int)> map = {};
    for (var i = 0; i < listSections.length; i++) {
      map[i] = ([], 0);
    }
    return map;
  }

  void setSectionKanjiList(int section, (List<KanjiFromApi>, int) listRecord) {
    final Map<int, (List<KanjiFromApi>, int)> copyState = Map.from(state);
    copyState[section] = listRecord;
    state = copyState;
  }

  (List<KanjiFromApi>, int) getKanjisFromSection(int section) {
    return state[section]!;
  }
}

final kanjisScectionsListProvider = NotifierProvider<
    KanjisScectionsListProvider,
    Map<int, (List<KanjiFromApi>, int)>>(KanjisScectionsListProvider.new);
