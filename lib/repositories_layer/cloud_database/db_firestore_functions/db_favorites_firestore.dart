import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanji_for_n5_level_app/application_layer/auth_service/delete_user_exception.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/favorite.dart';

Future<List<Favorite>> loadFavoriteKanjis(
  String uuid,
  FirebaseFirestore dbFirebase,
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
          kanji: favoriteMap['kanjiCharacter'],
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
  FirebaseFirestore dbFirebase,
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
  FirebaseFirestore dbFirebase,
) async {
  final querySnapshot = await dbFirebase
      .collection("favorites")
      .where("uuid", isEqualTo: uuid)
      .where("kanjiCharacter", isEqualTo: kanjiCharacter)
      .get();

  for (var docSnapshot in querySnapshot.docs) {
    await docSnapshot.reference.delete();
  }
}

Future<void> deleteAllFavorites(
  String uuid,
  FirebaseFirestore dbFirebase,
) async {
  try {
    final querySnapshot = await dbFirebase
        .collection("favorites")
        .where("uuid", isEqualTo: uuid)
        .get();

    //logger.d("Successfully completed");
    for (var docSnapshot in querySnapshot.docs) {
      await docSnapshot.reference.delete();
    }
  } on FirebaseException catch (e) {
    throw DeleteUserException(
      message: e.code,
      deleteErrorUserCode: DeleteErrorUserCode.deleteErrorFavorites,
    );
  } catch (e) {
    throw DeleteUserException(
      message: 'error deleting user favorites from cloud db',
      deleteErrorUserCode: DeleteErrorUserCode.deleteErrorFavorites,
    );
  }
}
