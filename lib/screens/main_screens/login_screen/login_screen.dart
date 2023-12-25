import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/login_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/error_connection_tabs.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/login_screen/login_form.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/login_screen/login_progress.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/db_dialog_error_message.dart';

class ToLoginFormScreen extends ConsumerWidget with MyDialogs {
  ToLoginFormScreen({super.key});

  void toLoging(BuildContext context, WidgetRef ref) async {
    await ref.read(loginProvider.notifier).toLoging();
  }

  void showLoginResultMessageDialog(
      BuildContext context, StatusLogingRequest result, WidgetRef ref) {
    var loginErrorText = '';
    switch (result) {
      case StatusLogingRequest.success:
      case StatusLogingRequest.notStarted:
        {
          return;
        }
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

    errorDialog(context, () {
      ref
          .read(loginProvider.notifier)
          .setStatusLogingRequest(StatusLogingRequest.notStarted);
      ref
          .read(loginProvider.notifier)
          .setStatusResetEmail(StatusResetEmail.notStarted);
    }, loginErrorText);
  }

  void showResetEmailMessageDialog(
      BuildContext context, StatusResetEmail result, WidgetRef ref) {
    if (result == StatusResetEmail.error) {
      errorDialog(context, () {
        ref
            .read(loginProvider.notifier)
            .setStatusResetEmail(StatusResetEmail.notStarted);
      }, 'There is no corresponding user for this email');
    } else if (result == StatusResetEmail.success) {
      successDialog(context, () {
        ref
            .read(loginProvider.notifier)
            .setStatusResetEmail(StatusResetEmail.notStarted);
      }, 'The reset email link was succefully sent');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) FlutterNativeSplash.remove();
    });
    final loginFormData = ref.watch(loginProvider);
    final statusConnectionData = ref.watch(statusConnectionProvider);

    ref.listen<LogingData>(loginProvider, (previuos, current) {
      logger.e(current.statusLogingRequest);
      showLoginResultMessageDialog(context, current.statusLogingRequest, ref);
      showResetEmailMessageDialog(context, current.statusResetEmail, ref);
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Builder(
          builder: (ctx) {
            if (statusConnectionData == ConnectivityResult.none) {
              return const ErrorConnectionScreen(
                message: 'No internet connection, try again later',
              );
            }

            return loginFormData.statusLogingFlow !=
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
                    onSuccefulValidation: () {
                      toLoging(context, ref);
                    },
                  );
          },
        ),
      ),
    );
  }
}
