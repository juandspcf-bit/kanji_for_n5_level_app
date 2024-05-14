import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/loading_screen.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/login_screen/login_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';

class VerifyEmail extends ConsumerStatefulWidget {
  const VerifyEmail({super.key});

  @override
  ConsumerState<VerifyEmail> createState() => _VerifyEmailEstate();
}

class _VerifyEmailEstate extends ConsumerState<VerifyEmail> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    logger.d("verify email");
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendEmailVerification();
      timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        checkVerifiedEmail();
      });
    }
  }

  void sendEmailVerification() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      user!.sendEmailVerification();

      setState(() {
        canResendEmail = false;
      });

      await Future.delayed(const Duration(seconds: 5));

      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      timer?.cancel();
      logger.e(e);
    }
  }

  void checkVerifiedEmail() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

      if (isEmailVerified) {
        timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return isEmailVerified
        ? FutureBuilder(
            future: ref.read(statusConnectionProvider) ==
                    ConnectionStatus.noConnected
                ? ref.read(mainScreenProvider.notifier).initAppOffline()
                : ref.read(mainScreenProvider.notifier).initAppOnline(),
            builder: (BuildContext context, AsyncSnapshot<void> snapShot) {
              final connectionStatus = snapShot.connectionState;
              if (connectionStatus == ConnectionState.waiting) {
                return const Scaffold(
                  body: ProcessProgress(
                    message: 'Loading',
                  ),
                );
              } else if (connectionStatus == ConnectionState.done ||
                  connectionStatus == ConnectionState.active) {
                return const MainContent();
              } else {
                return const Center(child: Text('error'));
              }
            },
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Verify email'),
            ),
            body: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'A notification email has been sent',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                      onPressed: canResendEmail ? sendEmailVerification : null,
                      icon: const Icon(Icons.email),
                      label: const Text('resent email'),
                      style: ElevatedButton.styleFrom().copyWith(
                        minimumSize: const WidgetStatePropertyAll(
                          Size.fromHeight(40),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        try {
                          timer?.cancel();
                          ref.read(authServiceProvider).singOut();
                          ref
                              .read(mainScreenProvider.notifier)
                              .resetMainScreenState();
                          ref.read(loginProvider.notifier).resetData();

                          ref.read(loginProvider.notifier).setStatusLoggingFlow(
                              StatusProcessingLoggingFlow.form);
                        } catch (e) {
                          logger.e('error sign out');
                          logger.e(e);
                        }
                      },
                      style: ElevatedButton.styleFrom().copyWith(
                        minimumSize: const WidgetStatePropertyAll(
                          Size.fromHeight(40),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
