import 'package:firebase_auth/firebase_auth.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/favorite.dart';
import 'package:kanji_for_n5_level_app/repositories_layer/local_database/db_definitions.dart';

Future<List<Favorite>> loadFavoritesFirebase(String uid) async {
  try {
    final db = await kanjiFromApiDatabase;
    final data =
        await db.query('user_favorites', where: 'uuid = ?', whereArgs: [uid]);
    return data.map((e) {
      return Favorite(
        kanji: e['kanjiCharacter'] as String,
        uuid: e['uuid'] as String,
        timeStamp: e['timeStamp'] as int,
      );
    }).toList();
  } catch (e) {
    logger.e(e);
    return [];
  }
}

Future<Favorite> loadSingleFavoriteFirebase(
    String kanjiCharacter, String uid) async {
  try {
    final db = await kanjiFromApiDatabase;
    final data = await db.query('user_favorites',
        where: 'uuid = ? AND kanjiCharacter= ?',
        whereArgs: [uid, kanjiCharacter]);
    final dataQuery = data.map((e) {
      return Favorite(
        kanji: e['kanjiCharacter'] as String,
        uuid: e['uuid'] as String,
        timeStamp: e['timeStamp'] as int,
      );
    }).toList();
    if (data.isEmpty) {
      return Favorite(
        kanji: '',
        uuid: '',
        timeStamp: -1,
      );
    }
    return dataQuery[0];
  } catch (e) {
    logger.e(e);
    return Favorite(
      kanji: '',
      uuid: '',
      timeStamp: -1,
    );
  }
}

Future<int> insertFavoriteFirebase(String kanji, int timeStamp) async {
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

Future<int> deleteFavoriteFirebase(String kanji) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return Future(() => 0);
  }
  final db = await kanjiFromApiDatabase;
  return await db.delete("user_favorites",
      where: 'kanjiCharacter= ? AND uuid= ?', whereArgs: [kanji, user.uid]);
}

Future<void> storeAllFavoritesFirebase(List<Favorite> favorites) async {
  try {
    final db = await kanjiFromApiDatabase;
    for (var favorite in favorites) {
      final favoriteDB =
          await loadSingleFavoriteFirebase(favorite.kanji, favorite.uuid);

      if (favoriteDB.kanji == '') {
        db.insert("user_favorites", {
          'kanjiCharacter': favorite.kanji,
          'uuid': favorite.uuid,
          'timeStamp': favorite.timeStamp,
        });
      }
    }
  } catch (e) {
    logger.e(e);
  }
}
