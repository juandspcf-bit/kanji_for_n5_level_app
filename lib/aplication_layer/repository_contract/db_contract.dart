import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

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

  Future<SingleQuizAusioExampleData> getSingleAudioExampleQuizDataDB(
    String kanjiCharacter,
    int section,
    String uuid,
  );

  void setAudioExampleLastScore({
    String kanjiCharacter = '',
    int section = -1,
    String uuid = '',
    int countCorrects = 0,
    int countIncorrects = 0,
    int countOmited = 0,
  });

  void insertAudioExampleScore(
    int section,
    String uuid,
    String kanjiCharacter,
    int countCorrects,
    int countIncorrects,
    int countOmited,
  );
}

class SingleQuizSectionData {
  final int section;
  final bool allCorrectAnswers;
  final bool isFinishedQuiz;
  final int countCorrects;
  final int countIncorrects;
  final int countOmited;

  SingleQuizSectionData({
    required this.section,
    required this.allCorrectAnswers,
    required this.isFinishedQuiz,
    required this.countCorrects,
    required this.countIncorrects,
    required this.countOmited,
  });
}

class SingleQuizAusioExampleData {
  final String kanjiCharacter;
  final int section;
  final bool allCorrectAnswers;
  final bool isFinishedQuiz;
  final int countCorrects;
  final int countIncorrects;
  final int countOmited;

  SingleQuizAusioExampleData({
    required this.kanjiCharacter,
    required this.section,
    required this.allCorrectAnswers,
    required this.isFinishedQuiz,
    required this.countCorrects,
    required this.countIncorrects,
    required this.countOmited,
  });
}
