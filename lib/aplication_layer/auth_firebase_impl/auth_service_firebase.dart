import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_contract/auth_service_contract.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_contract/delete_user_exception.dart';
import 'package:kanji_for_n5_level_app/config_files/network_config.dart';
import 'package:kanji_for_n5_level_app/main.dart';

final streamAuth = FirebaseAuth.instance.userChanges();

class FirebaseAuthService implements AuthService {
  @override
  String? userUuid = '';

  @override
  void setLoggedUser() {
    userUuid = FirebaseAuth.instance.currentUser?.uid;
  }

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
  Future<(DeleteUserStatus, String)> deleteUser({
    required String password,
    required String uuid,
  }) async {
    if (uuid == '') {
      return (DeleteUserStatus.error, '');
    }
    final user = FirebaseAuth.instance.currentUser;

    final querySnapshot =
        await dbFirebase.collection("user_data").doc(uuid).get();

    final queryData = querySnapshot.data();
    try {
      if (querySnapshot.exists && queryData != null && user != null) {
        final email = queryData['email'] as String;
        final authCredential = EmailAuthProvider.credential(
          email: email,
          password: password,
        );
        await user.reauthenticateWithCredential(authCredential);
        await user.delete();
        return (DeleteUserStatus.success, uuid);
      } else {
        return (DeleteUserStatus.error, uuid);
      }
    } on FirebaseAuthException catch (e) {
      throw DeleteUserException(
          message: e.code,
          deleteErrorUserCode: DeleteErrorUserCode.deleteErrorAuth);
    } on FirebaseException catch (e) {
      throw DeleteUserException(
          message: e.code,
          deleteErrorUserCode: DeleteErrorUserCode.deleteErrorAuth);
    } catch (e) {
      throw DeleteUserException(
          message: 'Error from the server: $e',
          deleteErrorUserCode: DeleteErrorUserCode.deleteErrorAuth);
    }
  }

  @override
  Future<void> singOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  @override
  Future<String> singUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password,
          )
          .timeout(const Duration(seconds: 40));

      final user = credential.user;

      if (user == null) return '';

      return user.uid;
    } catch (e) {
      rethrow;
    }
  }
}
