import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

const uuid = Uuid();

Future<Database> get kanjiFromApiDatabase async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, "downloadkanjis.db"),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE kanji_FromApi(id INTEGER PRIMARY KEY AUTOINCREMENT, kanjiCharacter TEXT,'
          ' englishMeaning TEXT, kanjiImageLink TEXT, katakanaMeaning TEXT, hiraganaMeaning TEXT, videoLink TEXT,'
          ' examplesUuid TEXT, strokesUuid TEXT)');
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
          ' meaning TEXT, opus TEXT, aac TEXT, ogg TEXT, mp3 TEXT, examplesUuid TEXT)');
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
          ' strokesUuid TEXT)');
    },
    version: 1,
  );
  return db;
}

Future<int> insertKanjiFromApi(KanjiFromApi kanjiFromApi) async {
  final dbKanjiFromApi = await kanjiFromApiDatabase;
  final dbExamples = await examplesDatabase;
  final dbStrokes = await strokesDatabase;

  final uuidForDb = uuid.v4();

  for (var example in kanjiFromApi.example) {
    final exampleObject = {
      'japanese': example.japanese,
      'meaning': example.meaning.english,
      'opus': example.audio.opus,
      'aac': example.audio.aac,
      'ogg': example.audio.ogg,
      'mp3': example.audio.mp3,
      'examplesUuid': uuidForDb,
    };
    await dbExamples.insert('examples', exampleObject);
  }

  for (var strokeImage in kanjiFromApi.strokes.images) {
    final strokeObject = {
      'strokeImageLink': strokeImage,
      'strokesUuid': uuidForDb,
    };
    await dbStrokes.insert('strokes', strokeObject);
  }

  return dbKanjiFromApi.insert("kanji_FromApi", {
    'kanjiCharacter': kanjiFromApi.kanjiCharacter,
    'englishMeaning': kanjiFromApi.englishMeaning,
    'kanjiImageLink': kanjiFromApi.kanjiImageLink,
    'katakanaMeaning': kanjiFromApi.katakanaMeaning,
    'hiraganaMeaning': kanjiFromApi.hiraganaMeaning,
    'videoLink': kanjiFromApi.videoLink,
    'examplesUuid': uuidForDb,
    'strokesUuid': uuidForDb,
  });
}

Future<List<KanjiFromApi>> loadStoredKanjis() async {
  final dbKanjiFromApi = await kanjiFromApiDatabase;
  final dbExamples = await examplesDatabase;
  final dbStrokes = await strokesDatabase;
  final data = await dbKanjiFromApi.query('kanji_FromApi');

  if (data.isEmpty) return [];

  final listFutures = data.map((kanjiFromApi) async {
    final exampleUuid = kanjiFromApi['examplesUuid'] as String;
    final listMapExamplesFromDb = await dbExamples.rawQuery(
        'SELECT * FROM examples WHERE examplesUuid = ? ', [exampleUuid]);

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

    final strokesUuid = kanjiFromApi['strokesUuid'] as String;
    final listMapStrokesImagesLisnkFromDb = await dbStrokes.rawQuery(
        'SELECT * FROM strokes WHERE strokesUuid = ? ', [strokesUuid]);

    final listStrokesImagesLinks = listMapStrokesImagesLisnkFromDb
        .map((imageLinkMap) => imageLinkMap['strokeImageLink'] as String)
        .toList();

    final strokes = Strokes(
        count: listStrokesImagesLinks.length, images: listStrokesImagesLinks);

    return KanjiFromApi(
        kanjiCharacter: kanjiFromApi['kanjiCharacter'] as String,
        englishMeaning: kanjiFromApi['englishMeaning'] as String,
        kanjiImageLink: kanjiFromApi['kanjiImageLink'] as String,
        katakanaMeaning: kanjiFromApi['katakanaMeaning'] as String,
        hiraganaMeaning: kanjiFromApi['hiraganaMeaning'] as String,
        videoLink: kanjiFromApi['videoLink'] as String,
        example: examples,
        strokes: strokes);

    //return kanjiFromApi['kanjiCharacter'] as String;
  }).toList();

  final List<KanjiFromApi> kanjisFromApi = [];
  for (var element in listFutures) {
    final kanjiFromApi = await element;
    kanjisFromApi.add(kanjiFromApi);
  }

  return kanjisFromApi;
}
