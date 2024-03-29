import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_contract/auth_service_contract.dart';
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

    final result = await authService.singInWithEmailAndPassword(
        email: state.email, password: state.password);
    if (result == StatusLogingRequest.success) {
    } else {
      setStatusLoggingFlow(StatusProcessingLoggingFlow.form);
    }
    setStatusLogingRequest(result);
    return result;
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

enum StatusProcessingLoggingFlow {
  logging,
  error,
  succsess,
  form,
}

enum StatusResetEmail {
  notStarted('no request started'),
  success('The reset email link was succefully sent'),
  error('There is no corresponding user for this email');

  const StatusResetEmail(
    this.message,
  );

  final String message;

  @override
  String toString() => message;
}
