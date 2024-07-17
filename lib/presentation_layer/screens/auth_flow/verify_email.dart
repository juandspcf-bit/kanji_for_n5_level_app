import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/init_main_content.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/sign_in_screen/login_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';

class VerifyEmail extends ConsumerStatefulWidget {
  const VerifyEmail({super.key});

  @override
  ConsumerState<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends ConsumerState<VerifyEmail> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
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
        ? const InitMainContent()
        : Scaffold(
            appBar: AppBar(
              title: Text(context.l10n.verifyEmail),
            ),
            body: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.notificationEmailSent,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                      onPressed: canResendEmail ? sendEmailVerification : null,
                      icon: const Icon(Icons.email),
                      label: Text(context.l10n.resentEmail),
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
                      child: Text(context.l10n.cancel),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
