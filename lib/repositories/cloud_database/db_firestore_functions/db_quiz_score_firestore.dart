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
  docRef.update({
    'quizScore_$section':
        true /* {
      'allCorrectAnswersQuizKanji': allCorrectAnswersQuizKanji,
      'isFinishedKanjiQuiz': isFinishedKanjiQuiz,
      'countCorrects': countCorrects,
      'countIncorrects': countIncorrects,
      'countOmited': countOmited,
      'section': section,
    } */
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
