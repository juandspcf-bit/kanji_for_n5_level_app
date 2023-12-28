import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_firebase_impl/sing_in_user_firebase.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/main_screen_provider.dart';

class SingUpProvider extends Notifier<SingUpData> {
  @override
  SingUpData build() {
    return SingUpData(
      statusFetching: StatusProcessingSignUpFlow.form,
      pathProfileUser: '',
      fullName: '',
      emailAddress: '',
      password: '',
      confirmPassword: '',
    );
  }

  void setStatus(StatusProcessingSignUpFlow status) async {
    state = SingUpData(
      statusFetching: status,
      pathProfileUser: state.pathProfileUser,
      fullName: state.fullName,
      emailAddress: state.emailAddress,
      password: state.password,
      confirmPassword: state.confirmPassword,
    );
  }

  void resetStatus() {
    state = SingUpData(
      statusFetching: StatusProcessingSignUpFlow.form,
      pathProfileUser: '',
      fullName: '',
      emailAddress: '',
      password: '',
      confirmPassword: '',
    );
  }

  void setFullName(String fullName) {
    state = SingUpData(
      statusFetching: state.statusFetching,
      pathProfileUser: state.pathProfileUser,
      fullName: fullName,
      emailAddress: state.emailAddress,
      password: state.password,
      confirmPassword: state.confirmPassword,
    );
  }

  void setEmail(String email) {
    state = SingUpData(
      statusFetching: state.statusFetching,
      pathProfileUser: state.pathProfileUser,
      fullName: state.fullName,
      emailAddress: email,
      password: state.password,
      confirmPassword: state.confirmPassword,
    );
  }

  void setPassword(String password) {
    state = SingUpData(
      statusFetching: state.statusFetching,
      pathProfileUser: state.pathProfileUser,
      fullName: state.fullName,
      emailAddress: state.emailAddress,
      password: password,
      confirmPassword: state.confirmPassword,
    );
  }

  void setConfirmPassword(String confirmPassword) {
    state = SingUpData(
      statusFetching: state.statusFetching,
      pathProfileUser: state.pathProfileUser,
      fullName: state.fullName,
      emailAddress: state.emailAddress,
      password: state.password,
      confirmPassword: confirmPassword,
    );
  }

  void setPathProfileUser(String pathProfileUser) {
    state = SingUpData(
      statusFetching: state.statusFetching,
      pathProfileUser: pathProfileUser,
      fullName: state.fullName,
      emailAddress: state.emailAddress,
      password: state.password,
      confirmPassword: state.confirmPassword,
    );
  }

  Future<void> createUser(
    String pathProfileUser,
    String fullName,
    String emailAddress,
    String password1,
    String password2,
  ) async {
    setStatus(StatusProcessingSignUpFlow.signUpProccessing);

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password1,
      );

      final user = credential.user;

      if (user == null) return;

      await user.updateDisplayName(fullName);
      await user.updateEmail(emailAddress);

      if (pathProfileUser.isNotEmpty) {
        try {
          final userPhoto = storageRef.child("userImages/${user.uid}.jpg");

          await userPhoto.putFile(File(pathProfileUser));

          final link = await userPhoto.getDownloadURL();

          ref.read(mainScreenProvider.notifier).setAvatarLink(link);

          logger.d('photo stored succefully');
        } catch (e) {
          logger.e('error');
          logger.e(e);
        }
      }
    } on FirebaseAuthException catch (e) {
      setStatus(StatusProcessingSignUpFlow.error);
      if (e.code == 'weak-password') {
        logger.d('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        logger.d('The account already exists for that email.');
      }

      throw const ErrorDataBaseException(
          message: 'Error with creation of account');
    } catch (e) {
      setStatus(StatusProcessingSignUpFlow.error);
      logger.e(e);
      throw const ErrorDataBaseException(
          message: 'Error with creation of account');
    } finally {}
  }
}

final singUpProvider =
    NotifierProvider<SingUpProvider, SingUpData>(SingUpProvider.new);

class SingUpData {
  final StatusProcessingSignUpFlow statusFetching;
  final String pathProfileUser;
  final String fullName;
  final String emailAddress;
  final String password;
  final String confirmPassword;

  SingUpData({
    required this.statusFetching,
    required this.pathProfileUser,
    required this.fullName,
    required this.emailAddress,
    required this.password,
    required this.confirmPassword,
  });
}

class ErrorDataBaseException implements Exception {
  final String message;

  const ErrorDataBaseException({required this.message});
}

enum StatusProcessingSignUpFlow {
  signUpProccessing,
  error,
  succsess,
  form,
}

enum StatusSignUpgRequest {
  notStarted('Not started'),
  success('Success'),
  invalidEmail('Your email address is not valid'),
  emailAlreadyInUse(
      'there already exists an account with the given email address'),
  operationNotAllowed('An unexpected error has happened'),
  weakPassword('Your password is weak'),
  error('An unexpected error has happened');

  const StatusSignUpgRequest(
    this.message,
  );

  final String message;

  @override
  String toString() => message;
}
