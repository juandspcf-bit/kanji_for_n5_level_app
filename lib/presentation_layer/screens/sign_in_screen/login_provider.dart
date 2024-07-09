import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/auth_service/auth_service_contract.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';

class LoginProvider extends Notifier<LoginData> {
  @override
  LoginData build() {
    return LoginData(
      statusLoginFlow: StatusProcessingLoggingFlow.form,
      statusLoginRequest: StatusLoginRequest.notStarted,
      statusResetEmail: StatusResetEmail.notStarted,
      email: '',
      password: '',
      isVisiblePassword: false,
    );
  }

  void resetData() {
    state = LoginData(
      statusLoginRequest: StatusLoginRequest.notStarted,
      statusLoginFlow: StatusProcessingLoggingFlow.form,
      statusResetEmail: StatusResetEmail.notStarted,
      email: '',
      password: '',
      isVisiblePassword: false,
    );
  }

  void setStatusLoginRequest(StatusLoginRequest status) {
    state = LoginData(
      statusLoginRequest: status,
      statusLoginFlow: state.statusLoginFlow,
      statusResetEmail: state.statusResetEmail,
      email: state.email,
      password: state.password,
      isVisiblePassword: state.isVisiblePassword,
    );
  }

  void setStatusLoggingFlow(StatusProcessingLoggingFlow status) async {
    state = LoginData(
      statusLoginRequest: state.statusLoginRequest,
      statusLoginFlow: status,
      statusResetEmail: state.statusResetEmail,
      email: state.email,
      password: state.password,
      isVisiblePassword: state.isVisiblePassword,
    );
  }

  void setStatusResetEmail(StatusResetEmail status) async {
    state = LoginData(
      statusLoginRequest: state.statusLoginRequest,
      statusLoginFlow: state.statusLoginFlow,
      statusResetEmail: status,
      email: state.email,
      password: state.password,
      isVisiblePassword: state.isVisiblePassword,
    );
  }

  void setEmail(String email) {
    state = LoginData(
      statusLoginRequest: state.statusLoginRequest,
      statusLoginFlow: state.statusLoginFlow,
      statusResetEmail: state.statusResetEmail,
      email: email,
      password: state.password,
      isVisiblePassword: state.isVisiblePassword,
    );
  }

  void setPassword(String password) {
    state = LoginData(
      statusLoginRequest: state.statusLoginRequest,
      statusLoginFlow: state.statusLoginFlow,
      statusResetEmail: state.statusResetEmail,
      email: state.email,
      password: password,
      isVisiblePassword: state.isVisiblePassword,
    );
  }

  void toggleVisibility() {
    state = LoginData(
      statusLoginRequest: state.statusLoginRequest,
      statusLoginFlow: state.statusLoginFlow,
      statusResetEmail: state.statusResetEmail,
      email: state.email,
      password: state.password,
      isVisiblePassword: !state.isVisiblePassword,
    );
  }

  Future<StatusLoginRequest> toLogin() async {
    setStatusLoggingFlow(StatusProcessingLoggingFlow.logging);

    final result = await ref
        .read(authServiceProvider)
        .singInWithEmailAndPassword(
            email: state.email, password: state.password);
    logger.d(result);
    if (result != StatusLoginRequest.success) {
      setStatusLoggingFlow(StatusProcessingLoggingFlow.form);
    }
    setStatusLoginRequest(result);
    return result;
  }
}

final loginProvider =
    NotifierProvider<LoginProvider, LoginData>(LoginProvider.new);

class LoginData {
  final StatusProcessingLoggingFlow statusLoginFlow;
  final StatusLoginRequest statusLoginRequest;
  final StatusResetEmail statusResetEmail;
  final String email;
  final String password;
  final bool isVisiblePassword;

  LoginData({
    required this.statusLoginFlow,
    required this.statusLoginRequest,
    required this.statusResetEmail,
    required this.email,
    required this.password,
    required this.isVisiblePassword,
  });
}

enum StatusProcessingLoggingFlow {
  logging,
  error,
  success,
  form,
}

enum StatusResetEmail {
  notStarted('no request started'),
  success('The reset email link was successfully sent'),
  error('There is no corresponding user for this email');

  const StatusResetEmail(
    this.message,
  );

  final String message;

  @override
  String toString() => message;
}
