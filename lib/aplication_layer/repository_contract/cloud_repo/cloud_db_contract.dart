import 'package:kanji_for_n5_level_app/models/favorite.dart';

abstract class CloudDBService {
  Future<List<Favorite>> loadFavoritesCloudDB(
    String uuid,
  );

  Future<void> insertFavoriteCloudDB(
    String kanjiCharacter,
    int timeStamp,
    String uuid,
  );

  Future<void> deleteFavoriteCloudDB(
    String kanjiCharacter,
    String uuid,
  );

  Future<void> addUserData(
    String email,
    String uuid,
  );

  Future<void> createQuizScoreMap(String uuid);

  Future<void> updateQuizSectionScore(
    bool allCorrectAnswersQuizKanji,
    bool isFinishedKanjiQuiz,
    int countCorrects,
    int countIncorrects,
    int countOmited,
    int section,
    String uuid,
  );

  Future<void> updateQuizDetailScore(
    String kanjiCharacter,
    bool allCorrectAnswers,
    bool isFinishedQuiz,
    int countCorrects,
    int countIncorrects,
    int countOmited,
    int section,
    String uuid,
  );

  Future<void> updateQuizFlashCardScore(
    String kanjiCharacter,
    bool allRevisedFlashCards,
    int section,
    String uuid,
  );

  Future<void> deleteQuizScoreData(
    String uuid,
  );

  Future<Map<String, Object>> loadQuizScoreData(String uuid);
}
