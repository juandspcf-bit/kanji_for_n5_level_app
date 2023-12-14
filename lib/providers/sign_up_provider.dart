import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';

class SingUpProvider extends Notifier<SingUpData> {
  @override
  SingUpData build() {
    return SingUpData(statusFetching: 1);
  }

  void setStatus(int status) async {
    state = SingUpData(statusFetching: status);
  }

  Future<void> createUser(
    String pathProfileUser,
    String fullName,
    String emailAddress,
    String password1,
    String password2,
  ) async {
    setStatus(0);

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password1,
      );

      final user = credential.user;

      if (user != null) {
        user.updateDisplayName(fullName);
        user.updateEmail(emailAddress);
      }

      if (pathProfileUser.isNotEmpty) {
        try {
          final userPhoto =
              storageRef.child("userImages/${credential.user!.uid}.jpg");

          await userPhoto.putFile(File(pathProfileUser));
        } catch (e) {
          logger.e('error');
          logger.e(e);
        }
      }
    } on FirebaseAuthException catch (e) {
      setStatus(1);
      if (e.code == 'weak-password') {
        logger.d('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        logger.d('The account already exists for that email.');
      }

      throw const ErrorDataBaseException(
          message: 'Error with creation of account');
    } catch (e) {
      setStatus(1);
      logger.e(e);
      throw const ErrorDataBaseException(
          message: 'Error with creation of account');
    } finally {}
  }
}

final singUpProvider =
    NotifierProvider<SingUpProvider, SingUpData>(SingUpProvider.new);

class SingUpData {
  final int statusFetching;

  SingUpData({required this.statusFetching});
}

class ErrorDataBaseException implements Exception {
  final String message;

  const ErrorDataBaseException({required this.message});
}
