import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/repositories/apis/kanji_alive/request_kanji_list_api.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_deleting_data.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_inserting_data.dart';

abstract class ApplicationApiService {
  Future<List<KanjiFromApi>> requestKanjiListToApi(
    List<KanjiFromApi> storedKanjis,
    List<String> kanjisCharacteres,
    int section,
  );
}

abstract class ApplicationDBService {
  Future<KanjiFromApi?> storeKanjiToLocalDatabase(KanjiFromApi kanjiFromApi);
  Future<void> deleteKanjiFromLocalDatabase(KanjiFromApi kanjiFromApi);
}

class AppAplicationApiService implements ApplicationApiService {
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
}

class AppAplicationDBService implements ApplicationDBService {
  @override
  Future<KanjiFromApi?> storeKanjiToLocalDatabase(
      KanjiFromApi kanjiFromApi) async {
    return await storeKanjiToSqlDB(kanjiFromApi);
  }

  @override
  Future<void> deleteKanjiFromLocalDatabase(KanjiFromApi kanjiFromApi) async {
    return await deleteKanjiFromSqlDB(kanjiFromApi);
  }
}
