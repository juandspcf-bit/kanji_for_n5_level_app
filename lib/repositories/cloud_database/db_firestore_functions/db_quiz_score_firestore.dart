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
      'list_quiz_details_1': {
        'section_1': {},
        'section_2': {},
        'section_3': {},
        'section_4': {},
        'section_5': {},
        'section_6': {}
      },
      'list_quiz_flash_cards_1': {
        'section_1': {},
        'section_2': {},
        'section_3': {},
        'section_4': {},
        'section_5': {},
        'section_6': {}
      },
      'quizScore_2': {},
      'list_quiz_details_2': {
        'section_1': {},
        'section_2': {},
        'section_3': {},
        'section_4': {},
        'section_5': {},
        'section_6': {},
        'section_7': {},
        'section_8': {},
        'section_9': {},
        'section_10': {}
      },
      'list_quiz_flash_cards_2': {
        'section_1': {},
        'section_2': {},
        'section_3': {},
        'section_4': {},
        'section_5': {},
        'section_6': {},
        'section_7': {},
        'section_8': {},
        'section_9': {},
        'section_10': {}
      },
      'quizScore_3': {},
      'list_quiz_details_3': {
        'section_1': {},
        'section_2': {},
        'section_3': {},
        'section_4': {},
        'section_5': {},
        'section_6': {},
        'section_7': {},
        'section_8': {},
        'section_9': {},
        'section_10': {}
      },
      'list_quiz_flash_cards_3': {
        'section_1': {},
        'section_2': {},
        'section_3': {},
        'section_4': {},
        'section_5': {},
        'section_6': {},
        'section_7': {},
        'section_8': {},
        'section_9': {},
        'section_10': {}
      },
      'quizScore_4': {},
      'list_quiz_details_4': {
        'section_1': {},
        'section_2': {},
        'section_3': {},
        'section_4': {},
        'section_5': {},
        'section_6': {},
        'section_7': {},
        'section_8': {},
        'section_9': {},
        'section_10': {},
        'section_11': {},
        'section_12': {},
        'section_13': {}
      },
      'list_quiz_flash_cards_4': {
        'section_1': {},
        'section_2': {},
        'section_3': {},
        'section_4': {},
        'section_5': {},
        'section_6': {},
        'section_7': {},
        'section_8': {},
        'section_9': {},
        'section_10': {},
        'section_11': {},
        'section_12': {},
        'section_13': {}
      },
      'quizScore_5': {},
      'list_quiz_details_5': {
        'section_1': {},
        'section_2': {},
        'section_3': {},
        'section_4': {},
        'section_5': {},
        'section_6': {},
        'section_7': {},
        'section_8': {},
        'section_9': {},
        'section_10': {},
        'section_11': {},
        'section_12': {},
        'section_13': {}
      },
      'list_quiz_flash_cards_5': {
        'section_1': {},
        'section_2': {},
        'section_3': {},
        'section_4': {},
        'section_5': {},
        'section_6': {},
        'section_7': {},
        'section_8': {},
        'section_9': {},
        'section_10': {},
        'section_11': {},
        'section_12': {},
        'section_13': {}
      },
      'quizScore_6': {},
      'list_quiz_details_6': {
        'section_1': {},
        'section_2': {},
        'section_3': {},
        'section_4': {},
        'section_5': {},
        'section_6': {},
        'section_7': {},
        'section_8': {},
        'section_9': {},
        'section_10': {},
        'section_11': {},
        'section_12': {},
        'section_13': {}
      },
      'list_quiz_flash_cards_6': {
        'section_1': {},
        'section_2': {},
        'section_3': {},
        'section_4': {},
        'section_5': {},
        'section_6': {},
        'section_7': {},
        'section_8': {},
        'section_9': {},
        'section_10': {},
        'section_11': {},
        'section_12': {},
        'section_13': {}
      },
      'quizScore_7': {},
      'list_quiz_details_7': {
        'section_1': {},
        'section_2': {},
        'section_3': {},
        'section_4': {},
        'section_5': {},
        'section_6': {},
        'section_7': {},
        'section_8': {},
        'section_9': {},
        'section_10': {},
        'section_11': {},
        'section_12': {},
      },
      'list_quiz_flash_cards_7': {
        'section_1': {},
        'section_2': {},
        'section_3': {},
        'section_4': {},
        'section_5': {},
        'section_6': {},
        'section_7': {},
        'section_8': {},
        'section_9': {},
        'section_10': {},
        'section_11': {},
        'section_12': {},
      },
      'quizScore_8': {},
      'list_quiz_details_8': {
        'section_1': {},
        'section_2': {},
        'section_3': {},
        'section_4': {},
        'section_5': {},
        'section_6': {},
        'section_7': {},
        'section_8': {},
        'section_9': {},
        'section_10': {},
        'section_11': {},
        'section_12': {},
        'section_13': {},
        'section_14': {},
        'section_15': {},
        'section_16': {}
      },
      'list_quiz_flash_cards_8': {
        'section_1': {},
        'section_2': {},
        'section_3': {},
        'section_4': {},
        'section_5': {},
        'section_6': {},
        'section_7': {},
        'section_8': {},
        'section_9': {},
        'section_10': {},
        'section_11': {},
        'section_12': {},
        'section_13': {},
        'section_14': {},
        'section_15': {},
        'section_16': {}
      },
      'quizScore_9': {},
      'list_quiz_details_9': {
        'section_1': {},
        'section_2': {},
        'section_3': {},
        'section_4': {},
        'section_5': {},
        'section_6': {},
        'section_7': {},
        'section_8': {},
        'section_9': {},
        'section_10': {},
        'section_11': {},
        'section_12': {},
        'section_13': {},
        'section_14': {},
        'section_15': {},
        'section_16': {}
      },
      'list_quiz_flash_cards_9': {
        'section_1': {},
        'section_2': {},
        'section_3': {},
        'section_4': {},
        'section_5': {},
        'section_6': {},
        'section_7': {},
        'section_8': {},
        'section_9': {},
        'section_10': {},
        'section_11': {},
        'section_12': {},
        'section_13': {},
        'section_14': {},
        'section_15': {},
        'section_16': {}
      },
    },
  );
}
