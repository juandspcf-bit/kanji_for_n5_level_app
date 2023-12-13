import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/repositories/apis/kanji_alive/request_kanji_list_api.dart';

abstract class ApplicationLayer {
  void requestKanjiListToApi(
    List<KanjiFromApi> storedKanjis,
    List<String> kanjisCharacteres,
    int section,
    void Function(List<KanjiFromApi> kanjisFromApi) onSuccesRequest,
    void Function() onErrorRequest,
  );
}

class AppAplicationLayer implements ApplicationLayer {
  @override
  void requestKanjiListToApi(
    List<KanjiFromApi> storedKanjis,
    List<String> kanjisCharacteres,
    int section,
    void Function(List<KanjiFromApi> kanjisFromApi) onSuccesRequest,
    void Function() onErrorRequest,
  ) {
    KanjiAliveApi.getKanjiList(
      storedKanjis,
      kanjisCharacteres,
      section,
      onSuccesRequest,
      onErrorRequest,
    );
  }
}
