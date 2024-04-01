import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/sign_up_screen/sign_up_form.dart';
import 'package:kanji_for_n5_level_app/screens/sign_up_screen/sign_up_provider.dart';
import 'package:kanji_for_n5_level_app/screens/common_widgets/my_dialogs.dart';

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
          .setStatusCreatingUser(StatusCreatingUser.notStarted);
    }, message);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SingUpData>(singUpProvider, (prev, current) {
      if (current.statusCreatingUser != StatusCreatingUser.notStarted &&
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

    return SingUpForm();
  }
}
