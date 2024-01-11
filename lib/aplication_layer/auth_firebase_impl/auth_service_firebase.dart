import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_contract/auth_service_contract.dart';
import 'package:kanji_for_n5_level_app/config_files/network_config.dart';
import 'package:kanji_for_n5_level_app/main.dart';

final storageRef = FirebaseStorage.instance.ref();
final streamAuth = FirebaseAuth.instance.userChanges();
final AuthService authService = FirebaseSignInUser();

class FirebaseSignInUser implements AuthService {
  @override
  Future<StatusLogingRequest> singInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      logger.d(password);
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(
            const Duration(seconds: timeOutValue),
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

  @override
  Future<StatusResetPasswordRequest> sendPasswordResetEmail(
      {required email}) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .timeout(const Duration(seconds: timeOutValue));

      return StatusResetPasswordRequest.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return StatusResetPasswordRequest.emailInvalid;
      } else if (e.code == 'user-not-found') {
        return StatusResetPasswordRequest.userNotFound;
      }
      return StatusResetPasswordRequest.error;
    } on TimeoutException {
      return StatusResetPasswordRequest.error;
    }
  }

  @override
  Future<DeleteUserStatus> deleteUser({required String password}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return DeleteUserStatus.error;
    }

    try {
      final email = user.email;
      if (email != null) {
        final authCredential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(authCredential);
        await user.updateEmail(email);
      }
      await user.delete();
      return DeleteUserStatus.success;
    } catch (e) {
      logger.e(e);
      return DeleteUserStatus.error;
    }
  }
}
