import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/favorite.dart';

Future<List<Favorite>> loadFavoriteKanjis(
  String uuid,
) async {
  List<Favorite> listFavorites = [];
  try {
    final querySnapshot = await dbFirebase
        .collection("favorites")
        .where("uuid", isEqualTo: uuid)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      for (var docSnapshot in querySnapshot.docs) {
        final favoriteMap = docSnapshot.data();
        listFavorites.add(Favorite(
          kanjis: favoriteMap['kanjiCharacter'],
          uuid: favoriteMap['uuid'],
          timeStamp: favoriteMap['timeStamp'],
        ));
      }
    }
  } catch (e) {
    logger.e('error reading cloud db favorites');
  }

  return listFavorites;
}

Future<void> insertFavorite(
  String kanjiCharacter,
  int timeStamp,
  String uuid,
) {
  final data = <String, Object>{
    'kanjiCharacter': kanjiCharacter,
    'timeStamp': timeStamp,
    'uuid': uuid,
  };

  return dbFirebase.collection("favorites").add(data);
}

Future<void> deleteFavorite(
  String kanjiCharacter,
  String uuid,
) async {
  final querySnapshot = await dbFirebase
      .collection("favorites")
      .where("uuid", isEqualTo: uuid)
      .where("kanjiCharacter", isEqualTo: kanjiCharacter)
      .get();

  logger.d("Successfully completed");
  for (var docSnapshot in querySnapshot.docs) {
    await docSnapshot.reference.delete();
  }
}
