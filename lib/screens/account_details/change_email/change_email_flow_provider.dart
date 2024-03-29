import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailChange extends Notifier<EmailChangeFlowData> {
  @override
  EmailChangeFlowData build() {
    return EmailChangeFlowData(
      statusProcessing: StatusProcessingEmailChangeFlow.form,
      email: '',
      confirmEmail: '',
    );
  }

  void setEmail(String email) {
    state = EmailChangeFlowData(
      statusProcessing: state.statusProcessing,
      email: email,
      confirmEmail: state.confirmEmail,
    );
  }

  void setConfirmEmail(
    String confirmEmail,
  ) {
    state = EmailChangeFlowData(
      statusProcessing: state.statusProcessing,
      email: state.email,
      confirmEmail: confirmEmail,
    );
  }

  void setStatusProcessing(
    StatusProcessingEmailChangeFlow statusProcessing,
  ) {
    state = EmailChangeFlowData(
      statusProcessing: statusProcessing,
      email: state.email,
      confirmEmail: state.confirmEmail,
    );
  }

  void updateEmail(String currentPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setStatusProcessing(StatusProcessingEmailChangeFlow.error);
      return;
    }
    final email = user.email;
    if (email == null) {
      setStatusProcessing(StatusProcessingEmailChangeFlow.error);
      return;
    }

    setStatusProcessing(StatusProcessingEmailChangeFlow.updating);

    final authCredential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(authCredential);

    user.verifyBeforeUpdateEmail(state.email);
  }
}

final emailChangeProvider =
    NotifierProvider<EmailChange, EmailChangeFlowData>(EmailChange.new);

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
  succsess,
  form,
  showEmailInput,
}
