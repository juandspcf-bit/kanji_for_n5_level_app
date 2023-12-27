import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_contract/sign_in_user_contract.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/login_screen/login_provider.dart';
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
      default:
        loginErrorText = result.message;
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
    switch (result) {
      case StatusResetEmail.notStarted:
        {
          break;
        }
      case StatusResetEmail.success:
        {
          successDialog(context, () {
            ref
                .read(loginProvider.notifier)
                .setStatusResetEmail(StatusResetEmail.notStarted);
          }, result.message);
          break;
        }
      case StatusResetEmail.error:
        {
          errorDialog(context, () {
            ref
                .read(loginProvider.notifier)
                .setStatusResetEmail(StatusResetEmail.notStarted);
          }, result.message);
          break;
        }
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
