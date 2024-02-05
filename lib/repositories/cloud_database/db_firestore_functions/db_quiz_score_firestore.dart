import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';

Future<Map<String, Object?>> loadQuizScoreData(String uuid) async {
  final docRef = dbFirebase.collection("quiz_score").doc(uuid);
  final documentSnapshot = await docRef.get();
  final data = documentSnapshot.data();

  if (data == null) return {};

  final sections = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

  final Map<String, Object> scoresFinal = {};
  for (var section in sections) {
    scoresFinal['quizScore_$section'] = {
      data['quizScore_$section']['allCorrectAnswersQuizKanji'] as bool,
      data['quizScore_$section']['isFinishedKanjiQuizz'] as bool,
      data['quizScore_$section']['countCorrects'] as int,
      data['quizScore_$section']['countIncorrects'] as int,
      data['quizScore_$section']['countOmited'] as int,
      data['quizScore_$section']['section'] as int,
      data['quizScore_$section']['uuid'] as String,
    };
  }

  final scores = {
    'uuid': uuid,
    'quizScore_1': {
      data['quizScore_1']['allCorrectAnswersQuizKanji'] as bool,
      data['quizScore_1']['isFinishedKanjiQuizz'] as bool,
      data['quizScore_1']['countCorrects'] as int,
      data['quizScore_1']['countIncorrects'] as int,
      data['quizScore_1']['countOmited'] as int,
      data['quizScore_1']['section'] as int,
      data['quizScore_1']['uuid'] as String,
    },
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
    'quizScore_2': {
      data['quizScore_2']['allCorrectAnswersQuizKanji'] as bool,
      data['quizScore_2']['isFinishedKanjiQuizz'] as bool,
      data['quizScore_2']['countCorrects'] as int,
      data['quizScore_2']['countIncorrects'] as int,
      data['quizScore_2']['countOmited'] as int,
      data['quizScore_2']['section'] as int,
      data['quizScore_2']['uuid'] as String,
    },
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
    'quizScore_3': {
      data['quizScore_3']['allCorrectAnswersQuizKanji'] as bool,
      data['quizScore_3']['isFinishedKanjiQuizz'] as bool,
      data['quizScore_3']['countCorrects'] as int,
      data['quizScore_3']['countIncorrects'] as int,
      data['quizScore_3']['countOmited'] as int,
      data['quizScore_3']['section'] as int,
      data['quizScore_3']['uuid'] as String,
    },
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
    'quizScore_4': {
      data['quizScore_4']['allCorrectAnswersQuizKanji'] as bool,
      data['quizScore_4']['isFinishedKanjiQuizz'] as bool,
      data['quizScore_4']['countCorrects'] as int,
      data['quizScore_4']['countIncorrects'] as int,
      data['quizScore_4']['countOmited'] as int,
      data['quizScore_4']['section'] as int,
      data['quizScore_4']['uuid'] as String,
    },
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
    'quizScore_5': {
      data['quizScore_5']['allCorrectAnswersQuizKanji'] as bool,
      data['quizScore_5']['isFinishedKanjiQuizz'] as bool,
      data['quizScore_5']['countCorrects'] as int,
      data['quizScore_5']['countIncorrects'] as int,
      data['quizScore_5']['countOmited'] as int,
      data['quizScore_5']['section'] as int,
      data['quizScore_5']['uuid'] as String,
    },
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
    'quizScore_6': {
      data['quizScore_6']['allCorrectAnswersQuizKanji'] as bool,
      data['quizScore_6']['isFinishedKanjiQuizz'] as bool,
      data['quizScore_6']['countCorrects'] as int,
      data['quizScore_6']['countIncorrects'] as int,
      data['quizScore_6']['countOmited'] as int,
      data['quizScore_6']['section'] as int,
      data['quizScore_6']['uuid'] as String,
    },
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
    'quizScore_7': {
      data['quizScore_7']['allCorrectAnswersQuizKanji'] as bool,
      data['quizScore_7']['isFinishedKanjiQuizz'] as bool,
      data['quizScore_7']['countCorrects'] as int,
      data['quizScore_7']['countIncorrects'] as int,
      data['quizScore_7']['countOmited'] as int,
      data['quizScore_7']['section'] as int,
      data['quizScore_7']['uuid'] as String,
    },
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
    'quizScore_8': {
      data['quizScore_8']['allCorrectAnswersQuizKanji'] as bool,
      data['quizScore_8']['isFinishedKanjiQuizz'] as bool,
      data['quizScore_8']['countCorrects'] as int,
      data['quizScore_8']['countIncorrects'] as int,
      data['quizScore_8']['countOmited'] as int,
      data['quizScore_8']['section'] as int,
      data['quizScore_8']['uuid'] as String,
    },
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
    'quizScore_9': {
      data['quizScore_9']['allCorrectAnswersQuizKanji'] as bool,
      data['quizScore_9']['isFinishedKanjiQuizz'] as bool,
      data['quizScore_9']['countCorrects'] as int,
      data['quizScore_9']['countIncorrects'] as int,
      data['quizScore_9']['countOmited'] as int,
      data['quizScore_9']['section'] as int,
      data['quizScore_9']['uuid'] as String,
    },
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
  };
}

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
