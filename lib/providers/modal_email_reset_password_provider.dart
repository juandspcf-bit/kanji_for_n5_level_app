import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ModalEmailResetProvider extends Notifier<ModalEmailResetData> {
  @override
  ModalEmailResetData build() {
    return const ModalEmailResetData(email: '');
  }

  Future<StatusResetPasswordRequest> onValidate() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: state.email);
      return StatusResetPasswordRequest.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'auth/invalid-email') {
        return StatusResetPasswordRequest.emailInvalid;
      } else if (e.code == 'auth/user-not-found') {
        return StatusResetPasswordRequest.userNotFound;
      }
      return StatusResetPasswordRequest.error;
    }
  }

  void setEmail(String email) {
    state = ModalEmailResetData(email: email);
  }
}

final modalEmailResetProvider =
    NotifierProvider<ModalEmailResetProvider, ModalEmailResetData>(
        ModalEmailResetProvider.new);

class ModalEmailResetData {
  final String email;

  const ModalEmailResetData({required this.email});
}

enum StatusResetPasswordRequest {
  success('Success'),
  invalidCredentials('Invalid credentials'),
  emailInvalid('The email is invalid'),
  userNotFound('There is no corresponding user for this email'),
  error('The was an error in the server');

  const StatusResetPasswordRequest(
    this.message,
  );

  final String message;

  @override
  String toString() => message;
}
