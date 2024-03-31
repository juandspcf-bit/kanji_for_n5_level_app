import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/user.dart';

Future<void> insertUserDataFirebase(
  String email,
  String uuid,
) {
  final data = <String, Object>{
    'email': email,
    'uuid': uuid,
  };

  return dbFirebase.collection("user_data").doc(uuid).set(data);
}

Future<UserData> readUserDataFirebase(String uuid) async {
  try {
    final querySnapshot = await dbFirebase
        .collection("user_data")
        .where("uuid", isEqualTo: uuid)
        .limit(1)
        .get();
    if (querySnapshot.size != 0) {
      final queyData = querySnapshot.docs.first.data();
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
    docRef.set(newData);
  } on FirebaseException {
    rethrow;
  } catch (e) {
    rethrow;
  }
}
