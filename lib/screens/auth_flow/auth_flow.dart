import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_service/auth_service_firebase.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/screens/auth_flow/verify_email.dart';
import 'package:kanji_for_n5_level_app/screens/login_screen/login_screen.dart';

class AuthFlow extends ConsumerWidget {
  const AuthFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: streamAuth,
        builder: (ctx, snapShot) {
          final user = snapShot.data;
          if (user != null) {
            authService.setLoggedUser();
            return const VerifyEmail();
          } else {
            return LoginFormScreen();
          }
        });
  }
}
