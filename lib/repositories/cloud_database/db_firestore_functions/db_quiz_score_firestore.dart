import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';

Future<void> setQuizSectionScore(
  bool allCorrectAnswersQuizkanji,
  bool isFinishedkanjiQuiz,
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
      'allCorrectAnswersQuizkanji': allCorrectAnswersQuizkanji,
      'isFinishedkanjiQuiz': isFinishedkanjiQuiz,
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
  final kanjiList = sectionsKanjis['section$section'];
  int indexMap = kanjiList!.indexOf(kanjiCharacter) + 1;
  await docRef.update({
    'list_quiz_details_$section.kanji_$indexMap': {
      'kanjiCharacter': kanjiCharacter,
      'allCorrectAnswers': allCorrectAnswers,
      'isFinishedQuiz': isFinishedQuiz,
      'countCorrects': countCorrects,
      'countIncorrects': countIncorrects,
      'countOmited': countOmited,
      'section': section,
    },
  });
}

Future<void> updateQuizFlashCardFire(
  String kanjiCharacter,
  bool allRevisedFlashCards,
  int section,
  String uuid,
) async {
  final docRef = dbFirebase.collection("quiz_score").doc(uuid);
  final kanjiList = sectionsKanjis['section$section'];
  int indexMap = kanjiList!.indexOf(kanjiCharacter) + 1;
  await docRef.update({
    'list_quiz_flash_cards_$section.kanji_$indexMap': {
      'kanjiCharacter': kanjiCharacter,
      'allRevisedFlashCards': allRevisedFlashCards,
      'section': section,
    },
  });
}

Future<void> deleteQuizScoreDataFire(
  String uuid,
) async {
  try {
    final docRef = dbFirebase.collection("quiz_score").doc(uuid);
    final docRefUserData = dbFirebase.collection("user_data").doc(uuid);
    await docRef.delete();
    await docRefUserData.delete();

    final docRefFavorites = await dbFirebase
        .collection("favorites")
        .where("uuid", isEqualTo: uuid)
        .get();

    //logger.d("Successfully completed");
    for (var docSnapshot in docRefFavorites.docs) {
      await docSnapshot.reference.delete();
    }
  } catch (e) {
    logger.e('erro deleting in cloud $e');
  }
}

