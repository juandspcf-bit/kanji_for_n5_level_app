import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/db_contract.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_delete_user.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_deleting_data.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_inserting_data.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_quiz_data_functions.dart';

final LocalDBService localDBService = SqliteDBService();

class SqliteDBService implements LocalDBService {
  @override
  Future<KanjiFromApi?> storeKanjiToLocalDatabase(
      KanjiFromApi kanjiFromApi) async {
    return await storeKanjiToSqlDB(kanjiFromApi);
  }

  @override
  Future<void> deleteKanjiFromLocalDatabase(KanjiFromApi kanjiFromApi) async {
    return await deleteKanjiFromSqlDB(kanjiFromApi);
  }

  @override
  Future<void> deleteUserData(String uuid) async {
    return await deleteUserDataFromSqlDB(uuid);
  }

  @override
  Future<(int, bool, bool)> getKanjiQuizLastScore(int section, String uuid) {
    return getSingleQuizSectionData(section, uuid);
  }
}
