import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/networking/request_api.dart';

class KanjiListProvider extends Notifier<(List<KanjiFromApi>, int, int)> {
  @override
  (List<KanjiFromApi>, int, int) build() {
    return ([], 0, 1);
  }

  void onSuccesRequest(List<KanjiFromApi> kanjisFromApi) {
    state = (kanjisFromApi, 1, kanjisFromApi.first.section);
  }

  void onErrorRequest() {
    state = ([], 2, state.$3);
  }

  void updateKanji(KanjiFromApi storedKanji) {
    final copyState = [...state.$1];

    try {
      final kanjiIndex = copyState.indexWhere(
          (element) => element.kanjiCharacter == storedKanji.kanjiCharacter);
      copyState[kanjiIndex] = storedKanji;
      state = (copyState, state.$2, state.$3);
    } on StateError catch (e) {
      e.message;
    }
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

  void clearKanjiList(int section) {
    state = ([], 0, section);
  }
}

final kanjiListProvider =
    NotifierProvider<KanjiListProvider, (List<KanjiFromApi>, int, int)>(
        KanjiListProvider.new);
