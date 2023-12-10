import 'package:firebase_auth/firebase_auth.dart';
import 'package:kanji_for_n5_level_app/Databases/db_definitions.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

Future<List<String>> loadFavorites() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return Future(() => []);
  }

  logger.d(user.displayName);

  final db = await kanjiFromApiDatabase;
  final data = await db
      .query('user_favorites', where: 'uuid = ?', whereArgs: [user.uid]);
  return data.map((e) => e['kanjiCharacter'] as String).toList();
}

Future<int> insertFavorite(String kanji) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return Future(() => 0);
  }
  final db = await kanjiFromApiDatabase;
  return db.insert("user_favorites", {
    'kanjiCharacter': kanji,
    'uuid': user.uid,
  });
}

Future<int> deleteFavorite(String kanji) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return Future(() => 0);
  }
  final db = await kanjiFromApiDatabase;
  return await db.delete("user_favorites",
      where: 'kanjiCharacter= ? AND uuid= ?', whereArgs: [kanji, user.uid]);
}
