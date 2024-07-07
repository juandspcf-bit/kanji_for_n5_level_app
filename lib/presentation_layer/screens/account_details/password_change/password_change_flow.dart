// ignore: implementation_imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/password_change/password_change_flow_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/password_change/password_change.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/my_dialogs.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/sign_in_screen/login_provider.dart';

class PasswordChangeFlowScreen extends ConsumerWidget with MyDialogs {
  const PasswordChangeFlowScreen({super.key});

  Widget _dialogPasswordRequest(BuildContext context, WidgetRef ref) {
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
        ref.read(passwordChangeFlowProvider.notifier).updatePassword(
              textPassword,
            );
      }
    }

    return AlertDialog(
      title: Text(context.l10n.typeYourPassword),
      content: Form(
        key: dialogFormKey,
        child: TextFormField(
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            label: Text(context.l10n.password),
            suffixIcon: const Icon(Icons.key),
            border: const OutlineInputBorder(),
          ),
          validator: (text) {
            if (text != null && text.length >= 4 && text.length <= 20) {
              return null;
            } else {
              return context.l10n.invalidPassword;
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
          child: Text(context.l10n.cancel),
        ),
        TextButton(
          onPressed: () {
            onValidatePassword(context, ref);
          },
          child: Text(context.l10n.okay),
        ),
      ],
    );
  }

  void passwordRequestDialog(BuildContext buildContext, WidgetRef ref) {
    showGeneralDialog(
      context: buildContext,
      pageBuilder: (ctx, a1, a2) {
        return _dialogPasswordRequest(buildContext, ref);
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
    return PasswordChange(
      initPassword: passwordChangeFlowData.password,
      initConfirmPassword: passwordChangeFlowData.confirmPassword,
      isVisibleConfirmPassword: passwordChangeFlowData.isVisibleConfirmPassword,
      isVisiblePassword: passwordChangeFlowData.isVisiblePassword,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<PasswordChangeFlowData>(
        passwordChangeFlowProvider, (previous, current) {});

    ref.listen<PasswordChangeFlowData>(
      passwordChangeFlowProvider,
      (previous, current) {
        if (current.statusProcessing ==
            StatusProcessingPasswordChangeFlow.showPasswordInput) {
          passwordRequestDialog(context, ref);
        }

        ref.read(toastServiceProvider).dismiss(context);
        if (current.statusProcessing ==
            StatusProcessingPasswordChangeFlow.noMatchPasswords) {
          ref
              .read(passwordChangeFlowProvider.notifier)
              .setStatusProcessing(StatusProcessingPasswordChangeFlow.form);
          ref.read(toastServiceProvider).showMessage(
                context,
                context.l10n.passwordNotMach,
                Icons.error,
                const Duration(seconds: 3),
                "",
                null,
              );
        }

        if (current.statusProcessing ==
            StatusProcessingPasswordChangeFlow.error) {
          ref
              .read(passwordChangeFlowProvider.notifier)
              .setStatusProcessing(StatusProcessingPasswordChangeFlow.form);
          ref.read(toastServiceProvider).showMessage(
                context,
                context.l10n.updatingError,
                Icons.error,
                const Duration(seconds: 3),
                "",
                null,
              );
        }

        if (current.statusProcessing ==
            StatusProcessingPasswordChangeFlow.success) {
          ref
              .read(passwordChangeFlowProvider.notifier)
              .setStatusProcessing(StatusProcessingPasswordChangeFlow.form);
          ref.read(toastServiceProvider).showMessage(
                context,
                context.l10n.updatingSuccess,
                Icons.done,
                const Duration(seconds: 3),
                "",
                null,
              );

          ref.read(authServiceProvider).singOut().then((data) {
            if (context.mounted) {
              Navigator.pop(context);
              Navigator.pop(context);
            }
            ref.read(mainScreenProvider.notifier).resetMainScreenState();
            ref.read(loginProvider.notifier).resetData();
            ref
                .read(loginProvider.notifier)
                .setStatusLoggingFlow(StatusProcessingLoggingFlow.form);
          });
        }
      },
    );

    final passwordChangeFlowData = ref.watch(passwordChangeFlowProvider);
    return PopScope(
      canPop: !(ref.watch(passwordChangeFlowProvider).statusProcessing ==
          StatusProcessingPasswordChangeFlow.updating),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.changeYourPassword),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: PasswordChange(
            initPassword: passwordChangeFlowData.password,
            initConfirmPassword: passwordChangeFlowData.confirmPassword,
            isVisibleConfirmPassword:
                passwordChangeFlowData.isVisibleConfirmPassword,
            isVisiblePassword: passwordChangeFlowData.isVisiblePassword,
          ),
        ),
      ),
    );
  }
}
