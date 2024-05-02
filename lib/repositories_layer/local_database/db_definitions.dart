import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sql;

Future _onConfigure(Database db) async {
  await db.execute('PRAGMA foreign_keys = ON');
}

Future<Database> get kanjiFromApiDatabase async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, "downloadkanjis.db"),
    onConfigure: _onConfigure,
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE firts_logging_status('
        ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
        ' isLogged INTEGER,'
        ' uuid TEXT'
        ')',
      );

      await db.execute(
        'CREATE TABLE delete_user_queue('
        ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
        ' uuid TEXT,'
        ' errorMessage TEXT'
        ')',
      );

      await db.execute(
        'CREATE TABLE user_data('
        ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
        ' uuid TEXT,'
        ' fullName TEXT,'
        ' linkAvatar TEXT,'
        ' pathAvatar TEXT'
        ')',
      );

      await db.execute(
        'CREATE TABLE kanji_quiz('
        ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
        ' allCorrectAnswersQuizKanji INTEGER,'
        ' isFinishedKanjiQuizz INTEGER,'
        ' countCorrects INTEGER,'
        ' countIncorrects INTEGER,'
        ' countOmited INTEGER,'
        ' section INTEGER,'
        ' uuid TEXT'
        ')',
      );

      await db.execute(
        'CREATE TABLE kanji_audio_example_quiz('
        ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
        ' kanjiCharacter TEXT,'
        ' allCorrectAnswers INTEGER,'
        ' isFinishedQuiz INTEGER,'
        ' countCorrects INTEGER,'
        ' countIncorrects INTEGER,'
        ' countOmited INTEGER,'
        ' section INTEGER,'
        ' uuid TEXT'
        ')',
      );

      await db.execute(
        'CREATE TABLE kanji_flashcard_quiz('
        ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
        ' kanjiCharacter TEXT,'
        ' section INTEGER,'
        ' uuid TEXT,'
        ' allRevisedFlashCards INTEGER'
        ' )',
      );

      await db.execute(
        'CREATE TABLE user_favorites('
        ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
        ' kanjiCharacter TEXT,'
        ' uuid TEXT,'
        ' timeStamp INTEGER '
        ')',
      );

      await db.execute(
        'CREATE TABLE strokes('
        ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
        ' strokeImageLink TEXT,'
        ' kanjiCharacter TEXT,'
        ' uuid TEXT,'
        ' kanji_id INTEGER,'
        ' FOREIGN KEY (kanji_id) REFERENCES kanji_FromApi(id)'
        '   ON DELETE CASCADE'
        ')',
      );

      await db.execute(
        'CREATE TABLE image_meaning('
        ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
        ' kanjiCharacter TEXT,'
        ' link TEXT,'
        ' linkHeight INTEGER,'
        ' linkWidth INTEGER,'
        ' uuid TEXT,'
        ' kanji_id INTEGER,'
        ' FOREIGN KEY (kanji_id) REFERENCES kanji_FromApi(id)'
        '   ON DELETE CASCADE'
        ')',
      );

      await db.execute(
        'CREATE TABLE examples('
        ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
        ' japanese TEXT,'
        ' meaning TEXT,'
        ' opus TEXT,'
        ' aac TEXT,'
        ' ogg TEXT,'
        ' mp3 TEXT,'
        ' kanjiCharacter TEXT,'
        ' uuid TEXT,'
        ' kanji_id INTEGER,'
        ' FOREIGN KEY (kanji_id) REFERENCES kanji_FromApi(id)'
        '   ON DELETE CASCADE'
        ')',
      );

      return db.execute(
        'CREATE TABLE kanji_FromApi('
        ' id INTEGER PRIMARY KEY AUTOINCREMENT,'
        ' kanjiCharacter TEXT,'
        ' englishMeaning TEXT,'
        ' kanjiImageLink TEXT,'
        ' katakanaMeaning TEXT,'
        ' hiraganaMeaning TEXT,'
        ' videoLink TEXT,'
        ' section INTEGER,'
        ' uuid TEXT'
        ')',
      );
    },
    version: 1,
  );
  return db;
}
