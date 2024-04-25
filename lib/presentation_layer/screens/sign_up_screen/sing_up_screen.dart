import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_service/auth_service_contract.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/error_connection_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/sign_up_screen/sign_up_form.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/sign_up_screen/sign_up_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/my_dialogs.dart';

class SignUpScreen extends ConsumerWidget with MyDialogs {
  const SignUpScreen({super.key});

  void showMessageError(
    BuildContext context,
    WidgetRef ref,
    String message,
  ) {
    errorDialog(context, () {
      ref
          .read(singUpProvider.notifier)
          .setStatusCreatingUser(StatusCreatingUser.form);
    }, message);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionWifiState = ref.watch(statusConnectionProvider);

    ref.listen<SingUpData>(singUpProvider, (prev, current) {
      if (current.statusCreatingUser != StatusCreatingUser.form &&
          current.statusCreatingUser != StatusCreatingUser.success) {
        showMessageError(
          context,
          ref,
          current.statusCreatingUser.message,
        );
        return;
      }

      if (current.statusCreatingUser == StatusCreatingUser.success) {
        Navigator.of(context).pop();
      }
    });

    return connectionWifiState == ConnectionStatus.noConnected
        ? Scaffold(
            appBar: AppBar(),
            body: const ErrorConnectionScreen(
              message:
                  'You cannot create a new user without internet connection',
            ),
          )
        : SingUpForm();
  }
}
