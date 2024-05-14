import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/auth_service/auth_service_contract.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/loading_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/login_screen/login_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/login_screen/login_form.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/my_dialogs.dart';

class LoginFormScreen extends ConsumerWidget with MyDialogs {
  LoginFormScreen({super.key});

  void showLoginResultMessageDialog(
      BuildContext context, StatusLoginRequest result, WidgetRef ref) {
    if (result != StatusLoginRequest.success &&
        result != StatusLoginRequest.notStarted) {
      errorDialog(context, () {
        ref
            .read(loginProvider.notifier)
            .setStatusLoginRequest(StatusLoginRequest.notStarted);
        ref
            .read(loginProvider.notifier)
            .setStatusResetEmail(StatusResetEmail.notStarted);
      }, result.message);
    }
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
    Future.delayed(const Duration(milliseconds: 700), () {
      if (context.mounted) FlutterNativeSplash.remove();
    });
    final loginFormData = ref.watch(loginProvider);

    ref.listen<LoginData>(loginProvider, (previous, current) {
      showLoginResultMessageDialog(context, current.statusLoginRequest, ref);
      showResetEmailMessageDialog(context, current.statusResetEmail, ref);
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Builder(
          builder: (ctx) {
            logger.d(loginFormData.statusLoginFlow);
            return loginFormData.statusLoginFlow !=
                    StatusProcessingLoggingFlow.form
                ? const ProcessProgress(
                    message: 'Login to your account',
                  )
                : SafeArea(
                    child: LoginForm(),
                  );
          },
        ),
      ),
    );
  }
}
