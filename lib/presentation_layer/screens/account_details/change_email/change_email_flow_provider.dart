import 'package:firebase_auth/firebase_auth.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/config_files/constants.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_email_flow_provider.g.dart';

@Riverpod(keepAlive: false)
class EmailChange extends _$EmailChange {
  @override
  EmailChangeFlowData build() {
    return EmailChangeFlowData(
      statusProcessing: StatusProcessingEmailChangeFlow.form,
      email: '',
      confirmEmail: '',
    );
  }

  void updateState({
    String? email,
    String? confirmEmail,
    StatusProcessingEmailChangeFlow? statusProcessing,
  }) {
    state = EmailChangeFlowData(
      statusProcessing: statusProcessing ?? state.statusProcessing,
      email: email ?? state.email,
      confirmEmail: confirmEmail ?? state.confirmEmail,
    );
  }

  bool isUpdating() {
    return state.statusProcessing == StatusProcessingEmailChangeFlow.updating;
  }

  void updateEmail(String currentPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        updateState(statusProcessing: StatusProcessingEmailChangeFlow.error);
        return;
      }
      final email = user.email;
      if (email == null) {
        updateState(statusProcessing: StatusProcessingEmailChangeFlow.error);
        return;
      }

      updateState(statusProcessing: StatusProcessingEmailChangeFlow.updating);

      final authCredential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user
          .reauthenticateWithCredential(authCredential)
          .timeout(const Duration(seconds: timeOutValue));
      await user
          .verifyBeforeUpdateEmail(state.email)
          .timeout(const Duration(seconds: timeOutValue));

      await ref
          .read(cloudDBServiceProvider)
          .updateUserData(ref.read(authServiceProvider).userUuid ?? '', {
        "email": state.email,
      }).timeout(const Duration(seconds: timeOutValue));

      updateState(statusProcessing: StatusProcessingEmailChangeFlow.success);
    } catch (e) {
      logger.e(e);
      updateState(statusProcessing: StatusProcessingEmailChangeFlow.error);
    }
  }
}

class EmailChangeFlowData {
  final StatusProcessingEmailChangeFlow statusProcessing;
  final String email;
  final String confirmEmail;

  EmailChangeFlowData({
    required this.statusProcessing,
    required this.email,
    required this.confirmEmail,
  });
}

enum StatusProcessingEmailChangeFlow {
  updating,
  error,
  noMatchEmails,
  success,
  form,
  showEmailInput,
}
