import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_email_flow_provider.g.dart';

@Riverpod(keepAlive: true)
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

  void updateEmail(String currentPassword) async {
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
    await user.reauthenticateWithCredential(authCredential);

    user
        .verifyBeforeUpdateEmail(state.email)
        .then((value) => updateState(
            statusProcessing: StatusProcessingEmailChangeFlow.success))
        .onError((error, stackTrace) => updateState(
            statusProcessing: StatusProcessingEmailChangeFlow.error));
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
