import 'package:flutter/foundation.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_service/delete_user_exception.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_definitions.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_deleting_data.dart';

Future<void> deleteUserDataSqlite(String uuid) async {
  try {
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
    //await db.rawDelete('DELETE FROM examples WHERE uuid = ?', [uuid]);
    //await db.rawDelete('DELETE FROM strokes WHERE uuid = ?', [uuid]);
    await db.rawDelete('DELETE FROM user_favorites WHERE uuid = ?', [uuid]);
    await db.rawDelete('DELETE FROM kanji_quiz WHERE uuid = ?', [uuid]);
    await db.rawDelete(
        'DELETE FROM kanji_audio_example_quiz WHERE uuid = ?', [uuid]);
    await db
        .rawDelete('DELETE FROM kanji_flashcard_quiz WHERE uuid = ?', [uuid]);
  } catch (e) {
    throw DeleteUserException(
      message: 'error deleting from db storage',
      deleteErrorUserCode: DeleteErrorUserCode.deleteErrorCached,
    );
  }
}

Future<void> insertToTheDeleteErrorQueueSqlite(
  String uuid,
  DeleteErrorUserCode deleteErrorUserCode,
) async {
  if (uuid == '') return;

  final db = await kanjiFromApiDatabase;

  await db.rawInsert(
    'INSERT INTO delete_user_queue('
    ' uuid,'
    ' errorMessage'
    ') '
    'VALUES(?,?)',
    [
      uuid,
      deleteErrorUserCode,
    ],
  );
}

Future<void> deleteUserQueueSqlite() async {
  final db = await kanjiFromApiDatabase;
  final queue = await db.rawQuery('SELECT * FROM delete_user_queue');

  if (queue.isEmpty) return;

  for (var operation in queue) {
    final uuid = operation['uuid'] as String;
    final errorMessage = operation['errorMessage'] as String;

    if (errorMessage == DeleteErrorUserCode.deleteErrorUserData.toString()) {
      //await ref.read(cloudDBServiceProvider).deleteUserData(uuid);
      await db.rawDelete(
          'DELETE FROM delete_user_queue WHERE uuid = ? AND errorMessage = ?',
          [uuid, errorMessage]);
    }

    if (errorMessage == DeleteErrorUserCode.deleteErrorQuizData.toString()) {
      //await cloudDBService.deleteQuizScoreData(uuid);
      await db.rawDelete(
          'DELETE FROM delete_user_queue WHERE uuid = ? AND errorMessage = ?',
          [uuid, errorMessage]);
    }

    if (errorMessage == DeleteErrorUserCode.deleteErrorFavorites.toString()) {
      //await cloudDBService.deleteAllFavoritesCloudDB(uuid);
      await db.rawDelete(
          'DELETE FROM delete_user_queue WHERE uuid = ? AND errorMessage = ?',
          [uuid, errorMessage]);
    }
  }
}
