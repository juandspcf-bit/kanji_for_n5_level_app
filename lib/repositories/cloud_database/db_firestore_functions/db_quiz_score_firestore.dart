import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanji_for_n5_level_app/main.dart';

Future<void> setQuizSectionScore(
  bool allCorrectAnswersQuizKanji,
  bool isFinishedKanjiQuiz,
  int countCorrects,
  int countIncorrects,
  int countOmited,
  int section,
  String uuid,
) async {
  final docRef = dbFirebase.collection("quiz_score").doc(uuid);
  logger.d('reference quizScore_$section');
  await docRef.update({
    'quizScore_$section': {
      'allCorrectAnswersQuizKanji': allCorrectAnswersQuizKanji,
      'isFinishedKanjiQuiz': isFinishedKanjiQuiz,
      'countCorrects': countCorrects,
      'countIncorrects': countIncorrects,
      'countOmited': countOmited,
      'section': section,
    }
  });
}

Future<void> updateQuizDetailScoreFire(
  String kanjiCharacter,
  bool allCorrectAnswers,
  bool isFinishedQuiz,
  int countCorrects,
  int countIncorrects,
  int countOmited,
  int section,
  String uuid,
) async {
  final docRef = dbFirebase.collection("quiz_score").doc(uuid);
  await docRef.update({
    'list_quiz_details_$section': FieldValue.arrayUnion([
      {
        'kanjiCharacter': kanjiCharacter,
        'allCorrectAnswers': allCorrectAnswers,
        'isFinishedQuiz': isFinishedQuiz,
        'countCorrects': countCorrects,
        'countIncorrects': countIncorrects,
        'countOmited': countOmited,
        'section': section,
      }
    ]),
  });
}

Future<void> insertQuizSectionScoreFire(
  bool allCorrectAnswersQuizKanji,
  bool isFinishedKanjiQuiz,
  int countCorrects,
  int countIncorrects,
  int countOmited,
  int section,
  String uuid,
) async {
  final docRef = dbFirebase.collection("quiz_score").doc(uuid);
  docRef.set({
    'quizScore_$section': {
      'allCorrectAnswersQuizKanji': allCorrectAnswersQuizKanji,
      'isFinishedKanjiQuiz': isFinishedKanjiQuiz,
      'countCorrects': countCorrects,
      'countIncorrects': countIncorrects,
      'countOmited': countOmited,
      'section': section,
    }
  });
}

Future<void> createQuizScoreMapCloud(String uuid) async {
  final docRef = dbFirebase.collection("quiz_score").doc(uuid);
  docRef.set(
    {
      'uuid': uuid,
      'quizScore_1': {},
      'list_quiz_details_1': [],
      'list_quiz_flash_cards_1': [],
      'quizScore_2': {},
      'list_quiz_details_2': [],
      'list_quiz_flash_cards_2': [],
      'quizScore_3': {},
      'list_quiz_details_3': [],
      'list_quiz_flash_cards_3': [],
      'quizScore_4': {},
      'list_quiz_details_4': [],
      'list_quiz_flash_cards_4': [],
      'quizScore_5': {},
      'list_quiz_details_5': [],
      'list_quiz_flash_cards_5': [],
      'quizScore_6': {},
      'list_quiz_details_6': [],
      'list_quiz_flash_cards_6': [],
      'quizScore_7': {},
      'list_quiz_details_7': [],
      'list_quiz_flash_cards_7': [],
      'quizScore_8': {},
      'list_quiz_details_8': [],
      'list_quiz_flash_cards_8': [],
      'quizScore_9': {},
      'list_quiz_details_9': [],
      'list_quiz_flash_cards_9': [],
    },
  );
}
