import 'package:kanji_for_n5_level_app/application_layer/auth_service/delete_user_exception.dart';
import 'package:kanji_for_n5_level_app/application_layer/repository_service/local_repo/local_db_service_contract.dart';
import 'package:kanji_for_n5_level_app/models/favorite.dart';
import 'package:kanji_for_n5_level_app/models/first_time_logged.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/models/progress_time_line_d_b_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_audio_example_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_flash_card_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_section_data.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_delete_user.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_deleting_data.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_favorites.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_first_time_logged_functions.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_inserting_data.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_loading_data.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_quiz_data_functions/db_quiz_data_functions.dart';

class SQLiteDBService implements LocalDBService {
  @override
  Future<void> insertUserData(Map<String, Object> data) async {
    await insertUserDataToSQLite(data);
  }

  @override
  Future<List<Map<String, Object?>>> readUserData(String uuid) async {
    return readUserDataFromSQLite(uuid);
  }

  @override
  Future<void> insertToTheDeleteErrorQueue(
    String uuid,
    DeleteErrorUserCode deleteErrorUserCode,
  ) async {
    await insertToTheDeleteErrorQueueSQLite(uuid, deleteErrorUserCode);
  }

  @override
  Future<KanjiFromApi?> storeKanjiToLocalDatabase(
    KanjiFromApi kanjiFromApi,
    ImageDetailsLink imageMeaningData,
    String uuid,
  ) async {
    return await storeKanjiToSQLite(
      kanjiFromApi,
      imageMeaningData,
      uuid,
    );
  }

  @override
  Future<void> deleteKanjiFromLocalDatabase(
    KanjiFromApi kanjiFromApi,
    String uuid,
  ) async {
    return await deleteKanjiFromSqlDB(
      kanjiFromApi,
      uuid,
    );
  }

  @override
  Future<void> deleteUserData(String uuid) async {
    return await deleteUserDataSQLite(uuid);
  }

  @override
  Future<void> deleteUserQueue() async {
    return await deleteUserQueueSQLite();
  }

  @override
  Future<SingleQuizSectionData> getKanjiQuizLastScore(
      int section, String uuid) {
    return getSingleQuizSectionData(section, uuid);
  }

  @override
  Future<void> setKanjiQuizLastScore({
    int section = -1,
    String uuid = '',
    int countCorrects = 0,
    int countIncorrect = 0,
    int countOmitted = 0,
  }) async {
    await updateSingleQuizSectionData(
      section,
      uuid,
      countIncorrect == 0 && countOmitted == 0,
      true,
      countCorrects,
      countIncorrect,
      countOmitted,
    );
  }

  @override
  Future<void> insertSingleQuizSectionData(
    int section,
    String uuid,
    int countCorrects,
    int countIncorrect,
    int countOmitted,
  ) async {
    await insertSingleQuizSectionDataDB(
      section,
      uuid,
      countIncorrect == 0 && countOmitted == 0,
      true,
      countCorrects,
      countIncorrect,
      countOmitted,
    );
  }

  @override
  Future<SingleQuizAudioExampleData> getSingleAudioExampleQuizDataDB(
    String kanjiCharacter,
    int section,
    String uuid,
  ) {
    return getSingleQuizSectionAudioExampleData(
      kanjiCharacter,
      section,
      uuid,
    );
  }

  @override
  Future<int> insertAudioExampleScore(
      int section,
      String uuid,
      String kanjiCharacter,
      int countCorrects,
      int countIncorrect,
      int countOmitted) {
    return insertSingleAudioExampleQuizSectionDataDB(
      section,
      uuid,
      kanjiCharacter,
      countIncorrect == 0 && countOmitted == 0,
      true,
      countCorrects,
      countIncorrect,
      countOmitted,
    );
  }

  @override
  Future<int> setAudioExampleLastScore(
      {String kanjiCharacter = '',
      int section = -1,
      String uuid = '',
      int countCorrects = 0,
      int countIncorrect = 0,
      int countOmitted = 0}) {
    return updateSingleAudioExampleQuizSectionData(
      kanjiCharacter,
      section,
      uuid,
      countIncorrect == 0 && countOmitted == 0,
      true,
      countCorrects,
      countIncorrect,
      countOmitted,
    );
  }

  @override
  Future<SingleQuizFlashCardData> getSingleFlashCardDataDB(
    String kanjiCharacter,
    int section,
    String uuid,
  ) {
    return getSingleFlashCardData(
      kanjiCharacter,
      section,
      uuid,
    );
  }

  @override
  Future<int> insertSingleFlashCardDataDB(
    String kanjiCharacter,
    int section,
    String uuid,
    int countUnWatched,
  ) {
    return insertSingleFlashCardData(
      kanjiCharacter,
      section,
      uuid,
      countUnWatched == 0,
    );
  }

  @override
  Future<int> setSingleFlashCardDataDB(
    String kanjiCharacter,
    int section,
    String uuid,
    int countUnWatched,
  ) {
    return updateSingleFlashCardData(
      kanjiCharacter,
      section,
      uuid,
      countUnWatched == 0,
    );
  }

  @override
  Future<ProgressTimeLineDBData> getAllQuizSectionDBData(
    String uuid,
  ) async {
    return getAllQuizSectionData(
      uuid,
    );
  }

  @override
  Future<void> getQuizSectionDataFromDB(
    String kanjiCharacter,
    int section,
  ) {
    // TODO: implement getQuizSectionDataFromDB
    throw UnimplementedError();
  }

  @override
  Future<void> cleanInvalidDBRecords(List<KanjiFromApi> listOfInvalidKanjis) {
    return cleanInvalidRecords(listOfInvalidKanjis);
  }

  @override
  Future<List<Favorite>> loadFavoritesDatabase(String uid) {
    return loadFavorites(uid);
  }

  @override
  Future<FirstTimeLogged> getAllFirstTimeLOggedDBData(String uuid) {
    return loadFirstTimeLoggedData(uuid);
  }

  @override
  Future<int> setAllFirstTimeLOggedDBData(String uuid) {
    return insertFirstTimeLogged(uuid);
  }

  @override
  Future<void> storeAllFavoritesFromCloud(List<Favorite> favorites) {
    return storeAllFavorites(favorites);
  }

  @override
  Future<void> updateQuizScoreFromCloud(
      Map<String, Object> quizScoreData, String uuid) {
    return updateQuizScore(quizScoreData, uuid);
  }

  @override
  Future<List<KanjiFromApi>> loadStoredKanjis(String uuid) async {
    return loadStoredKanjisFromSQLiteDB(uuid);
  }

  @override
  Future<ImageDetailsLink> loadImageDetails(
    String kanjiCharacter,
    String uuid,
  ) async {
    return await loadImageDetailsFromSQLiteDB(
      kanjiCharacter,
      uuid,
    );
  }

  @override
  Future<int> deleteFavorite(String kanji) {
    return deleteFavoriteFirebase(kanji);
  }

  @override
  Future<int> insertFavorite(String kanji, int timeStamp) {
    return insertFavoriteFirebase(kanji, timeStamp);
  }

  @override
  Future<List<Favorite>> loadFavorites(String uid) {
    return loadFavoritesFirebase(uid);
  }

  @override
  Future<Favorite> loadSingleFavorite(String kanjiCharacter, String uid) {
    return loadSingleFavoriteFirebase(kanjiCharacter, uid);
  }

  @override
  Future<void> storeAllFavorites(List<Favorite> favorites) {
    return storeAllFavoritesFirebase(favorites);
  }
}
