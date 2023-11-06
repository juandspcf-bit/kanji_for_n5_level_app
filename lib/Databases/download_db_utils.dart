import 'dart:io';

import 'package:async/async.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_content.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

const uuid = Uuid();

Future<Database> get kanjiFromApiDatabase async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, "downloadkanjis.db"),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE kanji_FromApi(id INTEGER PRIMARY KEY AUTOINCREMENT, kanjiCharacter TEXT,'
          ' englishMeaning TEXT, kanjiImageLink TEXT, katakanaMeaning TEXT, hiraganaMeaning TEXT, videoLink TEXT, section INTEGER)');
    },
    version: 1,
  );
  return db;
}

Future<Database> get examplesDatabase async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, "examples.db"),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE examples(id INTEGER PRIMARY KEY AUTOINCREMENT, japanese TEXT,'
          ' meaning TEXT, opus TEXT, aac TEXT, ogg TEXT, mp3 TEXT, kanjiCharacter TEXT)');
    },
    version: 1,
  );
  return db;
}

Future<Database> get strokesDatabase async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, "strokes.db"),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE strokes(id INTEGER PRIMARY KEY AUTOINCREMENT, strokeImageLink TEXT,'
          ' kanjiCharacter TEXT)');
    },
    version: 1,
  );
  return db;
}

