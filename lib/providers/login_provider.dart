import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';

class LoginProvider extends Notifier<LogingData> {
  @override
  LogingData build() {
    return LogingData(
      statusFetching: 1,
      email: '',
      password: '',
      credential: null,
    );
  }

  void setStatus(int status) async {
    state = LogingData(
      statusFetching: status,
      email: state.email,
      password: state.password,
      credential: state.credential,
    );
  }

  void setEmail(String email) {
    state = LogingData(
      statusFetching: state.statusFetching,
      email: email,
      password: state.password,
      credential: state.credential,
    );
  }

  void setPassword(String password) {
    state = LogingData(
        statusFetching: state.statusFetching,
        email: state.email,
        password: password,
        credential: state.credential);
  }

  Future<StatusLogingRequest> onValidate() async {
    setStatus(0);

    try {
      UserCredential credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: state.email, password: state.password);
      state = LogingData(
          statusFetching: state.statusFetching,
          email: state.email,
          password: state.password,
          credential: credential);
      return StatusLogingRequest.success;
    } on FirebaseAuthException catch (e) {
      logger.e(e.code);
      setStatus(1);
      if (e.code == 'INVALID_LOGIN_CREDENTIALS' ||
          e.code == 'invalid-credential') {
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

  void setUserCredentials(UserCredential userCredential) {
    state = LogingData(
      statusFetching: state.statusFetching,
      email: state.email,
      password: state.password,
      credential: userCredential,
    );
  }
}

final loginProvider =
    NotifierProvider<LoginProvider, LogingData>(LoginProvider.new);

class LogingData {
  final int statusFetching;
  final String email;
  final String password;
  final UserCredential? credential;
  LogingData({
    required this.statusFetching,
    required this.email,
    required this.password,
    required this.credential,
  });
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

enum StatusProcessingLoggingFlow {
  logging,
  error,
  succsess,
  form,
}
