import 'package:firebase_auth/firebase_auth.dart';
import 'package:kanji_for_n5_level_app/config_files/constants.dart';
import 'package:kanji_for_n5_level_app/main.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'password_change_flow_provider.g.dart';

@Riverpod(keepAlive: false)
class PasswordChangeFlow extends _$PasswordChangeFlow {
  @override
  PasswordChangeFlowData build() {
    return PasswordChangeFlowData(
      statusProcessing: StatusProcessingPasswordChangeFlow.form,
      password: '',
      confirmPassword: '',
      isVisiblePassword: false,
      isVisibleConfirmPassword: false,
    );
  }

  void setPassword(String password) {
    state = PasswordChangeFlowData(
      statusProcessing: state.statusProcessing,
      password: password,
      confirmPassword: state.confirmPassword,
      isVisiblePassword: state.isVisiblePassword,
      isVisibleConfirmPassword: state.isVisibleConfirmPassword,
    );
  }

  void setConfirmPassword(String confirmPassword) {
    state = PasswordChangeFlowData(
      statusProcessing: state.statusProcessing,
      password: state.password,
      confirmPassword: confirmPassword,
      isVisiblePassword: state.isVisiblePassword,
      isVisibleConfirmPassword: state.isVisibleConfirmPassword,
    );
  }

  void setStatusProcessing(StatusProcessingPasswordChangeFlow status) {
    state = PasswordChangeFlowData(
      statusProcessing: status,
      password: state.password,
      confirmPassword: state.confirmPassword,
      isVisiblePassword: state.isVisiblePassword,
      isVisibleConfirmPassword: state.isVisibleConfirmPassword,
    );
  }

  void updatePassword(String currentPassword) async {
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
      await user
          .reauthenticateWithCredential(authCredential)
          .timeout(const Duration(seconds: timeOutValue));
      await user
          .updatePassword(state.password)
          .timeout(const Duration(seconds: timeOutValue));
      setStatusProcessing(StatusProcessingPasswordChangeFlow.success);
    } on FirebaseAuthException catch (e) {
      logger.e('error changing email with ${e.code} and message $e');
      setStatusProcessing(StatusProcessingPasswordChangeFlow.error);

      return;
    }
  }

  void toggleVisibilityPassword() {
    state = PasswordChangeFlowData(
      statusProcessing: state.statusProcessing,
      password: state.password,
      confirmPassword: state.confirmPassword,
      isVisiblePassword: !state.isVisiblePassword,
      isVisibleConfirmPassword: state.isVisibleConfirmPassword,
    );
  }

  void toggleConfirmVisibilityPassword() {
    state = PasswordChangeFlowData(
      statusProcessing: state.statusProcessing,
      password: state.password,
      confirmPassword: state.confirmPassword,
      isVisiblePassword: state.isVisiblePassword,
      isVisibleConfirmPassword: !state.isVisibleConfirmPassword,
    );
  }
}

class PasswordChangeFlowData {
  final StatusProcessingPasswordChangeFlow statusProcessing;
  final String password;
  final String confirmPassword;
  final bool isVisiblePassword;
  final bool isVisibleConfirmPassword;

  PasswordChangeFlowData({
    required this.statusProcessing,
    required this.password,
    required this.confirmPassword,
    required this.isVisiblePassword,
    required this.isVisibleConfirmPassword,
  });
}

enum StatusProcessingPasswordChangeFlow {
  updating,
  error,
  noMatchPasswords,
  success,
  form,
  showPasswordInput,
}
