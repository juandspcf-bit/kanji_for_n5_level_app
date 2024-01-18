import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/db_contract.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_definitions.dart';

Future<SingleQuizSectionData> getSingleQuizSectionData(
  int section,
  String uuid,
) async {
  final db = await kanjiFromApiDatabase;
  final listQuery = await db.rawQuery(
      'SELECT * FROM kanji_quiz WHERE section = ? AND uuid = ?',
      [section, uuid]);

  if (listQuery.isEmpty) {
    return SingleQuizSectionData(
      section: -1,
      allCorrectAnswers: false,
      isFinishedQuiz: false,
      countCorrects: 0,
      countIncorrects: 0,
      countOmited: 0,
    );
  }

  return SingleQuizSectionData(
    section: listQuery[0]['section'] as int,
    allCorrectAnswers: (listQuery[0]['allCorrectAnswersQuizKanji'] as int) == 1,
    isFinishedQuiz: (listQuery[0]['isFinishedKanjiQuizz'] as int) == 1,
    countCorrects: listQuery[0]['countCorrects'] as int,
    countIncorrects: listQuery[0]['countIncorrects'] as int,
    countOmited: listQuery[0]['countOmited'] as int,
  );
}

Future<(bool, bool)> getAllQuizSectionData(
  String uuid,
) async {
  final db = await kanjiFromApiDatabase;
  final listQuery =
      await db.rawQuery('SELECT * FROM kanji_quiz WHERE uuid = ?', [uuid]);
  if (listQuery.isEmpty) {
    return (
      false,
      false,
    );
  }

  return (
    (listQuery[0]['allCorrectAnswersQuizKanji'] as int) == 1,
    (listQuery[0]['isFinishedKanjiQuizz'] as int) == 1,
  );
}

void updateSingleQuizSectionData(
  int section,
  String uuid,
  bool allCorrectAnswersQuizKanji,
  bool isFinishedKanjiQuizz,
  int countCorrects,
  int countIncorrects,
  int countOmited,
) async {
  final db = await kanjiFromApiDatabase;
  await db.rawUpdate(
      'UPDATE kanji_quiz SET allCorrectAnswersQuizKanji = ?,'
      ' isFinishedKanjiQuizz = ?, countCorrects = ?,'
      ' countIncorrects = ?, countOmited = ?  WHERE section = ? AND uuid = ?',
      [
        allCorrectAnswersQuizKanji ? 1 : 0,
        isFinishedKanjiQuizz ? 1 : 0,
        countCorrects,
        countIncorrects,
        countOmited,
        section,
        uuid,
      ]);
}

void insertSingleQuizSectionDataDB(
  int section,
  String uuid,
  bool allCorrectAnswersQuizKanji,
  bool isFinishedKanjiQuizz,
  int countCorrects,
  int countIncorrects,
  int countOmited,
) async {
  final db = await kanjiFromApiDatabase;
  await db.rawInsert(
      'INSERT INTO kanji_quiz(allCorrectAnswersQuizKanji,'
      ' isFinishedKanjiQuizz, countCorrects, countIncorrects, countOmited, section, uuid)'
      ' VALUES(?,?,?,?,?,?,?)',
      [
        allCorrectAnswersQuizKanji ? 1 : 0,
        isFinishedKanjiQuizz ? 1 : 0,
        countCorrects,
        countIncorrects,
        countOmited,
        section,
        uuid
      ]);
}

Future<SingleQuizAudioExampleData> getSingleQuizSectionAudioExamplerData(
  String kanjiCharacter,
  int section,
  String uuid,
) async {
  final db = await kanjiFromApiDatabase;
  final listQuery = await db.rawQuery(
      'SELECT * FROM kanji_audio_example_quiz'
      ' WHERE kanjiCharacter = ? AND section = ? AND uuid = ?',
      [kanjiCharacter, section, uuid]);

  if (listQuery.isEmpty) {
    return SingleQuizAudioExampleData(
      kanjiCharacter: '',
      section: -1,
      allCorrectAnswers: false,
      isFinishedQuiz: false,
      countCorrects: 0,
      countIncorrects: 0,
      countOmited: 0,
    );
  }

  return SingleQuizAudioExampleData(
    kanjiCharacter: listQuery[0]['kanjiCharacter'] as String,
    section: listQuery[0]['section'] as int,
    allCorrectAnswers: (listQuery[0]['allCorrectAnswers'] as int) == 1,
    isFinishedQuiz: (listQuery[0]['isFinishedQuiz'] as int) == 1,
    countCorrects: listQuery[0]['countCorrects'] as int,
    countIncorrects: listQuery[0]['countIncorrects'] as int,
    countOmited: listQuery[0]['countOmited'] as int,
  );
}

void updateSingleAudioExampleQuizSectionData(
  String kanjiCharacter,
  int section,
  String uuid,
  bool allCorrectAnswers,
  bool isFinishedQuiz,
  int countCorrects,
  int countIncorrects,
  int countOmited,
) async {
  final db = await kanjiFromApiDatabase;
  logger.d('uuid: $uuid, allCorrectAnwers: $allCorrectAnswers,'
      ' isFinishedQuiz: $isFinishedQuiz, corrects: $countCorrects');
  await db.rawUpdate(
      'UPDATE'
      ' kanji_audio_example_quiz '
      'SET'
      ' allCorrectAnswers = ?,'
      ' isFinishedQuiz = ?,'
      ' countCorrects = ?,'
      ' countIncorrects = ?,'
      ' countOmited = ? '
      'WHERE'
      ' kanjiCharacter = ? AND section = ? AND uuid = ?',
      [
        allCorrectAnswers ? 1 : 0,
        isFinishedQuiz ? 1 : 0,
        countCorrects,
        countIncorrects,
        countOmited,
        kanjiCharacter,
        section,
        uuid,
      ]);
}

void insertSingleAudioExampleQuizSectionDataDB(
  int section,
  String uuid,
  String kanjiCharacter,
  bool allCorrectAnswers,
  bool isFinishedQuiz,
  int countCorrects,
  int countIncorrects,
  int countOmited,
) async {
  logger.d('uuid: $uuid, corrects: $countCorrects,'
      ' countIncorrects: $countIncorrects, countOmited: $countOmited');
  final db = await kanjiFromApiDatabase;
  try {
    await db.rawInsert(
        'INSERT INTO kanji_audio_example_quiz('
        ' kanjiCharacter,'
        ' allCorrectAnswers,'
        ' isFinishedQuiz,'
        ' countCorrects,'
        ' countIncorrects,'
        ' countOmited,'
        ' section,'
        ' uuid)'
        ' VALUES(?,?,?,?,?,?,?,?)',
        [
          kanjiCharacter,
          allCorrectAnswers ? 1 : 0,
          isFinishedQuiz ? 1 : 0,
          countCorrects,
          countIncorrects,
          countOmited,
          section,
          uuid
        ]);
  } catch (e) {
    logger.e(e);
  }
}
