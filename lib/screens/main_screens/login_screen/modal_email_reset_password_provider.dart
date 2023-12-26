import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/use_cases/reset_email_contract.dart';

class ModalEmailResetProvider extends Notifier<ModalEmailResetData> {
  @override
  ModalEmailResetData build() {
    return const ModalEmailResetData(
        email: '', requestStatus: StatusSendingRequest.notStarted);
  }

  Future<StatusResetPasswordRequest> sendPasswordResetEmail() async {
    setRequestStatus(StatusSendingRequest.sending);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: state.email);
      setRequestStatus(StatusSendingRequest.finished);
      return StatusResetPasswordRequest.success;
    } on FirebaseAuthException catch (e) {
      setRequestStatus(StatusSendingRequest.finished);
      if (e.code == 'invalid-email') {
        return StatusResetPasswordRequest.emailInvalid;
      } else if (e.code == 'user-not-found') {
        return StatusResetPasswordRequest.userNotFound;
      }
      return StatusResetPasswordRequest.error;
    }
  }

  void setEmail(String email) {
    state =
        ModalEmailResetData(email: email, requestStatus: state.requestStatus);
  }

  void setRequestStatus(StatusSendingRequest requestStatus) {
    state =
        ModalEmailResetData(email: state.email, requestStatus: requestStatus);
  }

  void resetData() {
    state = const ModalEmailResetData(
        email: '', requestStatus: StatusSendingRequest.notStarted);
  }
}

final modalEmailResetProvider =
    NotifierProvider<ModalEmailResetProvider, ModalEmailResetData>(
        ModalEmailResetProvider.new);

class ModalEmailResetData {
  final String email;
  final StatusSendingRequest requestStatus;

  const ModalEmailResetData({required this.email, required this.requestStatus});
}

enum StatusSendingRequest {
  notStarted,
  sending,
  finished,
}
