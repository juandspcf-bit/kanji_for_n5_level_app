import 'package:kanji_for_n5_level_app/main.dart';

Future<void> insertUserData(
  String email,
  String uuid,
) {
  final data = <String, Object>{
    'email': email,
    'uuid': uuid,
  };

  return dbFirebase.collection("user_data").doc(uuid).set(data);
}
