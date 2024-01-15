import 'package:kanji_for_n5_level_app/repositories/local_database/db_definitions.dart';

Future<(int, bool, bool)> getSingleQuizSectionData(
  int section,
  String uuid,
) async {
  final db = await kanjiFromApiDatabase;
  final listQuery = await db.rawQuery(
      'SELECT * FROM kanji_quiz WHERE section = ? AND uuid = ?',
      [section, uuid]);

  if (listQuery.isEmpty) {
    return (
      section,
      false,
      false,
    );
  }

  return (
    listQuery[0]['section'] as int,
    (listQuery[0]['allCorrectAnswersQuizKanji'] as int) == 1,
    (listQuery[0]['isFinishedKanjiQuizz'] as int) == 1,
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
) async {
  final db = await kanjiFromApiDatabase;
  await db.rawUpdate(
      'UPDATE kanji_quiz SET allCorrectAnswersQuizKanji = ?,'
      ' isFinishedKanjiQuizz = ? WHERE section = ? AND uuid = ?',
      [allCorrectAnswersQuizKanji, isFinishedKanjiQuizz, section, uuid]);
}
