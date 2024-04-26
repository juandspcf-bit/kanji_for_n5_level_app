import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_service/auth_service_firebase.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/services.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/auth_flow/verify_email.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/error_connection_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/loading_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/login_screen/login_screen.dart';
import 'package:kanji_for_n5_level_app/providers/score_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';

class AuthFlow extends ConsumerStatefulWidget {
  const AuthFlow({super.key});

  @override
  ConsumerState<AuthFlow> createState() => _AutFlowState();
}

class _AutFlowState extends ConsumerState<AuthFlow> {
  @override
  Widget build(BuildContext context) {
    ref.read(lottieFilesProvider.notifier).initLottieFile();
    //localDBService.deleteUserQueue();

    ref.listen<ConnectionStatus>(statusConnectionProvider, (previuos, current) {
      ref.read(toastServiceProvider).dismiss(context);

      if (current == ConnectionStatus.noConnected) {
        ref.read(toastServiceProvider).showMessage(context,
            'No connected to internet', const Icon(Icons.wifi_off), null);
        return;
      }
      if (current == ConnectionStatus.connected) {
        ref.read(toastServiceProvider).showMessage(context,
            'Internet connection restored', const Icon(Icons.wifi_off), null);
        return;
      }
    });

    return StreamBuilder(
        stream: streamAuth,
        builder: (ctx, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const ProcessProgress(
              message: 'Login to your account',
            );
          }
          if (snapShot.hasData) {
            final user = snapShot.data;
            if (user != null) {
              ref.read(authServiceProvider).setLoggedUser();
              return const VerifyEmail();
            } else {
              return LoginFormScreen();
            }
          }

          return const ErrorConnectionScreen(message: 'Error while login');
        });
  }
}
