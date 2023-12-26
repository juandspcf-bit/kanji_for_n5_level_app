import 'package:firebase_auth/firebase_auth.dart';
import 'package:kanji_for_n5_level_app/use_cases/reset_email_contract.dart';

final ResetEmail resetEmailService = ResetEmailFirebase();

class ResetEmailFirebase extends ResetEmail {
  @override
  Future<StatusResetPasswordRequest> sendPasswordResetEmail(
      {required email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      return StatusResetPasswordRequest.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return StatusResetPasswordRequest.emailInvalid;
      } else if (e.code == 'user-not-found') {
        return StatusResetPasswordRequest.userNotFound;
      }
      return StatusResetPasswordRequest.error;
    }
  }
}
