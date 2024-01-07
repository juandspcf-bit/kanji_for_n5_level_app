import 'package:firebase_auth/firebase_auth.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_definitions.dart';

Future<List<Favorite>> loadFavorites() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return Future(() => []);
  }

  final db = await kanjiFromApiDatabase;
  final data = await db
      .query('user_favorites', where: 'uuid = ?', whereArgs: [user.uid]);
  return data.map((e) {
    return Favorite(
      kanjis: e['kanjiCharacter'] as String,
      uuid: e['uuid'] as String,
      timeStamp: e['timeStamp'] as int,
    );
  }).toList();
}

Future<int> insertFavorite(String kanji, int timeStamp) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return Future(() => 0);
  }
  final db = await kanjiFromApiDatabase;
  return db.insert("user_favorites", {
    'kanjiCharacter': kanji,
    'uuid': user.uid,
    'timeStamp': timeStamp,
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

class Favorite {
  final String kanjis;
  final String uuid;
  final int timeStamp;

  Favorite({required this.kanjis, required this.uuid, required this.timeStamp});
}
