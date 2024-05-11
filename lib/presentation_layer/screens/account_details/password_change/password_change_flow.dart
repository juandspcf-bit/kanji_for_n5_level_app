// ignore: implementation_imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/password_change/password_change_flow_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/password_change/password_change.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/loading_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/my_dialogs.dart';

class PasswordChangeFlow extends ConsumerWidget with MyDialogs {
  const PasswordChangeFlow({super.key});

  Widget _dialogPassworRequest(BuildContext context, WidgetRef ref) {
    final dialogFormKey = GlobalKey<FormState>();
    var textPassword = '';
    void onValidatePassword(BuildContext context, WidgetRef ref) {
      final currenState = dialogFormKey.currentState;
      if (currenState == null) return;
      if (currenState.validate()) {
        currenState.save();
        Navigator.of(context).pop();
        ref
            .read(passwordChangeFlowProvider.notifier)
            .setStatusProcessing(StatusProcessingPasswordChangeFlow.form);
        ref.read(passwordChangeFlowProvider.notifier).updateUserData(
              textPassword,
            );
      }
    }

    return AlertDialog(
      title: const Text('Type your password'),
      content: Form(
        key: dialogFormKey,
        child: TextFormField(
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            label: Text('password'),
            suffixIcon: Icon(Icons.key),
            border: OutlineInputBorder(),
          ),
          validator: (text) {
            if (text != null && text.length >= 4 && text.length <= 20) {
              return null;
            } else {
              return 'Invalid password';
            }
          },
          onSaved: (value) {
            if (value == null) return;
            textPassword = value;
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            ref
                .read(passwordChangeFlowProvider.notifier)
                .setStatusProcessing(StatusProcessingPasswordChangeFlow.form);
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            onValidatePassword(context, ref);
          },
          child: const Text("Okay"),
        ),
      ],
    );
  }

  void passworRequestDialog(BuildContext buildContext, WidgetRef ref) {
    showGeneralDialog(
      context: buildContext,
      pageBuilder: (ctx, a1, a2) {
        return _dialogPassworRequest(buildContext, ref);
      },
      transitionBuilder: (ctx, a1, a2, child) {
        final transformedAnimation =
            a1.drive(CurveTween(curve: Curves.decelerate));
        final value = transformedAnimation.value;
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  Widget getScreen(PasswordChangeFlowData passwordChangeFlowData) {
    if (passwordChangeFlowData.statusProcessing ==
        StatusProcessingPasswordChangeFlow.updating) {
      return const ProcessProgress(message: 'Updating Password');
    }

    return PassworChange(
      initPassword: passwordChangeFlowData.password,
      initConfirmPassword: passwordChangeFlowData.confirmPassword,
      isVisibleConfirmPassword: passwordChangeFlowData.isVisibleConfirmPassword,
      isVisiblePassword: passwordChangeFlowData.isVisiblePassword,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<PasswordChangeFlowData>(passwordChangeFlowProvider,
        (previous, current) {
      if (current.statusProcessing ==
          StatusProcessingPasswordChangeFlow.showPasswordInput) {
        passworRequestDialog(context, ref);
      }

      if (current.statusProcessing ==
          StatusProcessingPasswordChangeFlow.noMatchPasswords) {
        errorDialog(context, () {
          ref
              .read(passwordChangeFlowProvider.notifier)
              .setStatusProcessing(StatusProcessingPasswordChangeFlow.form);
        }, 'passwords not match');
      }

      if (current.statusProcessing ==
          StatusProcessingPasswordChangeFlow.error) {
        errorDialog(context, () {
          ref
              .read(passwordChangeFlowProvider.notifier)
              .setStatusProcessing(StatusProcessingPasswordChangeFlow.form);
        }, 'an error happend during updating process');
      }

      if (current.statusProcessing ==
          StatusProcessingPasswordChangeFlow.succsess) {
        successDialog(context, () {
          ref
              .read(passwordChangeFlowProvider.notifier)
              .setStatusProcessing(StatusProcessingPasswordChangeFlow.form);
        }, 'succeful updating process');
      }
    });

    final passwordChangeFlowData = ref.watch(passwordChangeFlowProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: getScreen(passwordChangeFlowData),
      ),
    );
  }
}
