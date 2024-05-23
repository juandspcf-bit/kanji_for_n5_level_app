import 'package:kanji_for_n5_level_app/application_layer/auth_service/delete_user_exception.dart';
import 'package:kanji_for_n5_level_app/models/favorite.dart';
import 'package:kanji_for_n5_level_app/models/first_time_logged.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/models/progress_time_line_d_b_data.dart';
import 'package:kanji_for_n5_level_app/models/quiz_section_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_audio_example_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_flash_card_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_section_data.dart';

abstract class LocalDBService {
  Future<void> insertUserData(Map<String, Object> data);

  Future<List<Map<String, Object?>>> readUserData(String uuid);

  Future<void> insertToTheDeleteErrorQueue(
    String uuid,
    DeleteErrorUserCode deleteErrorUserCode,
  );

  Future<List<KanjiFromApi>> loadStoredKanjis(String uuid);

  Future<ImageDetailsLink> loadImageDetails(String kanjiCharacter, String uuid);

  Future<KanjiFromApi?> storeKanjiToLocalDatabase(
    KanjiFromApi kanjiFromApi,
    ImageDetailsLink imageMeaningData,
    String uuid,
  );

  Future<void> deleteKanjiFromLocalDatabase(
    KanjiFromApi kanjiFromApi,
    String uuid,
  );

  Future<void> deleteUserData(String uuid);

  Future<void> deleteUserQueue();

  Future<List<Favorite>> loadFavoritesDatabase(String uid);

  Future<SingleQuizSectionData> getKanjiQuizLastScore(
    int section,
    String uuid,
  );

  Future<void> setKanjiQuizLastScore({
    int section = -1,
    String uuid = '',
    int countCorrects = 0,
    int countIncorrect = 0,
    int countOmitted = 0,
  });

  Future<void> insertSingleQuizSectionData(
    int section,
    String uuid,
    int countCorrects,
    int countIncorrect,
    int countOmitted,
  );

  Future<SingleAudioExampleQuizData> getSingleAudioExampleQuizDataDB(
    String kanjiCharacter,
    int section,
    String uuid,
  );

  Future<int> setAudioExampleLastScore({
    String kanjiCharacter = '',
    int section = -1,
    String uuid = '',
    int countCorrects = 0,
    int countIncorrect = 0,
    int countOmitted = 0,
  });

  Future<int> insertAudioExampleScore(
    int section,
    String uuid,
    String kanjiCharacter,
    int countCorrects,
    int countIncorrect,
    int countOmitted,
  );

  Future<SingleQuizFlashCardData> getSingleFlashCardDataDB(
    String kanjiCharacter,
    int section,
    String uuid,
  );

  Future<int> insertSingleFlashCardDataDB(
    String kanjiCharacter,
    int section,
    String uuid,
    int countUnWatched,
  );

  Future<int> setSingleFlashCardDataDB(
    String kanjiCharacter,
    int section,
    String uuid,
    int countUnWatched,
  );

  Future<ProgressTimeLineDBData> getAllQuizSectionDBData(
    String uuid,
  );

  Future<QuizSectionData> getQuizSectionDataFromDB(
    String uuid,
    int section,
  );

  Future<void> cleanInvalidDBRecords(List<KanjiFromApi> listOfInvalidKanjis);

  Future<FirstTimeLogged> getAllFirstTimeLOggedDBData(
    String uuid,
  );

  Future<int> setAllFirstTimeLOggedDBData(
    String uuid,
  );

  Future<void> storeAllFavoritesFromCloud(List<Favorite> favorites);

  Future<void> updateQuizScoreFromCloud(
    Map<String, Object> quizScoreData,
    String uuid,
  );

  Future<List<Favorite>> loadFavorites(String uid);

  Future<Favorite> loadSingleFavorite(String kanjiCharacter, String uid);

  Future<int> insertFavorite(String kanji, int timeStamp);

  Future<int> deleteFavorite(String kanji);

  Future<void> storeAllFavorites(List<Favorite> favorites);
}
