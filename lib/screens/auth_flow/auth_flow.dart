import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_firebase_impl/auth_service_firebase.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/screens/auth_flow/verify_email.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/screens/login_screen/login_screen.dart';

class AuthFlow extends ConsumerWidget {
  const AuthFlow({super.key});

  Widget toLoggedUserScreen(
      ConnectivityResult connectionWifiState, WidgetRef ref) {
    return const VerifyEmail(); /* FutureBuilder(
      future: connectionWifiState == ConnectivityResult.none
          ? ref.read(mainScreenProvider.notifier).initAppOffline()
          : ref.read(mainScreenProvider.notifier).initAppOnline(),
      builder: (BuildContext context, AsyncSnapshot<void> snapShot) {
        final connectionStatus = snapShot.connectionState;
        if (connectionStatus == ConnectionState.waiting ) {
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
    ); */
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionWifiState = ref.watch(statusConnectionProvider);
    return StreamBuilder(
        stream: streamAuth,
        builder: (ctx, snapShot) {
          final user = snapShot.data;
          logger.d('the user is ${snapShot.data}');
          if (user != null) {
            authService.setLoggedUser();
            return toLoggedUserScreen(connectionWifiState, ref);
          } else {
            return ToLoginFormScreen();
          }
        });
  }
}
