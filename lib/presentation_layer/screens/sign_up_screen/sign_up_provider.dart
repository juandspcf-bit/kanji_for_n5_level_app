import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/auth_service/auth_service_contract.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';

import 'package:image/image.dart' as image_lib;

class SingUpProvider extends Notifier<SingUpData> {
  @override
  SingUpData build() {
    return SingUpData(
      statusFlow: StatusProcessingSignUpFlow.form,
      statusCreatingUser: StatusCreatingUser.form,
      pathProfileUser: '',
      firstName: '',
      lastName: '',
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
      firstName: state.firstName,
      lastName: state.lastName,
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
      firstName: state.firstName,
      lastName: state.lastName,
      emailAddress: state.emailAddress,
      password: state.password,
      confirmPassword: state.confirmPassword,
    );
  }

  void resetStatus() {
    state = SingUpData(
      statusFlow: StatusProcessingSignUpFlow.form,
      statusCreatingUser: StatusCreatingUser.form,
      pathProfileUser: '',
      firstName: '',
      lastName: '',
      emailAddress: '',
      password: '',
      confirmPassword: '',
    );
  }

  void setFirstName(
    String firstName,
  ) {
    state = SingUpData(
      statusFlow: state.statusFlow,
      statusCreatingUser: state.statusCreatingUser,
      pathProfileUser: state.pathProfileUser,
      firstName: firstName,
      lastName: state.lastName,
      emailAddress: state.emailAddress,
      password: state.password,
      confirmPassword: state.confirmPassword,
    );
  }

  void setLatName(
    String lastName,
  ) {
    state = SingUpData(
      statusFlow: state.statusFlow,
      statusCreatingUser: state.statusCreatingUser,
      pathProfileUser: state.pathProfileUser,
      firstName: state.firstName,
      lastName: lastName,
      emailAddress: state.emailAddress,
      password: state.password,
      confirmPassword: state.confirmPassword,
    );
  }

  void setEmail(
    String email,
  ) {
    state = SingUpData(
      statusFlow: state.statusFlow,
      statusCreatingUser: state.statusCreatingUser,
      pathProfileUser: state.pathProfileUser,
      firstName: state.firstName,
      lastName: state.lastName,
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
      firstName: state.firstName,
      lastName: state.lastName,
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
      firstName: state.firstName,
      lastName: state.lastName,
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
      firstName: state.firstName,
      lastName: state.lastName,
      emailAddress: state.emailAddress,
      password: state.password,
      confirmPassword: state.confirmPassword,
    );
  }

  Future<void> toCreateUser() async {
    if (state.password != state.confirmPassword) {
      setStatusCreatingUser(StatusCreatingUser.passwordMisMatch);
      return;
    }

    setStatusFlow(StatusProcessingSignUpFlow.signUpProcessing);

    try {
      final userUuid =
          await ref.read(authServiceProvider).singUpWithEmailAndPassword(
                email: state.emailAddress,
                password: state.password,
              );

      if (userUuid == '') return;

      final userData = {
        'birthday': '',
        'email': state.emailAddress,
        'firstName': state.firstName,
        'lastName': state.lastName,
        'uuid': userUuid,
      };
      await ref.read(cloudDBServiceProvider).addUserData(userData);
      await ref.read(cloudDBServiceProvider).createQuizScoreMap(userUuid);

      if (state.pathProfileUser.isNotEmpty) {
        await Isolate.run(() {
          final image = image_lib
              .decodeImage(File(state.pathProfileUser).readAsBytesSync());

          if (image != null) {
            final width = image.width;
            final height = image.height;

            final aspectRatio = height / width;

            final thumbnail = image_lib.copyResize(image,
                width: 1024, height: (1024 * aspectRatio).toInt());

            final file = File(state.pathProfileUser);
            file.writeAsBytesSync(image_lib.encodeJpg(thumbnail, quality: 50));
          }
        });

        try {
          final link = await ref
              .read(storageServiceProvider)
              .storeFile(state.pathProfileUser, userUuid);

          ref.read(mainScreenProvider.notifier).setAvatarLink(link);

          logger.d('photo stored successfully');
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
      } else {}
    } on TimeoutException {
      setStatusCreatingUser(
          StatusCreatingUser.error); // Prints "throws" after 2 seconds.
    } catch (e) {
      setStatusCreatingUser(StatusCreatingUser.error);
    }
  }
}

final singUpProvider =
    NotifierProvider<SingUpProvider, SingUpData>(SingUpProvider.new);

class SingUpData {
  final StatusProcessingSignUpFlow statusFlow;
  final StatusCreatingUser statusCreatingUser;
  final String pathProfileUser;
  final String firstName;
  final String lastName;
  final String emailAddress;
  final String password;
  final String confirmPassword;

  SingUpData({
    required this.statusFlow,
    required this.statusCreatingUser,
    required this.pathProfileUser,
    required this.firstName,
    required this.lastName,
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
  signUpProcessing,
  error,
  success,
  form,
}
