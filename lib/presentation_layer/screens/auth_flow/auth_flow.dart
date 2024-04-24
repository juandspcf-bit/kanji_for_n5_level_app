import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_service/auth_service_firebase.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/auth_flow/verify_email.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/login_screen/login_screen.dart';
import 'package:kanji_for_n5_level_app/providers/score_kanji_list_provider.dart';

class AuthFlow extends ConsumerWidget {
  const AuthFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(lottieFilesProvider.notifier).initLottieFile();
    localDBService.deleteUserQueue();
    return StreamBuilder(
        stream: streamAuth,
        builder: (ctx, snapShot) {
          final user = snapShot.data;
          if (user != null) {
            ref.read(authServiceProvider).setLoggedUser();
            return const VerifyEmail();
          } else {
            return LoginFormScreen();
          }
        });
  }
}
