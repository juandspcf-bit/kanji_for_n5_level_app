import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';

class LoginProvider extends Notifier<LogingData> {
  @override
  LogingData build() {
    return LogingData(
      statusLogingFlow: StatusProcessingLoggingFlow.form,
      statusLogingRequest: StatusLogingRequest.notStarted,
      statusResetEmail: StatusResetEmail.notStarted,
      email: '',
      password: '',
      isVisiblePassword: false,
    );
  }

  void resetData() {
    state = LogingData(
      statusLogingRequest: StatusLogingRequest.notStarted,
      statusLogingFlow: StatusProcessingLoggingFlow.form,
      statusResetEmail: StatusResetEmail.notStarted,
      email: '',
      password: '',
      isVisiblePassword: false,
    );
  }

  void setStatusLogingRequest(StatusLogingRequest status) {
    state = LogingData(
      statusLogingRequest: status,
      statusLogingFlow: state.statusLogingFlow,
      statusResetEmail: state.statusResetEmail,
      email: state.email,
      password: state.password,
      isVisiblePassword: state.isVisiblePassword,
    );
  }

  void setStatusLoggingFlow(StatusProcessingLoggingFlow status) async {
    state = LogingData(
      statusLogingRequest: state.statusLogingRequest,
      statusLogingFlow: status,
      statusResetEmail: state.statusResetEmail,
      email: state.email,
      password: state.password,
      isVisiblePassword: state.isVisiblePassword,
    );
  }

  void setStatusResetEmail(StatusResetEmail status) async {
    state = LogingData(
      statusLogingRequest: state.statusLogingRequest,
      statusLogingFlow: state.statusLogingFlow,
      statusResetEmail: status,
      email: state.email,
      password: state.password,
      isVisiblePassword: state.isVisiblePassword,
    );
  }

  void setEmail(String email) {
    state = LogingData(
      statusLogingRequest: state.statusLogingRequest,
      statusLogingFlow: state.statusLogingFlow,
      statusResetEmail: state.statusResetEmail,
      email: email,
      password: state.password,
      isVisiblePassword: state.isVisiblePassword,
    );
  }

  void setPassword(String password) {
    state = LogingData(
      statusLogingRequest: state.statusLogingRequest,
      statusLogingFlow: state.statusLogingFlow,
      statusResetEmail: state.statusResetEmail,
      email: state.email,
      password: password,
      isVisiblePassword: state.isVisiblePassword,
    );
  }

  void toggleVisibility() {
    state = LogingData(
      statusLogingRequest: state.statusLogingRequest,
      statusLogingFlow: state.statusLogingFlow,
      statusResetEmail: state.statusResetEmail,
      email: state.email,
      password: state.password,
      isVisiblePassword: !state.isVisiblePassword,
    );
  }

  Future<StatusLogingRequest> toLoging() async {
    setStatusLoggingFlow(StatusProcessingLoggingFlow.logging);

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: state.email, password: state.password)
          .timeout(
            const Duration(seconds: 15),
          );
      setStatusLogingRequest(StatusLogingRequest.success);
      return StatusLogingRequest.success;
    } on FirebaseAuthException catch (e) {
      logger.e(e.code);
      setStatusLoggingFlow(StatusProcessingLoggingFlow.form);
      if (e.code == 'INVALID_LOGIN_CREDENTIALS' ||
          e.code == 'invalid-credential') {
        setStatusLogingRequest(StatusLogingRequest.invalidCredentials);
        return StatusLogingRequest.invalidCredentials;
      } else if (e.code == 'user-not-found') {
        setStatusLogingRequest(StatusLogingRequest.userNotFound);
        return StatusLogingRequest.userNotFound;
      } else if (e.code == 'wrong-password') {
        setStatusLogingRequest(StatusLogingRequest.wrongPassword);
        return StatusLogingRequest.wrongPassword;
      } else if (e.code == 'too-many-requests') {
        setStatusLogingRequest(StatusLogingRequest.tooManyRequest);
        return StatusLogingRequest.tooManyRequest;
      }

      return StatusLogingRequest.error;
    } on TimeoutException {
      setStatusLogingRequest(StatusLogingRequest.error);
      return StatusLogingRequest.error;
    }
  }
}

final loginProvider =
    NotifierProvider<LoginProvider, LogingData>(LoginProvider.new);

class LogingData {
  final StatusProcessingLoggingFlow statusLogingFlow;
  final StatusLogingRequest statusLogingRequest;
  final StatusResetEmail statusResetEmail;
  final String email;
  final String password;
  final bool isVisiblePassword;

  LogingData({
    required this.statusLogingFlow,
    required this.statusLogingRequest,
    required this.statusResetEmail,
    required this.email,
    required this.password,
    required this.isVisiblePassword,
  });
}

enum StatusLogingRequest {
  notStarted('Not started'),
  success('Success'),
  invalidCredentials('Invalid credentials'),
  userNotFound('The email was not found'),
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

enum StatusResetEmail { notStarted, success, error }