Future<List<KanjiFromApi>> loadStoredKanjis() async {
  final dbKanjiFromApi = await kanjiFromApiDatabase;
  final dbExamples = await examplesDatabase;
  final dbStrokes = await strokesDatabase;
  final dataKanjiFromApi = await dbKanjiFromApi.query('kanji_FromApi');

  if (dataKanjiFromApi.isEmpty) return [];

  final List<KanjiFromApi> kanjisFromApi = [];

  for (final mapKanjiFromDb in dataKanjiFromApi) {
    final kanjiCharacter = mapKanjiFromDb['kanjiCharacter'] as String;
    final listMapExamplesFromDb = await dbExamples.rawQuery(
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

    final listMapStrokesImagesLisnkFromDb = await dbStrokes.rawQuery(
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

Future<KanjiFromApi> insertKanjiFromApi(
  KanjiFromApi kanjiFromApi,
) async {
  final examplesMap = await insertExampleEntry(kanjiFromApi);
  final strokesPaths = await insertStrokesEntry(kanjiFromApi);

  final kanjiMap = await insertKanjiEntry(kanjiFromApi);

  final List<Example> examples = [];
  for (var exampleMap in examplesMap) {
    final audioExample = AudioExamples(
      opus: exampleMap['opus'] ?? '',
      aac: exampleMap['aac'] ?? '',
      ogg: exampleMap['ogg'] ?? '',
      mp3: exampleMap['mp3'] ?? '',
    );
    final example = Example(
        japanese: exampleMap['japanese'] ?? '',
        meaning: Meaning(english: exampleMap['meaning'] ?? ''),
        audio: audioExample);
    examples.add(example);
  }

  final strokes = Strokes(count: strokesPaths.length, images: strokesPaths);

  return KanjiFromApi(
      kanjiCharacter: kanjiMap['kanjiCharacter'] ?? '',
      englishMeaning: kanjiMap['englishMeaning'] ?? '',
      kanjiImageLink: kanjiMap['kanjiImageLink'] ?? '',
      katakanaMeaning: kanjiMap['katakanaMeaning'] ?? '',
      hiraganaMeaning: kanjiMap['hiraganaMeaning'] ?? '',
      videoLink: kanjiMap['videoLink'] ?? '',
      section: int.parse(kanjiMap['section'] ?? '0'),
      statusStorage: StatusStorage.stored,
      accessToKanjiItemsButtons: true,
      example: examples,
      strokes: strokes);
}

Future<List<Map<String, String>>> insertExampleEntry(
    KanjiFromApi kanjiFromApi) async {
  List<Map<String, String>> exampleMaps = [];
  for (var example in kanjiFromApi.example) {
    final exampleMap =
        await downloadExample(example, kanjiFromApi.kanjiCharacter);
    exampleMaps.add(exampleMap);
  }

  final dbExamples = await examplesDatabase;
  FutureGroup<int> groupDb = FutureGroup<int>();
  for (var exampleMap in exampleMaps) {
    groupDb.add(dbExamples.insert('examples', exampleMap));
  }

  groupDb.close();

  await groupDb.future;

  return exampleMaps;
}

Future<Map<String, String>> downloadExample(
  Example example,
  String kanjiCharacter,
) async {
  final dirDocumentPath = await getApplicationDocumentsDirectory();
  FutureGroup<Response<dynamic>> group = FutureGroup<Response<dynamic>>();
  final List<String> pathsToDocuments = [];
  final audioLinks = [
    example.audio.opus,
    example.audio.aac,
    example.audio.ogg,
    example.audio.mp3
  ];

  for (var audioLink in audioLinks) {
    final path = getPathToDocuments(
      dirDocumentPath: dirDocumentPath,
      link: audioLink,
    );
    pathsToDocuments.add(path);
    addToFutureGroup(path: path, link: audioLink, group: group, dio: dio);
  }

  group.close();

  await group.future;
  return {
    'japanese': example.japanese,
    'meaning': example.meaning.english,
    'opus': pathsToDocuments[0],
    'aac': pathsToDocuments[1],
    'ogg': pathsToDocuments[2],
    'mp3': pathsToDocuments[3],
    'kanjiCharacter': kanjiCharacter,
  };
}

Future<List<String>> insertStrokesEntry(KanjiFromApi kanjiFromApi) async {
  final dirDocumentPath = await getApplicationDocumentsDirectory();
  FutureGroup<Response<dynamic>> group = FutureGroup<Response<dynamic>>();
  final List<String> pathsToDocuments = [];
  for (var strokeImageLink in kanjiFromApi.strokes.images) {
    final path = getPathToDocuments(
      dirDocumentPath: dirDocumentPath,
      link: strokeImageLink,
    );

    pathsToDocuments.add(path);
    addToFutureGroup(path: path, link: strokeImageLink, group: group, dio: dio);
  }

  group.close();

  await group.future;

  final dbStrokes = await strokesDatabase;
  FutureGroup<int> groupDb = FutureGroup<int>();
  for (var strokeImagePath in pathsToDocuments) {
    final strokeMap = {
      'strokeImageLink': strokeImagePath,
      'kanjiCharacter': kanjiFromApi.kanjiCharacter,
    };
    groupDb.add(dbStrokes.insert('strokes', strokeMap));
  }
  groupDb.close();
  await groupDb.future;
  return pathsToDocuments;
}

Future<Map<String, String>> insertKanjiEntry(KanjiFromApi kanjiFromApi) async {
  final dirDocumentPath = await getApplicationDocumentsDirectory();
  FutureGroup<Response<dynamic>> group = FutureGroup<Response<dynamic>>();
  final List<String> pathsToDocuments = [];

  List<String> listLinks = [
    kanjiFromApi.kanjiImageLink,
    kanjiFromApi.videoLink
  ];

  for (var kanjiLink in listLinks) {
    final path = getPathToDocuments(
      dirDocumentPath: dirDocumentPath,
      link: kanjiLink,
    );

    pathsToDocuments.add(path);
    addToFutureGroup(path: path, link: kanjiLink, group: group, dio: dio);
  }

  group.close();

  await group.future;

  final dbKanjiFromApi = await kanjiFromApiDatabase;
  final kanjiMap = {
    'kanjiCharacter': kanjiFromApi.kanjiCharacter,
    'englishMeaning': kanjiFromApi.englishMeaning,
    'kanjiImageLink': pathsToDocuments[0],
    'katakanaMeaning': kanjiFromApi.katakanaMeaning,
    'hiraganaMeaning': kanjiFromApi.hiraganaMeaning,
    'videoLink': pathsToDocuments[1],
    'section': kanjiFromApi.section
  };

  await dbKanjiFromApi.insert("kanji_FromApi", kanjiMap);
  return {
    'kanjiCharacter': kanjiFromApi.kanjiCharacter,
    'englishMeaning': kanjiFromApi.englishMeaning,
    'kanjiImageLink': pathsToDocuments[0],
    'katakanaMeaning': kanjiFromApi.katakanaMeaning,
    'hiraganaMeaning': kanjiFromApi.hiraganaMeaning,
    'videoLink': pathsToDocuments[1],
    'section': kanjiFromApi.section.toString()
  };
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

Future<List<DeleteStatus>> deleteKanjiFromApi(KanjiFromApi kanjiFromApi) async {
  final dbKanjiFromApi = await kanjiFromApiDatabase;
  final dbExamples = await examplesDatabase;
  final dbStrokes = await strokesDatabase;

  final List<DeleteStatus> listDeleteStatus = [];

  final listKanjiMapFromDb = await dbKanjiFromApi.rawQuery(
      'SELECT * FROM kanji_FromApi WHERE kanjiCharacter = ? ',
      [kanjiFromApi.kanjiCharacter]);

  if (listKanjiMapFromDb.isNotEmpty) {
    try {
      FutureGroup<FileSystemEntity> groupKanjiImageLinkFile =
          FutureGroup<FileSystemEntity>();

      listKanjiMapFromDb.map((e) => e['kanjiImageLink'] as String).map((e) {
        final kanjiImageLinkFile = File(e);
        groupKanjiImageLinkFile.add(kanjiImageLinkFile.delete());
      });

      groupKanjiImageLinkFile.close();
      await groupKanjiImageLinkFile.future;

      FutureGroup<FileSystemEntity> groupKanjiVideoLinkFile =
          FutureGroup<FileSystemEntity>();

      listKanjiMapFromDb.map((e) => e['videoLink'] as String).map((e) {
        final videoLinkFile = File(e);
        groupKanjiVideoLinkFile.add(videoLinkFile.delete());
      });

      groupKanjiVideoLinkFile.close();
      await groupKanjiVideoLinkFile.future;
    } catch (e) {
      e.toString();

      listDeleteStatus.add(DeleteStatus.errorMediaLinksFiles);
    }
  }

  final listMapExamplesFromDb = await dbExamples.rawQuery(
      'SELECT * FROM examples WHERE kanjiCharacter = ? ',
      [kanjiFromApi.kanjiCharacter]);

  if (listMapExamplesFromDb.isNotEmpty) {
    try {
      FutureGroup<int> groupKanjiExampleAudioLinksFile = FutureGroup<int>();

      listMapExamplesFromDb.map((exampleFromDb) {
        return AudioExamples(
            opus: exampleFromDb['opus'] as String,
            aac: exampleFromDb['aac'] as String,
            ogg: exampleFromDb['ogg'] as String,
            mp3: exampleFromDb['mp3'] as String);
      }).map((e) async {
        groupKanjiExampleAudioLinksFile.add(Future(() async {
          final opusFile = File(e.opus);
          await opusFile.delete();
          final aacFile = File(e.aac);
          await aacFile.delete();
          final oggFile = File(e.ogg);
          await oggFile.delete();
          final mp3File = File(e.mp3);
          await mp3File.delete();
          return 1;
        }));
      });

      groupKanjiExampleAudioLinksFile.close();
      await groupKanjiExampleAudioLinksFile.future;
    } catch (e) {
      e.toString();

      listDeleteStatus.add(DeleteStatus.errorAudioExampleLinksFiles);
    }
  }

  final listMapStrokesImagesLisnkFromDb = await dbStrokes.rawQuery(
      'SELECT * FROM strokes WHERE kanjiCharacter = ? ',
      [kanjiFromApi.kanjiCharacter]);

  if (listMapStrokesImagesLisnkFromDb.isNotEmpty) {
    try {
      FutureGroup<FileSystemEntity> groupKanjiStrokesLinksFile =
          FutureGroup<FileSystemEntity>();

      listMapStrokesImagesLisnkFromDb
          .map((imageLinkMap) => imageLinkMap['strokeImageLink'] as String)
          .map((e) {
        final strokeLinkFile = File(e);
        groupKanjiStrokesLinksFile.add(strokeLinkFile.delete());
      });

      groupKanjiStrokesLinksFile.close();
      await groupKanjiStrokesLinksFile.future;
    } catch (e) {
      e.toString();

      listDeleteStatus.add(DeleteStatus.errorStrokeLinksFiles);
    }
  }

  try {
    await dbKanjiFromApi.rawDelete(
        'DELETE FROM kanji_FromApi WHERE kanjiCharacter = ?',
        [kanjiFromApi.kanjiCharacter]);
    await dbExamples.rawDelete('DELETE FROM examples WHERE kanjiCharacter = ?',
        [kanjiFromApi.kanjiCharacter]);
    await dbStrokes.rawDelete('DELETE FROM strokes WHERE kanjiCharacter = ?',
        [kanjiFromApi.kanjiCharacter]);
    listDeleteStatus.add(DeleteStatus.succes);
  } catch (e) {
    e.toString();
    listDeleteStatus.add(DeleteStatus.errorKanjiDatabase);
  }

  return listDeleteStatus;
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
