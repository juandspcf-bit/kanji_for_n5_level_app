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
      allCorrectAnswersQuizKanji: false,
      isFinishedKanjiQuizz: false,
      countCorrects: 0,
      countIncorrects: 0,
      countOmited: 0,
    );
  }

  return SingleQuizSectionData(
    section: listQuery[0]['section'] as int,
    allCorrectAnswersQuizKanji:
        (listQuery[0]['allCorrectAnswersQuizKanji'] as int) == 1,
    isFinishedKanjiQuizz: (listQuery[0]['isFinishedKanjiQuizz'] as int) == 1,
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
  logger.d('data $section');
  final db = await kanjiFromApiDatabase;
  final id1 = await db.rawInsert(
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
  logger.d('the id is $id1');
}

Future<SingleQuizSectionData> getSingleQuizSectionAudioExamplerData(
  int section,
  String uuid,
) async {
  final db = await kanjiFromApiDatabase;
  final listQuery = await db.rawQuery(
      'SELECT * FROM kanji_audio_example_quiz WHERE section = ? AND uuid = ?',
      [section, uuid]);

  if (listQuery.isEmpty) {
    return SingleQuizSectionData(
      section: -1,
      allCorrectAnswersQuizKanji: false,
      isFinishedKanjiQuizz: false,
      countCorrects: 0,
      countIncorrects: 0,
      countOmited: 0,
    );
  }

  return SingleQuizSectionData(
    section: listQuery[0]['section'] as int,
    allCorrectAnswersQuizKanji:
        (listQuery[0]['allCorrectAnswersQuizKanji'] as int) == 1,
    isFinishedKanjiQuizz: (listQuery[0]['isFinishedKanjiQuizz'] as int) == 1,
    countCorrects: listQuery[0]['countCorrects'] as int,
    countIncorrects: listQuery[0]['countIncorrects'] as int,
    countOmited: listQuery[0]['countOmited'] as int,
  );
}
