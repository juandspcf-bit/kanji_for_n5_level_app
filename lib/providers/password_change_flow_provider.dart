import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';

class PasswordChangeFlowProvider extends Notifier<PasswordChangeFlowData> {
  @override
  PasswordChangeFlowData build() {
    return PasswordChangeFlowData(
      statusProcessing: StatusProcessingPasswordChangeFlow.form,
      password: '',
      confirmPassword: '',
    );
  }

  void resetState() {
    state = PasswordChangeFlowData(
      statusProcessing: StatusProcessingPasswordChangeFlow.form,
      password: '',
      confirmPassword: '',
    );
  }

  void setPassword(String password) {
    state = PasswordChangeFlowData(
      statusProcessing: state.statusProcessing,
      password: password,
      confirmPassword: state.confirmPassword,
    );
  }

  void setConfirmPassword(String confirmPassword) {
    state = PasswordChangeFlowData(
      statusProcessing: state.statusProcessing,
      password: state.password,
      confirmPassword: confirmPassword,
    );
  }

  void setStatusProcessing(StatusProcessingPasswordChangeFlow status) {
    state = PasswordChangeFlowData(
      statusProcessing: status,
      password: state.password,
      confirmPassword: state.confirmPassword,
    );
  }

  void updateUserData(String currentPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setStatusProcessing(StatusProcessingPasswordChangeFlow.error);
      return;
    }
    final email = user.email;
    if (email == null) {
      setStatusProcessing(StatusProcessingPasswordChangeFlow.error);
      return;
    }

    setStatusProcessing(StatusProcessingPasswordChangeFlow.updating);

    try {
      final authCredential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(authCredential);
      await user.updatePassword(state.password);
      setStatusProcessing(StatusProcessingPasswordChangeFlow.succsess);
    } on FirebaseAuthException catch (e) {
      logger.e('error changing email with ${e.code} and message $e');
      setStatusProcessing(StatusProcessingPasswordChangeFlow.error);

      return;
    }
  }
}

class PasswordChangeFlowData {
  final StatusProcessingPasswordChangeFlow statusProcessing;
  final String password;
  final String confirmPassword;

  PasswordChangeFlowData({
    required this.statusProcessing,
    required this.password,
    required this.confirmPassword,
  });
}

final passwordChangeFlowProvider =
    NotifierProvider<PasswordChangeFlowProvider, PasswordChangeFlowData>(
        PasswordChangeFlowProvider.new);

enum StatusProcessingPasswordChangeFlow {
  updating,
  error,
  noMatchPasswords,
  succsess,
  form,
  showPasswordInput,
}
