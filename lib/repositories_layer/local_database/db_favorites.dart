import 'package:firebase_auth/firebase_auth.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/favorite.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_definitions.dart';

Future<List<Favorite>> loadFavorites(String uid) async {
  try {
    final db = await kanjiFromApiDatabase;
    final data =
        await db.query('user_favorites', where: 'uuid = ?', whereArgs: [uid]);
    return data.map((e) {
      return Favorite(
        kanjis: e['kanjiCharacter'] as String,
        uuid: e['uuid'] as String,
        timeStamp: e['timeStamp'] as int,
      );
    }).toList();
  } catch (e) {
    logger.e(e);
    return [];
  }
}

Future<Favorite> loadSingleFavorite(String kanjiCharacter, String uid) async {
  try {
    final db = await kanjiFromApiDatabase;
    final data = await db.query('user_favorites',
        where: 'uuid = ? AND kanjiCharacter= ?',
        whereArgs: [uid, kanjiCharacter]);
    final dataQuery = data.map((e) {
      return Favorite(
        kanjis: e['kanjiCharacter'] as String,
        uuid: e['uuid'] as String,
        timeStamp: e['timeStamp'] as int,
      );
    }).toList();
    if (data.isEmpty) {
      return Favorite(
        kanjis: '',
        uuid: '',
        timeStamp: -1,
      );
    }
    return dataQuery[0];
  } catch (e) {
    logger.e(e);
    return Favorite(
      kanjis: '',
      uuid: '',
      timeStamp: -1,
    );
  }
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

Future<void> storeAllFavorites(List<Favorite> favorites) async {
  try {
    final db = await kanjiFromApiDatabase;
    for (var favorite in favorites) {
      final favoriteDB =
          await loadSingleFavorite(favorite.kanjis, favorite.uuid);

      if (favoriteDB.kanjis == '') {
        db.insert("user_favorites", {
          'kanjiCharacter': favorite.kanjis,
          'uuid': favorite.uuid,
          'timeStamp': favorite.timeStamp,
        });
      }
    }
  } catch (e) {
    logger.e(e);
  }
}
