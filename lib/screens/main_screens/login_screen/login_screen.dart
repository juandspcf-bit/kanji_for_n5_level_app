import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/login_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/error_connection_tabs.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/login_screen/login_form.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/login_screen/login_progress.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/db_dialog_error_message.dart';

class ToLoginFormScreen extends ConsumerWidget with MyDialogs {
  ToLoginFormScreen({super.key});

  void toLoging(BuildContext context, WidgetRef ref) async {
    final result = await ref.read(loginProvider.notifier).toLoging();

    var loginErrorText = '';
    switch (result) {
      case StatusLogingRequest.invalidCredentials:
        {
          loginErrorText = 'Your email and password are wrong';
          break;
        }
      case StatusLogingRequest.userNotFound:
        {
          loginErrorText = 'Your email was not found';
          break;
        }
      case StatusLogingRequest.wrongPassword:
        {
          loginErrorText = 'Your password is wrong';
          break;
        }
      case StatusLogingRequest.tooManyRequest:
        {
          loginErrorText =
              'Access to this account has been temporarily disabled '
              'due to many failed login attempts. You can immediately restore it by '
              'resetting your password or you can try again later.';
          break;
        }
      default:
        loginErrorText = 'An unexpected error has happened';
    }

    if (context.mounted) {
      errorDialog(context, () {}, loginErrorText);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) FlutterNativeSplash.remove();
    });
    final loginFormData = ref.watch(loginProvider);
    final statusConnectionData = ref.watch(statusConnectionProvider);

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Builder(builder: (ctx) {
            if (statusConnectionData == ConnectivityResult.none) {
              return const ErrorConnectionScreen(
                message:
                    'The internet connection has gone, restart the quiz later',
              );
            }

            return loginFormData.statusFetching !=
                    StatusProcessingLoggingFlow.form
                ? const LoginProgress()
                : LoginForm(
                    loginFormData: loginFormData,
                    setEmail: (value) {
                      if (value == null) return;
                      ref.read(loginProvider.notifier).setEmail(value);
                    },
                    setPassword: (value) {
                      if (value == null) return;
                      ref.read(loginProvider.notifier).setPassword(value);
                    },
                    onValidate: () {
                      toLoging(context, ref);
                    },
                  );
          })),
    );
  }
}
