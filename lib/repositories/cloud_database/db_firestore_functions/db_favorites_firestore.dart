import 'package:kanji_for_n5_level_app/main.dart';

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

  return dbFirebase.collection("favorites").doc(kanjiCharacter).set(data);
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
