import 'package:firebase_auth/firebase_auth.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, "favorites.db"),
    onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE user_favorites(id INTEGER PRIMARY KEY AUTOINCREMENT, kanjiCharacter TEXT), uuid TEXT");
    },
    version: 1,
  );
  return db;
}

Future<List<String>> loadFavorites() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return Future(() => []);
  }

  final db = await _getDatabase();
  final data = await db
      .query('user_favorites', where: 'uuid = ?', whereArgs: [user.uid]);
  return data.map((e) => e['kanjiCharacter'] as String).toList();
}

Future<int> insertFavorite(String kanji) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return Future(() => 0);
  }
  final db = await _getDatabase();
  return db.insert("user_favorites", {
    'kanjiCharacter': kanji,
    'uuid': user.uid,
  });
}

Future<int> deleteFavorite(String kanji) async {
  final db = await _getDatabase();
  return await db
      .delete("user_favorites", where: 'kanjiCharacter= ?', whereArgs: [kanji]);
}
