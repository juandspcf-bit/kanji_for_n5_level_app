import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';

class LoginProvider extends Notifier<LogingData> {
  @override
  LogingData build() {
    return LogingData(
      statusFetching: StatusProcessingLoggingFlow.form,
      statusLogingRequest: StatusLogingRequest.notStarted,
      email: '',
      password: '',
      isVisiblePassword: false,
    );
  }

  void resetData() {
    state = LogingData(
      statusLogingRequest: StatusLogingRequest.notStarted,
      statusFetching: StatusProcessingLoggingFlow.form,
      email: '',
      password: '',
      isVisiblePassword: false,
    );
  }

  void setStatusLogingRequest(StatusLogingRequest status) {
    state = LogingData(
      statusLogingRequest: status,
      statusFetching: state.statusFetching,
      email: state.email,
      password: state.password,
      isVisiblePassword: state.isVisiblePassword,
    );
  }

  void setStatus(StatusProcessingLoggingFlow status) async {
    state = LogingData(
      statusLogingRequest: state.statusLogingRequest,
      statusFetching: status,
      email: state.email,
      password: state.password,
      isVisiblePassword: state.isVisiblePassword,
    );
  }

  void setEmail(String email) {
    state = LogingData(
      statusLogingRequest: state.statusLogingRequest,
      statusFetching: state.statusFetching,
      email: email,
      password: state.password,
      isVisiblePassword: state.isVisiblePassword,
    );
  }

  void setPassword(String password) {
    state = LogingData(
      statusLogingRequest: state.statusLogingRequest,
      statusFetching: state.statusFetching,
      email: state.email,
      password: password,
      isVisiblePassword: state.isVisiblePassword,
    );
  }

  void toggleVisibility() {
    state = LogingData(
      statusLogingRequest: state.statusLogingRequest,
      statusFetching: state.statusFetching,
      email: state.email,
      password: state.password,
      isVisiblePassword: !state.isVisiblePassword,
    );
  }

  Future<StatusLogingRequest> onValidate() async {
    setStatus(StatusProcessingLoggingFlow.logging);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: state.email, password: state.password);
      state = LogingData(
        statusLogingRequest: state.statusLogingRequest,
        statusFetching: state.statusFetching,
        email: state.email,
        password: state.password,
        isVisiblePassword: state.isVisiblePassword,
      );
      setStatusLogingRequest(StatusLogingRequest.success);
      return StatusLogingRequest.success;
    } on FirebaseAuthException catch (e) {
      logger.e(e.code);
      setStatus(StatusProcessingLoggingFlow.form);
      if (e.code == 'INVALID_LOGIN_CREDENTIALS' ||
          e.code == 'invalid-credential') {
        setStatusLogingRequest(StatusLogingRequest.invalidCredentials);
        return StatusLogingRequest.invalidCredentials;
        //throw const InvalidCredentialsException();
      } else if (e.code == 'user-not-found') {
        setStatusLogingRequest(StatusLogingRequest.userNotFound);
        return StatusLogingRequest.userNotFound;
        //throw const UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        setStatusLogingRequest(StatusLogingRequest.wrongPassword);
        return StatusLogingRequest.wrongPassword;
        //throw const WrongPasswordException();
      } else if (e.code == 'too-many-requests') {
        setStatusLogingRequest(StatusLogingRequest.tooManyRequest);
        return StatusLogingRequest.tooManyRequest;
      }

      return StatusLogingRequest.error;
    }
  }
}

final loginProvider =
    NotifierProvider<LoginProvider, LogingData>(LoginProvider.new);

class LogingData {
  final StatusProcessingLoggingFlow statusFetching;
  final StatusLogingRequest statusLogingRequest;
  final String email;
  final String password;
  final bool isVisiblePassword;

  LogingData({
    required this.statusFetching,
    required this.statusLogingRequest,
    required this.email,
    required this.password,
    required this.isVisiblePassword,
  });
}

enum StatusLogingRequest {
  notStarted('Not started'),
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