Future<void> createQuizScoreMapCloud(String uuid) async {
  final docRef = dbFirebase.collection("quiz_score").doc(uuid);
  docRef.set(
    {
      'uuid': uuid,
      'quizScore_1': {},
      'list_quiz_details_1': {
        'kanji_1': {},
        'kanji_2': {},
        'kanji_3': {},
        'kanji_4': {},
        'kanji_5': {},
        'kanji_6': {}
      },
      'list_quiz_flash_cards_1': {
        'kanji_1': {},
        'kanji_2': {},
        'kanji_3': {},
        'kanji_4': {},
        'kanji_5': {},
        'kanji_6': {}
      },
      'quizScore_2': {},
      'list_quiz_details_2': {
        'kanji_1': {},
        'kanji_2': {},
        'kanji_3': {},
        'kanji_4': {},
        'kanji_5': {},
        'kanji_6': {},
        'kanji_7': {},
        'kanji_8': {},
        'kanji_9': {},
        'kanji_10': {},
      },
      'list_quiz_flash_cards_2': {
        'kanji_1': {},
        'kanji_2': {},
        'kanji_3': {},
        'kanji_4': {},
        'kanji_5': {},
        'kanji_6': {},
        'kanji_7': {},
        'kanji_8': {},
        'kanji_9': {},
        'kanji_10': {},
      },
      'quizScore_3': {},
      'list_quiz_details_3': {
        'kanji_1': {},
        'kanji_2': {},
        'kanji_3': {},
        'kanji_4': {},
        'kanji_5': {},
        'kanji_6': {},
        'kanji_7': {},
        'kanji_8': {},
        'kanji_9': {},
        'kanji_10': {},
      },
      'list_quiz_flash_cards_3': {
        'kanji_1': {},
        'kanji_2': {},
        'kanji_3': {},
        'kanji_4': {},
        'kanji_5': {},
        'kanji_6': {},
        'kanji_7': {},
        'kanji_8': {},
        'kanji_9': {},
        'kanji_10': {},
      },
      'quizScore_4': {},
      'list_quiz_details_4': {
        'kanji_1': {},
        'kanji_2': {},
        'kanji_3': {},
        'kanji_4': {},
        'kanji_5': {},
        'kanji_6': {},
        'kanji_7': {},
        'kanji_8': {},
        'kanji_9': {},
        'kanji_10': {},
        'kanji_11': {},
        'kanji_12': {},
        'kanji_13': {},
      },
      'list_quiz_flash_cards_4': {
        'kanji_1': {},
        'kanji_2': {},
        'kanji_3': {},
        'kanji_4': {},
        'kanji_5': {},
        'kanji_6': {},
        'kanji_7': {},
        'kanji_8': {},
        'kanji_9': {},
        'kanji_10': {},
        'kanji_11': {},
        'kanji_12': {},
        'kanji_13': {},
      },
      'quizScore_5': {},
      'list_quiz_details_5': {
        'kanji_1': {},
        'kanji_2': {},
        'kanji_3': {},
        'kanji_4': {},
        'kanji_5': {},
        'kanji_6': {},
        'kanji_7': {},
        'kanji_8': {},
        'kanji_9': {},
        'kanji_10': {},
        'kanji_11': {},
        'kanji_12': {},
        'kanji_13': {},
      },
      'list_quiz_flash_cards_5': {
        'kanji_1': {},
        'kanji_2': {},
        'kanji_3': {},
        'kanji_4': {},
        'kanji_5': {},
        'kanji_6': {},
        'kanji_7': {},
        'kanji_8': {},
        'kanji_9': {},
        'kanji_10': {},
        'kanji_11': {},
        'kanji_12': {},
        'kanji_13': {},
      },
      'quizScore_6': {},
      'list_quiz_details_6': {
        'kanji_1': {},
        'kanji_2': {},
        'kanji_3': {},
        'kanji_4': {},
        'kanji_5': {},
        'kanji_6': {},
        'kanji_7': {},
        'kanji_8': {},
        'kanji_9': {},
        'kanji_10': {},
        'kanji_11': {},
        'kanji_12': {},
        'kanji_13': {},
      },
      'list_quiz_flash_cards_6': {
        'kanji_1': {},
        'kanji_2': {},
        'kanji_3': {},
        'kanji_4': {},
        'kanji_5': {},
        'kanji_6': {},
        'kanji_7': {},
        'kanji_8': {},
        'kanji_9': {},
        'kanji_10': {},
        'kanji_11': {},
        'kanji_12': {},
        'kanji_13': {},
      },
      'quizScore_7': {},
      'list_quiz_details_7': {
        'kanji_1': {},
        'kanji_2': {},
        'kanji_3': {},
        'kanji_4': {},
        'kanji_5': {},
        'kanji_6': {},
        'kanji_7': {},
        'kanji_8': {},
        'kanji_9': {},
        'kanji_10': {},
        'kanji_11': {},
        'kanji_12': {},
      },
      'list_quiz_flash_cards_7': {
        'kanji_1': {},
        'kanji_2': {},
        'kanji_3': {},
        'kanji_4': {},
        'kanji_5': {},
        'kanji_6': {},
        'kanji_7': {},
        'kanji_8': {},
        'kanji_9': {},
        'kanji_10': {},
        'kanji_11': {},
        'kanji_12': {},
      },
      'quizScore_8': {},
      'list_quiz_details_8': {
        'kanji_1': {},
        'kanji_2': {},
        'kanji_3': {},
        'kanji_4': {},
        'kanji_5': {},
        'kanji_6': {},
        'kanji_7': {},
        'kanji_8': {},
        'kanji_9': {},
        'kanji_10': {},
        'kanji_11': {},
        'kanji_12': {},
        'kanji_13': {},
        'kanji_14': {},
        'kanji_15': {},
        'kanji_16': {}
      },
      'list_quiz_flash_cards_8': {
        'kanji_1': {},
        'kanji_2': {},
        'kanji_3': {},
        'kanji_4': {},
        'kanji_5': {},
        'kanji_6': {},
        'kanji_7': {},
        'kanji_8': {},
        'kanji_9': {},
        'kanji_10': {},
        'kanji_11': {},
        'kanji_12': {},
        'kanji_13': {},
        'kanji_14': {},
        'kanji_15': {},
        'kanji_16': {},
      },
      'quizScore_9': {},
      'list_quiz_details_9': {
        'kanji_1': {},
        'kanji_2': {},
        'kanji_3': {},
        'kanji_4': {},
        'kanji_5': {},
        'kanji_6': {},
        'kanji_7': {},
        'kanji_8': {},
        'kanji_9': {},
        'kanji_10': {},
        'kanji_11': {},
        'kanji_12': {},
        'kanji_13': {},
        'kanji_14': {},
        'kanji_15': {},
        'kanji_16': {},
      },
      'list_quiz_flash_cards_9': {
        'kanji_1': {},
        'kanji_2': {},
        'kanji_3': {},
        'kanji_4': {},
        'kanji_5': {},
        'kanji_6': {},
        'kanji_7': {},
        'kanji_8': {},
        'kanji_9': {},
        'kanji_10': {},
        'kanji_11': {},
        'kanji_12': {},
        'kanji_13': {},
        'kanji_14': {},
        'kanji_15': {},
        'kanji_16': {},
      },
    },
  );
}
