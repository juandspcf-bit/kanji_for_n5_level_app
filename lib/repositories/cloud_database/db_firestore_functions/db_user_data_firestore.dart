import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/user.dart';

Future<void> insertUserDataFirebase(Map<String, String> userData) {
  return dbFirebase.collection("user_data").doc(userData['uuid']).set(userData);
}

Future<UserData> readUserDataFirebase(String uuid) async {
  try {
    final querySnapshot =
        await dbFirebase.collection("user_data").doc(uuid).get();
    final queyData = querySnapshot.data();
    if (querySnapshot.exists && queyData != null) {
      final user = UserData(
        uuid: queyData['uuid'],
        birthday: queyData['birthday'],
        email: queyData['email'],
        firstName: queyData['firstName'],
        lastName: queyData['lastName'],
      );
      return Future(() => user);
    }
    return Future(() => UserData(
          uuid: '',
          firstName: '',
          lastName: '',
          email: '',
          birthday: '',
        ));
  } catch (e) {
    logger.e('error reading cloud db favorites');
    return Future(() => UserData(
          uuid: '',
          firstName: '',
          lastName: '',
          email: '',
          birthday: '',
        ));
  }
}

Future<void> updateUserDataFirebase(
  String uuid,
  Map<String, String> newData,
) async {
  try {
    final docRef = dbFirebase.collection("user_data").doc(uuid);
    docRef.update(newData);
  } on FirebaseException {
    rethrow;
  } catch (e) {
    rethrow;
  }
}
