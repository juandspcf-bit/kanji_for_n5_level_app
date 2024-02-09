import 'package:kanji_for_n5_level_app/models/favorite.dart';
import 'package:kanji_for_n5_level_app/models/first_time_logged.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/models/progress_time_line_d_b_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_audio_example_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_flash_card_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_section_data.dart';

abstract class LocalDBService {
  Future<KanjiFromApi?> storeKanjiToLocalDatabase(
    KanjiFromApi kanjiFromApi,
  );
  Future<void> deleteKanjiFromLocalDatabase(
    KanjiFromApi kanjiFromApi,
  );
  Future<void> deleteUserData(
    String uuid,
  );

  Future<List<Favorite>> loadFavoritesDatabase(String uid);

  Future<SingleQuizSectionData> getKanjiQuizLastScore(
    int section,
    String uuid,
  );

  void setKanjiQuizLastScore({
    int section = -1,
    String uuid = '',
    int countCorrects = 0,
    int countIncorrects = 0,
    int countOmited = 0,
  });

  void insertSingleQuizSectionData(
    int section,
    String uuid,
    int countCorrects,
    int countIncorrects,
    int countOmited,
  );

  Future<SingleQuizAudioExampleData> getSingleAudioExampleQuizDataDB(
    String kanjiCharacter,
    int section,
    String uuid,
  );

  Future<int> setAudioExampleLastScore({
    String kanjiCharacter = '',
    int section = -1,
    String uuid = '',
    int countCorrects = 0,
    int countIncorrects = 0,
    int countOmited = 0,
  });

  Future<int> insertAudioExampleScore(
    int section,
    String uuid,
    String kanjiCharacter,
    int countCorrects,
    int countIncorrects,
    int countOmited,
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

  Future<void> cleanInvalidDBRecords(List<KanjiFromApi> listOfInvalidKanjis);

  Future<FirtsTimeLogged> getAllFirtsTimeLOggedDBData(
    String uuid,
  );

  Future<int> setAllFirtsTimeLOggedDBData(
    String uuid,
  );

  Future<void> storeAllFavoritesFromCloud(List<Favorite> favorites);

  Future<void> storeQuizScoreFromCloud(
      Map<String, Object> quizScoreData, String uuid);

  Future<void> updateQuizScoreFromCloud(
      Map<String, Object> quizScoreData, String uuid);
}
