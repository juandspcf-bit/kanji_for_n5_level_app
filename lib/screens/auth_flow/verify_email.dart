import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content_provider.dart';

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
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    logger.d('is verified $isEmailVerified');
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
    final connectionWifiState = ref.watch(statusConnectionProvider);
    return isEmailVerified
        ? FutureBuilder(
            future: connectionWifiState == ConnectivityResult.none
                ? ref.read(mainScreenProvider.notifier).initAppOffline()
                : ref.read(mainScreenProvider.notifier).initAppOnline(),
            builder: (BuildContext context, AsyncSnapshot<void> snapShot) {
              final connectionStatus = snapShot.connectionState;
              if (connectionStatus == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Loading',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        const SizedBox(
                          height: 100,
                          width: 100,
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (connectionStatus == ConnectionState.done ||
                  connectionStatus == ConnectionState.active) {
                FlutterNativeSplash.remove();
                return const MainContent(); //const MainContent();
              } else {
                return const Center(child: Text('error'));
              }
            },
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Verify email'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'A notification email has been sent',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: canResendEmail ? sendEmailVerification : null,
                    icon: const Icon(Icons.email),
                    label: const Text('resent email'),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        authService.singOut();
                      },
                      child: const Text('Cancel')),
                ],
              ),
            ),
          );
  }
}
