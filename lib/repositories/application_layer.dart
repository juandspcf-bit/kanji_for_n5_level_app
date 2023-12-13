import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/repositories/apis/kanji_alive/request_kanji_list_api.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_deleting_data.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_inserting_data.dart';

abstract class ApplicationApiService {
  void requestKanjiListToApi(
    List<KanjiFromApi> storedKanjis,
    List<String> kanjisCharacteres,
    int section,
    void Function(List<KanjiFromApi> kanjisFromApi) onSuccesRequest,
    void Function() onErrorRequest,
  );
}

abstract class ApplicationDBService {
  Future<KanjiFromApi?> storeKanjiToLocalDatabase(KanjiFromApi kanjiFromApi);
  Future<void> deleteKanjiFromLocalDatabase(KanjiFromApi kanjiFromApi);
}

class AppAplicationApiService implements ApplicationApiService {
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
