import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanji_for_n5_level_app/application_layer/auth_service/delete_user_exception.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/section_model.dart';

Future<Map<String, Object>> loadQuizScoreDataFire(
  String uuid,
  FirebaseFirestore dbFirebase,
) async {
  final docRef = dbFirebase.collection("quiz_score").doc(uuid);
  final documentSnapshot = await docRef.get();
  final data = documentSnapshot.data();

  if (data == null) return {};

  final sections = listSections.map((e) => e.sectionNumber.toString()).toList();

  final Map<String, Object> scoresFinal = {};
  for (var section in sections) {
    if (data['quizScore_$section']['isFinishedkanjiQuiz'] != null) {
      //logger.d('pass');
      //logger.d(data['quizScore_$section']);
      scoresFinal['quizScore_$section'] = {
        'allCorrectAnswersQuizKanji':
            data['quizScore_$section']['allCorrectAnswersQuizkanji'] as bool,
        'isFinishedKanjiQuiz':
            data['quizScore_$section']['isFinishedkanjiQuiz'] as bool,
        'countCorrects': data['quizScore_$section']['countCorrects'] as int,
        'countIncorrect': data['quizScore_$section']['countIncorrect'] as int,
        'countOmitted': data['quizScore_$section']['countOmitted'] as int,
        'section': data['quizScore_$section']['section'] as int,
      };
    }

    Map<String, Object> init = {};
    scoresFinal['list_quiz_details_$section'] = init;

    for (var i = 0; i < sectionsKanjis['section$section']!.length; i++) {
      final scoreFinalRef =
          scoresFinal['list_quiz_details_$section'] as Map<String, Object>;
      final dataFinalRef = data['list_quiz_details_$section']['kanji_${i + 1}'];

      if (dataFinalRef['isFinishedQuiz'] != null) {
        scoreFinalRef['kanji_${i + 1}'] = {
          'kanjiCharacter': dataFinalRef['kanjiCharacter'] as String,
          'allCorrectAnswers': dataFinalRef['allCorrectAnswers'] as bool,
          'isFinishedQuiz': dataFinalRef['isFinishedQuiz'] as bool,
          'countCorrects': dataFinalRef['countCorrects'] as int,
          'countIncorrect': dataFinalRef['countIncorrect'] as int,
          'countOmitted': dataFinalRef['countOmitted'] as int,
          'section': dataFinalRef['section'] as int,
        };
      }
    }

    if ((scoresFinal['list_quiz_details_$section'] as Map<String, Object>)
        .isEmpty) {
      scoresFinal.remove('list_quiz_details_$section');
    }

    Map<String, Object> initFlashCardData = {};
    scoresFinal['list_quiz_flash_cards_$section'] = initFlashCardData;

    for (var i = 0; i < sectionsKanjis['section$section']!.length; i++) {
      final scoreFinalRef =
          scoresFinal['list_quiz_flash_cards_$section'] as Map<String, Object>;
      final dataFinalRef =
          data['list_quiz_flash_cards_$section']['kanji_${i + 1}'];

      if (dataFinalRef['allRevisedFlashCards'] != null) {
        scoreFinalRef['kanji_${i + 1}'] = {
          'kanjiCharacter': dataFinalRef['kanjiCharacter'] as String,
          'allRevisedFlashCards': dataFinalRef['allRevisedFlashCards'] as bool,
          'section': dataFinalRef['section'] as int,
        };
      }
    }

    if ((scoresFinal['list_quiz_flash_cards_$section'] as Map<String, Object>)
        .isEmpty) {
      scoresFinal.remove('list_quiz_flash_cards_$section');
    }
  }

  //logger.d(scoresFinal);
  return scoresFinal;
}

Future<void> setQuizSectionScore(
  bool allCorrectAnswersQuizkanji,
  bool isFinishedkanjiQuiz,
  int countCorrects,
  int countIncorrect,
  int countOmitted,
  int section,
  String uuid,
  FirebaseFirestore dbFirebase,
) async {
  final docRef = dbFirebase.collection("quiz_score").doc(uuid);
  logger.d('reference quizScore_$section');
  await docRef.update({
    'quizScore_$section': {
      'allCorrectAnswersQuizkanji': allCorrectAnswersQuizkanji,
      'isFinishedkanjiQuiz': isFinishedkanjiQuiz,
      'countCorrects': countCorrects,
      'countIncorrect': countIncorrect,
      'countOmitted': countOmitted,
      'section': section,
    }
  });
}

Future<void> updateQuizDetailScoreFire(
  String kanjiCharacter,
  bool allCorrectAnswers,
  bool isFinishedQuiz,
  int countCorrects,
  int countIncorrect,
  int countOmitted,
  int section,
  String uuid,
  FirebaseFirestore dbFirebase,
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
      'countIncorrect': countIncorrect,
      'countOmitted': countOmitted,
      'section': section,
    },
  });
}

Future<void> updateQuizFlashCardFire(
  String kanjiCharacter,
  bool allRevisedFlashCards,
  int section,
  String uuid,
  FirebaseFirestore dbFirebase,
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
  FirebaseFirestore dbFirebase,
) async {
  try {
    final docRef = dbFirebase.collection("quiz_score").doc(uuid);
    await docRef.delete();
  } on FirebaseException catch (e) {
    throw DeleteUserException(
      message: e.code,
      deleteErrorUserCode: DeleteErrorUserCode.deleteErrorQuizData,
    );
  } catch (e) {
    throw DeleteUserException(
      message: 'error deleting quiz user data in cloud db',
      deleteErrorUserCode: DeleteErrorUserCode.deleteErrorQuizData,
    );
  }
}

Future<void> createQuizScoreMapCloud(
  String uuid,
  FirebaseFirestore dbFirebase,
) async {
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
