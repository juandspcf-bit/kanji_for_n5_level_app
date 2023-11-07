import 'dart:io';

import 'package:async/async.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:dio/dio.dart';

const uuid = Uuid();

Future<Database> get kanjiFromApiDatabase async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, "downloadkanjis.db"),
    onCreate: (db, version) async {
      db.execute(
          'CREATE TABLE strokes(id INTEGER PRIMARY KEY AUTOINCREMENT, strokeImageLink TEXT,'
          ' kanjiCharacter TEXT)');
      db.execute(
          'CREATE TABLE examples(id INTEGER PRIMARY KEY AUTOINCREMENT, japanese TEXT,'
          ' meaning TEXT, opus TEXT, aac TEXT, ogg TEXT, mp3 TEXT, kanjiCharacter TEXT)');
      return db.execute(
          'CREATE TABLE kanji_FromApi(id INTEGER PRIMARY KEY AUTOINCREMENT, kanjiCharacter TEXT,'
          ' englishMeaning TEXT, kanjiImageLink TEXT, katakanaMeaning TEXT, hiraganaMeaning TEXT, videoLink TEXT, section INTEGER)');
    },
    version: 1,
  );
  return db;
}

Future<List<KanjiFromApi>> loadStoredKanjis() async {
  final db = await kanjiFromApiDatabase;
  final dataKanjiFromApi = await db.query('kanji_FromApi');

  if (dataKanjiFromApi.isEmpty) return [];

  final List<KanjiFromApi> kanjisFromApi = [];

  for (final mapKanjiFromDb in dataKanjiFromApi) {
    final kanjiCharacter = mapKanjiFromDb['kanjiCharacter'] as String;
    final listMapExamplesFromDb = await db.rawQuery(
        'SELECT * FROM examples WHERE kanjiCharacter = ? ', [kanjiCharacter]);

    final examples = listMapExamplesFromDb.map((exampleFromDb) {
      final audio = AudioExamples(
          opus: exampleFromDb['opus'] as String,
          aac: exampleFromDb['aac'] as String,
          ogg: exampleFromDb['ogg'] as String,
          mp3: exampleFromDb['mp3'] as String);
      final meaning = Meaning(english: exampleFromDb['meaning'] as String);
      return Example(
          japanese: exampleFromDb['japanese'] as String,
          meaning: meaning,
          audio: audio);
    }).toList();

    final listMapStrokesImagesLisnkFromDb = await db.rawQuery(
        'SELECT * FROM strokes WHERE kanjiCharacter = ? ', [kanjiCharacter]);

    final listStrokesImagesLinks = listMapStrokesImagesLisnkFromDb
        .map((imageLinkMap) => imageLinkMap['strokeImageLink'] as String)
        .toList();

    final strokes = Strokes(
        count: listStrokesImagesLinks.length, images: listStrokesImagesLinks);

    final kanjiFromApi = KanjiFromApi(
      kanjiCharacter: mapKanjiFromDb['kanjiCharacter'] as String,
      englishMeaning: mapKanjiFromDb['englishMeaning'] as String,
      kanjiImageLink: mapKanjiFromDb['kanjiImageLink'] as String,
      katakanaMeaning: mapKanjiFromDb['katakanaMeaning'] as String,
      hiraganaMeaning: mapKanjiFromDb['hiraganaMeaning'] as String,
      videoLink: mapKanjiFromDb['videoLink'] as String,
      section: mapKanjiFromDb['section'] as int,
      accessToKanjiItemsButtons: true,
      statusStorage: StatusStorage.stored,
      example: examples,
      strokes: strokes,
    );

    kanjisFromApi.add(kanjiFromApi);
  }

  return kanjisFromApi;
}

void addToFutureGroup({
  required String path,
  required String link,
  required FutureGroup<Response<dynamic>> group,
  required Dio dio,
}) {
  group.add(dio.download(
    link,
    path,
    onReceiveProgress: (received, total) {
/*         if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + "%");
          //you can build progressbar feature too
        } */
    },
  ));
}

String getPathToDocuments({
  required Directory dirDocumentPath,
  required String link,
}) {
  final lastSeparatorIndex = link.lastIndexOf('/');
  final nameFile = link.substring(lastSeparatorIndex + 1);
  return '${dirDocumentPath.path}/$nameFile';
}

enum DeleteStatus {
  errorMediaLinksFiles,
  succesMediaLinksFiles,
  errorAudioExampleLinksFiles,
  succesAudioExampleLinksFiles,
  errorStrokeLinksFiles,
  succesStrokeLinksFiles,
  errorKanjiDatabase,
  successKanjiDatabase,
  succes,
}
