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
  //.onError((e, _) => logger.d("Error writing document: $e"));
}
