import 'package:kanji_for_n5_level_app/aplication_layer/repository_service/api_repo/kanji_api_service_contract.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/apis/kanji_alive/request_kanji_list_api.dart';

class AppAplicationApiService implements KanjiApiService {
  @override
  Future<List<KanjiFromApi>> requestKanjiListToApi(
      List<KanjiFromApi> storedKanjis,
      List<String> kanjisCharacteres,
      int section,
      String uuid) async {
    return KanjiAliveApi.getKanjiList(
      storedKanjis,
      kanjisCharacteres,
      section,
      uuid,
    );
  }

  @override
  Future<KanjiFromApi> requestSingleKanjiToApi(
    String kanjiCharacter,
    int section,
    String uuid,
  ) async {
    final kanjiList = await KanjiAliveApi.getKanjiList(
      [],
      [kanjiCharacter],
      section,
      uuid,
    );
    return kanjiList[0];
  }
}
