import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/auth_flow/verify_email.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/loading_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/sign_in_screen/login_screen.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';

class AuthFlow extends ConsumerStatefulWidget {
  const AuthFlow({super.key});

  @override
  ConsumerState<AuthFlow> createState() => _AutFlowState();
}

class _AutFlowState extends ConsumerState<AuthFlow> {
  late Stream<User?> streamUser;

  @override
  void initState() {
    super.initState();

    streamUser = FirebaseAuth.instance.userChanges();
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(milliseconds: 1000), () {
      final current = ref.read(statusConnectionProvider);
      if (current == ConnectionStatus.noConnected) {
        ref.read(toastServiceProvider).dismiss(context);
        ref.read(toastServiceProvider).showMessage(
              context,
              context.l10n.noInternet,
              Icons.wifi_off,
              const Duration(days: 1),
              '',
              null,
            );
      }
    });

    ref.listen<ConnectionStatus>(statusConnectionProvider, (previous, current) {
      ref.read(toastServiceProvider).dismiss(context);

      if (current == ConnectionStatus.noConnected) {
        ref.read(toastServiceProvider).showMessage(
              context,
              context.l10n.noInternet,
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
              context.l10n.restoredInternet,
              Icons.wifi,
              const Duration(seconds: 5),
              '',
              null,
            );
        return;
      }
    });

    return Scaffold(
      body: StreamBuilder(
          stream: streamUser, //ref.read(authServiceProvider).authStream(),
          builder: (ctx, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return ProcessProgress(
                message: context.l10n.loginProcess,
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
                return LoginFormScreen();
              }
            }

            return LoginFormScreen();
          }),
    );
  }
}
