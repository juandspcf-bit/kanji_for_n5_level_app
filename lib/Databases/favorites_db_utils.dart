import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, "favorites.db"),
    onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE user_favorites(id INTEGER PRIMARY KEY AUTOINCREMENT, kanjiCharacter TEXT)");
    },
    version: 1,
  );
  return db;
}

Future<List<String>> loadFavorites() async {
  final db = await _getDatabase();
  final data = await db.query('user_favorites');
  return data.map((e) => e['kanjiCharacter'] as String).toList();
}

Future<int> insertFavorite(String kanji) async {
  final db = await _getDatabase();
  return db.insert("user_favorites", {
    'kanjiCharacter': kanji,
  });
}

Future<int> deleteFavorite(String kanji) async {
  final db = await _getDatabase();
  return await db
      .delete("user_favorites", where: 'kanjiCharacter= ?', whereArgs: [kanji]);
}
