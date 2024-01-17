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
  Future<SingleQuizSectionData> getKanjiQuizLastScore(
      int section, String uuid) {
    return getSingleQuizSectionData(section, uuid);
  }

  @override
  void setKanjiQuizLastScore({
    int section = -1,
    String uuid = '',
    int countCorrects = 0,
    int countIncorrects = 0,
    int countOmited = 0,
  }) {
    updateSingleQuizSectionData(
      section,
      uuid,
      countIncorrects == 0 && countOmited == 0,
      true,
      countCorrects,
      countIncorrects,
      countOmited,
    );
  }

  @override
  void insertSingleQuizSectionData(
    int section,
    String uuid,
    int countCorrects,
    int countIncorrects,
    int countOmited,
  ) {
    insertSingleQuizSectionDataDB(
      section,
      uuid,
      countIncorrects == 0 && countOmited == 0,
      true,
      countCorrects,
      countIncorrects,
      countOmited,
    );
  }

  @override
  Future<SingleQuizSectionData> getSingleAudioExampleQuizDataDB(
      int section, String uuid) {
    return getSingleQuizSectionAudioExamplerData(section, uuid);
  }

  @override
  void insertAudioExampleScore(int section, String uuid, int countCorrects,
      int countIncorrects, int countOmited) {
/*     logger.d('uuid: $uuid, corrects: $countCorrects,'
        ' countIncorrects: $countIncorrects, countOmited: $countOmited'); */
    insertSingleAudioExampleQuizSectionDataDB(
      section,
      uuid,
      countIncorrects == 0 && countOmited == 0,
      true,
      countCorrects,
      countIncorrects,
      countOmited,
    );
  }

  @override
  void setAudioExampleLastScore(
      {int section = -1,
      String uuid = '',
      int countCorrects = 0,
      int countIncorrects = 0,
      int countOmited = 0}) {
/*     logger.d('uuid: $uuid, corrects: $countCorrects,'
        ' countIncorrects: $countIncorrects, countOmited: $countOmited'); */
    updateSingleAudioExampleQuizSectionData(
      section,
      uuid,
      countIncorrects == 0 && countOmited == 0,
      true,
      countCorrects,
      countIncorrects,
      countOmited,
    );
  }
}
