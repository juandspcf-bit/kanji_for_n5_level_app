import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/use_cases/sing_in_user_contract.dart';

final storageRef = FirebaseStorage.instance.ref();
final streamAuth = FirebaseAuth.instance.userChanges();
final SingInUser authService = FirebaseSingInUser();

class FirebaseSingInUser implements SingInUser {
  @override
  Future<StatusLogingRequest> singInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      logger.d(password);
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(
            const Duration(seconds: 15),
          );

      return StatusLogingRequest.success;
    } on FirebaseAuthException catch (e) {
      logger.e(e.code);
      if (e.code == 'INVALID_LOGIN_CREDENTIALS' ||
          e.code == 'invalid-credential') {
        return StatusLogingRequest.invalidCredentials;
      } else if (e.code == 'user-not-found') {
        return StatusLogingRequest.userNotFound;
      } else if (e.code == 'wrong-password') {
        return StatusLogingRequest.wrongPassword;
      } else if (e.code == 'too-many-requests') {
        return StatusLogingRequest.tooManyRequest;
      }

      return StatusLogingRequest.error;
    } on TimeoutException {
      return StatusLogingRequest.error;
    }
  }
}
