import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

class LoginProvider extends Notifier<LogingData> {
  @override
  LogingData build() {
    return LogingData(statusFetching: 1);
  }

  void setStatus(int status) async {
    state = LogingData(statusFetching: status);
  }

  Future<StatusLogingRequest> onValidate(
    String email,
    String password,
  ) async {
    setStatus(0);

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return StatusLogingRequest.success;
    } on FirebaseAuthException catch (e) {
      logger.e(e.code);
      setStatus(1);
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        return StatusLogingRequest.invalidCredentials;
        //throw const InvalidCredentialsException();
      } else if (e.code == 'user-not-found') {
        return StatusLogingRequest.userNotFound;
        //throw const UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        return StatusLogingRequest.wrongPassword;
        //throw const WrongPasswordException();
      } else if (e.code == 'too-many-requests') {}

      return StatusLogingRequest.error;
    }
  }
}

final loginProvider =
    NotifierProvider<LoginProvider, LogingData>(LoginProvider.new);

class LogingData {
  final int statusFetching;

  LogingData({required this.statusFetching});
}

enum StatusLogingRequest {
  success('Success'),
  invalidCredentials('Invalid credentials'),
  userNotFound('The user was not found'),
  wrongPassword('The password is wrong'),
  tooManyRequest('Too many failed login attempts'),
  error('The was an error in the server');

  const StatusLogingRequest(
    this.message,
  );

  final String message;

  @override
  String toString() => message;
}

/* class InvalidCredentialsException implements Exception {
  final String message;

  const InvalidCredentialsException([this.message = 'Invalid credentials']);
}

class UserNotFoundException implements Exception {
  final String message;

  const UserNotFoundException([this.message = 'The user was not found']);
}

class WrongPasswordException implements Exception {
  final String message;

  const WrongPasswordException([this.message = 'The password is wrong']);
}
 */