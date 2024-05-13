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
      isVisiblePassword: false,
      isVisibleConfirmPassword: false,
    );
  }

  void resetState() {
    state = PasswordChangeFlowData(
      statusProcessing: _isUpdating
          ? StatusProcessingPasswordChangeFlow.updating
          : StatusProcessingPasswordChangeFlow.form,
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

  var _isUpdating = false;

  void updatePassword(String currentPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setStatusProcessing(StatusProcessingPasswordChangeFlow.error);
      _isUpdating = false;
      return;
    }
    final email = user.email;
    if (email == null) {
      setStatusProcessing(StatusProcessingPasswordChangeFlow.error);
      _isUpdating = false;
      return;
    }

    setStatusProcessing(StatusProcessingPasswordChangeFlow.updating);
    _isUpdating = true;

    try {
      final authCredential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(authCredential);
      await user.updatePassword(state.password);
      setStatusProcessing(StatusProcessingPasswordChangeFlow.success);
      _isUpdating = false;
    } on FirebaseAuthException catch (e) {
      logger.e('error changing email with ${e.code} and message $e');
      setStatusProcessing(StatusProcessingPasswordChangeFlow.error);
      _isUpdating = false;

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

final passwordChangeFlowProvider =
    NotifierProvider<PasswordChangeFlowProvider, PasswordChangeFlowData>(
        PasswordChangeFlowProvider.new);

enum StatusProcessingPasswordChangeFlow {
  updating,
  error,
  noMatchPasswords,
  success,
  form,
  showPasswordInput,
}
