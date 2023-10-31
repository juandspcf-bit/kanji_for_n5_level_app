import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/networking/request_api.dart';

class KanjiListProvider extends Notifier<(List<KanjiFromApi>, int)> {
  @override
  (List<KanjiFromApi>, int) build() {
    return ([], 0);
  }

  void onSuccesRequest(List<KanjiFromApi> kanjisFromApi) {
    state = (kanjisFromApi, 1);
  }

  void onErrorRequest() {
    state = ([], 2);
  }

  void updateKanji(KanjiFromApi storedKanji) {
    final copyState = [...state.$1];

    try {
      final kanjiIndex = copyState.indexWhere(
          (element) => element.kanjiCharacter == storedKanji.kanjiCharacter);
      copyState[kanjiIndex] = storedKanji;
      state = (copyState, state.$2);
    } on StateError catch (e) {
      e.message;
    }
  }

  void setKanjiList(
    List<KanjiFromApi> storedKanjis,
    List<String> kanjisCharacteres,
  ) {
    RequestApi.getKanjis(
      storedKanjis,
      kanjisCharacteres,
      onSuccesRequest,
      onErrorRequest,
    );
  }

  void clearKanjiList() {
    state = ([], 0);
  }
}

final kanjiListProvider =
    NotifierProvider<KanjiListProvider, (List<KanjiFromApi>, int)>(
        KanjiListProvider.new);
