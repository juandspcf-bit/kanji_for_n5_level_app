import 'package:flutter/foundation.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_definitions.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_deleting_data.dart';

Future<void> deleteUserDataFromSqlDB(String uuid) async {
  final db = await kanjiFromApiDatabase;

  final listKanjiMapFromDb =
      await db.rawQuery('SELECT * FROM kanji_FromApi WHERE uuid = ?', [uuid]);
  final listMapExamplesFromDb =
      await db.rawQuery('SELECT * FROM examples WHERE uuid = ?', [uuid]);
  final listMapStrokesImagesLisnkFromDb = await db.rawQuery(
      'SELECT * FROM strokes WHERE kanjiCharacter = ? AND uuid = ?', [uuid]);

  final parametersDelete = ParametersDelete(
      listKanjiMapFromDb: listKanjiMapFromDb,
      listMapExamplesFromDb: listMapExamplesFromDb,
      listMapStrokesImagesLisnkFromDb: listMapStrokesImagesLisnkFromDb);

  await compute(deleteKanjiFromApiComputeVersion, parametersDelete);

  await db.rawDelete('DELETE FROM kanji_FromApi WHERE uuid = ?', [uuid]);
  await db.rawDelete('DELETE FROM examples WHERE uuid = ?', [uuid]);
  await db.rawDelete('DELETE FROM strokes WHERE uuid = ?', [uuid]);
  await db.rawDelete('DELETE FROM kanji_quiz WHERE uuid = ?', [uuid]);
  await db
      .rawDelete('DELETE FROM kanji_audio_example_quiz WHERE uuid = ?', [uuid]);
  await db.rawDelete('DELETE FROM kanji_flashcard_quiz WHERE uuid = ?', [uuid]);
}
