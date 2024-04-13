import 'package:kanji_for_n5_level_app/aplication_layer/repository_service/cloud_repo/cloud_db_contract.dart';
import 'package:kanji_for_n5_level_app/models/favorite.dart';
import 'package:kanji_for_n5_level_app/models/user.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/cloud_database/db_firestore_functions/db_favorites_firestore.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/cloud_database/db_firestore_functions/db_quiz_score_firestore.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/cloud_database/db_firestore_functions/db_user_data_firestore.dart';

class FireStoreDBService extends CloudDBService {
  @override
  Future<void> insertFavoriteCloudDB(
    String kanjiCharacter,
    int timeStamp,
    String uuid,
  ) {
    return insertFavorite(kanjiCharacter, timeStamp, uuid);
  }

  @override
  Future<void> deleteFavoriteCloudDB(String kanjiCharacter, String uuid) {
    return deleteFavorite(
      kanjiCharacter,
      uuid,
    );
  }

  @override
  Future<void> deleteAllFavoritesCloudDB(String uuid) {
    return deleteAllFavorites(
      uuid,
    );
  }

  @override
  Future<List<Favorite>> loadFavoritesCloudDB(
    String uuid,
  ) {
    return loadFavoriteKanjis(uuid);
  }

  @override
  Future<void> addUserData(Map<String, String> userData) {
    return insertUserDataFirebase(userData);
  }

  @override
  Future<UserData> readUserData(String uuid) async {
    return await readUserDataFirebase(uuid);
  }

  @override
  Future<void> updateUserData(
    String uuid,
    Map<String, String> newData,
  ) async {
    return updateUserDataFirebase(uuid, newData);
  }

  @override
  Future<void> deleteUserData(String uuid) async {
    return await deleteUserDataFirebase(uuid);
  }

  @override
  Future<void> updateQuizSectionScore(
    bool allCorrectAnswersQuizKanji,
    bool isFinishedKanjiQuiz,
    int countCorrects,
    int countIncorrects,
    int countOmited,
    int section,
    String uuid,
  ) {
    return setQuizSectionScore(
      allCorrectAnswersQuizKanji,
      isFinishedKanjiQuiz,
      countCorrects,
      countIncorrects,
      countOmited,
      section,
      uuid,
    );
  }

  @override
  Future<void> createQuizScoreMap(String uuid) {
    return createQuizScoreMapCloud(uuid);
  }

  @override
  Future<void> updateQuizDetailScore(
    String kanjiCharacter,
    bool allCorrectAnswers,
    bool isFinishedQuiz,
    int countCorrects,
    int countIncorrects,
    int countOmited,
    int section,
    String uuid,
  ) {
    return updateQuizDetailScoreFire(
      kanjiCharacter,
      allCorrectAnswers,
      isFinishedQuiz,
      countCorrects,
      countIncorrects,
      countOmited,
      section,
      uuid,
    );
  }

  @override
  Future<void> updateQuizFlashCardScore(
    String kanjiCharacter,
    bool allRevisedFlashCards,
    int section,
    String uuid,
  ) {
    return updateQuizFlashCardFire(
      kanjiCharacter,
      allRevisedFlashCards,
      section,
      uuid,
    );
  }

  @override
  Future<void> deleteQuizScoreData(String uuid) {
    return deleteQuizScoreDataFire(
      uuid,
    );
  }

  @override
  Future<Map<String, Object>> loadQuizScoreData(String uuid) {
    return loadQuizScoreDataFire(uuid);
  }
}
