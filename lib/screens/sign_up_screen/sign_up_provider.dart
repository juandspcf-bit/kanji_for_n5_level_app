import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_firebase_impl/auth_service_firebase.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content_provider.dart';

class SingUpProvider extends Notifier<SingUpData> {
  @override
  SingUpData build() {
    return SingUpData(
      statusFlow: StatusProcessingSignUpFlow.form,
      statusCreatingUser: StatusCreatingUser.notStarted,
      pathProfileUser: '',
      fullName: '',
      emailAddress: '',
      password: '',
      confirmPassword: '',
    );
  }

  void setStatusFlow(StatusProcessingSignUpFlow status) async {
    state = SingUpData(
      statusFlow: status,
      statusCreatingUser: state.statusCreatingUser,
      pathProfileUser: state.pathProfileUser,
      fullName: state.fullName,
      emailAddress: state.emailAddress,
      password: state.password,
      confirmPassword: state.confirmPassword,
    );
  }

  void setStatusCreatingUser(StatusCreatingUser statusCreatingUser) async {
    state = SingUpData(
      statusFlow: state.statusFlow,
      statusCreatingUser: statusCreatingUser,
      pathProfileUser: state.pathProfileUser,
      fullName: state.fullName,
      emailAddress: state.emailAddress,
      password: state.password,
      confirmPassword: state.confirmPassword,
    );
  }

  void resetStatus() {
    state = SingUpData(
      statusFlow: StatusProcessingSignUpFlow.form,
      statusCreatingUser: StatusCreatingUser.notStarted,
      pathProfileUser: '',
      fullName: '',
      emailAddress: '',
      password: '',
      confirmPassword: '',
    );
  }

  void setFullName(String fullName) {
    state = SingUpData(
      statusFlow: state.statusFlow,
      statusCreatingUser: state.statusCreatingUser,
      pathProfileUser: state.pathProfileUser,
      fullName: fullName,
      emailAddress: state.emailAddress,
      password: state.password,
      confirmPassword: state.confirmPassword,
    );
  }

  void setEmail(String email) {
    state = SingUpData(
      statusFlow: state.statusFlow,
      statusCreatingUser: state.statusCreatingUser,
      pathProfileUser: state.pathProfileUser,
      fullName: state.fullName,
      emailAddress: email,
      password: state.password,
      confirmPassword: state.confirmPassword,
    );
  }

  void setPassword(String password) {
    state = SingUpData(
      statusFlow: state.statusFlow,
      statusCreatingUser: state.statusCreatingUser,
      pathProfileUser: state.pathProfileUser,
      fullName: state.fullName,
      emailAddress: state.emailAddress,
      password: password,
      confirmPassword: state.confirmPassword,
    );
  }

  void setConfirmPassword(String confirmPassword) {
    state = SingUpData(
      statusFlow: state.statusFlow,
      statusCreatingUser: state.statusCreatingUser,
      pathProfileUser: state.pathProfileUser,
      fullName: state.fullName,
      emailAddress: state.emailAddress,
      password: state.password,
      confirmPassword: confirmPassword,
    );
  }

  void setPathProfileUser(String pathProfileUser) {
    state = SingUpData(
      statusFlow: state.statusFlow,
      statusCreatingUser: state.statusCreatingUser,
      pathProfileUser: pathProfileUser,
      fullName: state.fullName,
      emailAddress: state.emailAddress,
      password: state.password,
      confirmPassword: state.confirmPassword,
    );
  }

  Future<void> toCreateUser(BuildContext context) async {
    if (state.password != state.confirmPassword) {
      setStatusCreatingUser(StatusCreatingUser.passworfMisMatch);
      return;
    }

    setStatusFlow(StatusProcessingSignUpFlow.signUpProccessing);

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: state.emailAddress,
        password: state.password,
      );

      final user = credential.user;

      if (user == null) return;

      await user.updateDisplayName(state.fullName);
      await user.updateEmail(state.emailAddress);
      await cloudDBService.addUserData(state.emailAddress, user.uid);
      await cloudDBService.createQuizScoreMap(user.uid);

      if (state.pathProfileUser.isNotEmpty) {
        try {
          final userPhoto = storageRef.child("userImages/${user.uid}.jpg");

          await userPhoto.putFile(File(state.pathProfileUser));

          final link = await userPhoto.getDownloadURL();

          ref.read(mainScreenProvider.notifier).setAvatarLink(link);

          logger.d('photo stored succefully');
        } catch (e) {
          logger.e('error');
          logger.e(e);
        }
      }

      setStatusCreatingUser(StatusCreatingUser.success);
    } on FirebaseAuthException catch (e) {
      setStatusFlow(StatusProcessingSignUpFlow.form);
      if (e.code == 'weak-password') {
        setStatusCreatingUser(StatusCreatingUser.weakPassword);
      } else if (e.code == 'email-already-in-use') {
        setStatusCreatingUser(StatusCreatingUser.emailAlreadyInUse);
      } else {
        setStatusCreatingUser(StatusCreatingUser.error);
      }
    }
  }
}

final singUpProvider =
    NotifierProvider<SingUpProvider, SingUpData>(SingUpProvider.new);

class SingUpData {
  final StatusProcessingSignUpFlow statusFlow;
  final StatusCreatingUser statusCreatingUser;
  final String pathProfileUser;
  final String fullName;
  final String emailAddress;
  final String password;
  final String confirmPassword;

  SingUpData({
    required this.statusFlow,
    required this.statusCreatingUser,
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

enum StatusCreatingUser {
  notStarted('Not started'),
  success('Success'),
  passworfMisMatch('the passwords are not the same'),
  invalidEmail('Your email address is not valid'),
  emailAlreadyInUse(
      'there already exists an account with the given email address'),
  operationNotAllowed('An unexpected error has happened'),
  weakPassword('Your password is weak'),
  error('An unexpected error has happened');

  const StatusCreatingUser(
    this.message,
  );

  final String message;

  @override
  String toString() => message;
}
