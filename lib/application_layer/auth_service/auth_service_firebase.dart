import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kanji_for_n5_level_app/application_layer/auth_service/auth_service_contract.dart';
import 'package:kanji_for_n5_level_app/application_layer/auth_service/delete_user_exception.dart';
import 'package:kanji_for_n5_level_app/config_files/network_config.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/user.dart';

class FirebaseAuthService implements AuthService {
  Stream<User?> streamAuth = FirebaseAuth.instance.userChanges();

  final transformer = StreamTransformer<User?, String?>.fromHandlers(
    handleData: (value, sink) {
      if (value == null) sink.add(null);

      sink.add(
        value!.uid,
      );
    },
  );

  @override
  Stream<String?> authStream() {
    return streamAuth.transform(transformer);
  }

  @override
  String? userUuid = '';
  FirebaseAuth autServiceInstance = FirebaseAuth.instance;

  @override
  void setLoggedUser() {
    userUuid = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Future<StatusLoginRequest> singInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await autServiceInstance
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(
            const Duration(seconds: timeOutValue),
          );

      return StatusLoginRequest.success;
    } on FirebaseAuthException catch (e) {
      logger.e(e.code);
      if (e.code == 'INVALID_LOGIN_CREDENTIALS' ||
          e.code == 'invalid-credential') {
        return StatusLoginRequest.invalidCredentials;
      } else if (e.code == 'user-not-found') {
        return StatusLoginRequest.userNotFound;
      } else if (e.code == 'wrong-password') {
        return StatusLoginRequest.wrongPassword;
      } else if (e.code == 'too-many-requests') {
        return StatusLoginRequest.tooManyRequest;
      }

      return StatusLoginRequest.error;
    } on TimeoutException {
      return StatusLoginRequest.error;
    }
  }

  @override
  Future<StatusResetPasswordRequest> sendPasswordResetEmail(
      {required email}) async {
    try {
      await autServiceInstance
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
    required UserData userData,
  }) async {
    if (uuid == '') {
      return (DeleteUserStatus.error, '');
    }
    final user = autServiceInstance.currentUser;

    try {
      if (userData.uuid != "" && user != null) {
        final email = userData.email;
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
    return await autServiceInstance.signOut();
  }

  @override
  Future<String> singUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await autServiceInstance
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
