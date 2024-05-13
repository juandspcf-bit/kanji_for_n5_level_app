import 'package:kanji_for_n5_level_app/application_layer/repository_service/api_repo/kanji_api_service_contract.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/apis/kanji_alive/request_kanji_list_api.dart';

class AppApplicationApiService implements KanjiApiService {
  @override
  Future<List<KanjiFromApi>> requestKanjiListToApi(
      List<KanjiFromApi> storedKanjis,
      List<String> kanjisCharacters,
      int section,
      String uuid) async {
    return KanjiAliveApi.getKanjiList(
      storedKanjis,
      kanjisCharacters,
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
