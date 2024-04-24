import 'package:kanji_for_n5_level_app/aplication_layer/repository_service/api_repo/kanji_api_service_contract.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/apis/kanji_alive/request_kanji_list_api.dart';

class AppAplicationApiService implements KanjiApiService {
  @override
  Future<List<KanjiFromApi>> requestKanjiListToApi(
    List<KanjiFromApi> storedKanjis,
    List<String> kanjisCharacteres,
    int section,
  ) async {
    return KanjiAliveApi.getKanjiList(
      storedKanjis,
      kanjisCharacteres,
      section,
    );
  }

  @override
  Future<KanjiFromApi> requestSingleKanjiToApi(
    String kanjiCharacter,
    int section,
  ) async {
    final kanjiList =
        await KanjiAliveApi.getKanjiList([], [kanjiCharacter], section);
    return kanjiList[0];
  }
}
