import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_definitions.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

Future<void> deleteKanjiFromSqlDB(
    KanjiFromApi kanjiFromApi, String uuid) async {
  final db = await kanjiFromApiDatabase;

  final listKanjiMapFromDb = await db.rawQuery(
      'SELECT * FROM kanji_FromApi WHERE kanjiCharacter = ? AND uuid = ?',
      [kanjiFromApi.kanjiCharacter, uuid]);
  final listMapExamplesFromDb = await db.rawQuery(
      'SELECT * FROM examples WHERE kanjiCharacter = ? AND uuid = ?',
      [kanjiFromApi.kanjiCharacter, uuid]);
  final listMapStrokesImagesLinksFromDb = await db.rawQuery(
      'SELECT * FROM strokes WHERE kanjiCharacter = ? AND uuid = ?',
      [kanjiFromApi.kanjiCharacter, uuid]);

  final parametersDelete = ParametersDelete(
      listKanjiMapFromDb: listKanjiMapFromDb,
      listMapExamplesFromDb: listMapExamplesFromDb,
      listMapStrokesImagesLinksFromDb: listMapStrokesImagesLinksFromDb);

  await compute(deleteKanjiFromApiComputeVersion, parametersDelete);

  await db.rawDelete(
      'DELETE FROM kanji_FromApi WHERE kanjiCharacter = ? AND uuid = ?',
      [kanjiFromApi.kanjiCharacter, uuid]);
}

class ParametersDelete {
  final List<Map<String, Object?>> listKanjiMapFromDb;
  final List<Map<String, Object?>> listMapExamplesFromDb;
  final List<Map<String, Object?>> listMapStrokesImagesLinksFromDb;

  ParametersDelete({
    required this.listKanjiMapFromDb,
    required this.listMapExamplesFromDb,
    required this.listMapStrokesImagesLinksFromDb,
  });
}

Future<void> deleteKanjiFromApiComputeVersion(
    ParametersDelete parametersDelete) async {
  if (parametersDelete.listKanjiMapFromDb.isNotEmpty) {
    try {
      FutureGroup<FileSystemEntity> groupKanjiImageLinkFile =
          FutureGroup<FileSystemEntity>();

      parametersDelete.listKanjiMapFromDb
          .map((e) => e['kanjiImageLink'] as String)
          .map((e) {
        final kanjiImageLinkFile = File(e);
        groupKanjiImageLinkFile.add(kanjiImageLinkFile.delete());
      });

      groupKanjiImageLinkFile.close();
      await groupKanjiImageLinkFile.future;

      FutureGroup<FileSystemEntity> groupKanjiVideoLinkFile =
          FutureGroup<FileSystemEntity>();

      parametersDelete.listKanjiMapFromDb
          .map((e) => e['videoLink'] as String)
          .map((e) {
        final videoLinkFile = File(e);
        groupKanjiVideoLinkFile.add(videoLinkFile.delete());
      });

      groupKanjiVideoLinkFile.close();
      await groupKanjiVideoLinkFile.future;
    } catch (e) {
      e.toString();
    }
  }

  if (parametersDelete.listMapExamplesFromDb.isNotEmpty) {
    try {
      FutureGroup<int> groupKanjiExampleAudioLinksFile = FutureGroup<int>();

      parametersDelete.listMapExamplesFromDb.map((exampleFromDb) {
        return AudioExamples(mp3: exampleFromDb['mp3'] as String);
      }).map((e) async {
        groupKanjiExampleAudioLinksFile.add(Future(() async {
          final mp3File = File(e.mp3);
          await mp3File.delete();
          return 1;
        }));
      });

      groupKanjiExampleAudioLinksFile.close();
      await groupKanjiExampleAudioLinksFile.future;
    } catch (e) {
      e.toString();
    }
  }

  if (parametersDelete.listMapStrokesImagesLinksFromDb.isNotEmpty) {
    try {
      FutureGroup<FileSystemEntity> groupKanjiStrokesLinksFile =
          FutureGroup<FileSystemEntity>();

      parametersDelete.listMapStrokesImagesLinksFromDb
          .map((imageLinkMap) => imageLinkMap['strokeImageLink'] as String)
          .map((e) {
        final strokeLinkFile = File(e);
        groupKanjiStrokesLinksFile.add(strokeLinkFile.delete());
      });

      groupKanjiStrokesLinksFile.close();
      await groupKanjiStrokesLinksFile.future;
    } catch (e) {
      e.toString();
    }
  }
}

Future<void> cleanInvalidRecords(List<KanjiFromApi> listOfInvalidKanjis) async {
  final db = await kanjiFromApiDatabase;

  for (var kanjiFromApi in listOfInvalidKanjis) {
    await db.rawDelete('DELETE FROM kanji_FromApi WHERE kanjiCharacter = ?',
        [kanjiFromApi.kanjiCharacter]);
  }
}
