import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_contract/reset_email_contract.dart';
import 'package:kanji_for_n5_level_app/config_files/network_config.dart';

final ResetEmail resetEmailService = ResetEmailFirebase();

class ResetEmailFirebase extends ResetEmail {
  @override
  Future<StatusResetPasswordRequest> sendPasswordResetEmail(
      {required email}) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .timeout(const Duration(seconds: timeOutValue));

      return StatusResetPasswordRequest.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return StatusResetPasswordRequest.emailInvalid;
      } else if (e.code == 'user-not-found') {
        return StatusResetPasswordRequest.userNotFound;
      }
      return StatusResetPasswordRequest.error;
    } on TimeoutException {
      return StatusResetPasswordRequest.error;
    }
  }
}
