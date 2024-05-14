import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/auth_flow/verify_email.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/loading_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/login_screen/login_screen.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';

class AuthFlow extends ConsumerStatefulWidget {
  const AuthFlow({super.key});

  @override
  ConsumerState<AuthFlow> createState() => _AutFlowState();
}

class _AutFlowState extends ConsumerState<AuthFlow> {
  @override
  Widget build(BuildContext context) {
    //localDBService.deleteUserQueue();

    ref.listen<ConnectionStatus>(statusConnectionProvider, (previous, current) {
      ref.read(toastServiceProvider).dismiss(context);

      if (current == ConnectionStatus.noConnected) {
        ref.read(toastServiceProvider).showMessage(
              context,
              'No connected to internet',
              Icons.wifi_off,
              const Duration(days: 1),
              '',
              null,
            );
        return;
      }
      if (current == ConnectionStatus.connected) {
        ref.read(toastServiceProvider).showMessage(
              context,
              'Internet connection restored',
              Icons.wifi,
              const Duration(seconds: 5),
              '',
              null,
            );
        return;
      }
    });

    return StreamBuilder(
        stream: ref.read(authServiceProvider).authStream(),
        builder: (ctx, snapShot) {
          logger.d("stream auth: ${snapShot.connectionState}");
          if (snapShot.connectionState == ConnectionState.waiting) {
            return ProcessProgress(
              message: 'Login to your account ${snapShot.connectionState}',
            );
          }
          if ((snapShot.connectionState == ConnectionState.active ||
                  snapShot.connectionState == ConnectionState.done) &&
              snapShot.hasData) {
            final user = snapShot.data;
            if (user != null) {
              ref.read(authServiceProvider).setLoggedUser();
              return const VerifyEmail();
            } else {
              logger.d("active done");
              return LoginFormScreen();
            }
          }

/*           if (snapShot.connectionState == ConnectionState.active &&
              !snapShot.hasData) {
            logger.d("active no data");
            return Placeholder(); //LoginFormScreen();
          } */

          return LoginFormScreen();
        });
  }
}
