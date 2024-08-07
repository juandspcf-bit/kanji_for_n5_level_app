import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/password_change/change_password_button.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/password_change/password_change_flow_provider.dart';

class PasswordChange extends ConsumerWidget {
  PasswordChange({
    super.key,
    required this.initPassword,
    required this.initConfirmPassword,
    required this.isVisiblePassword,
    required this.isVisibleConfirmPassword,
  });

  final String initPassword;
  final String initConfirmPassword;
  final bool isVisiblePassword;
  final bool isVisibleConfirmPassword;

  void onValidation(WidgetRef ref) async {
    final currentState = _formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();
    if (ref.read(passwordChangeFlowProvider).password ==
        ref.read(passwordChangeFlowProvider).confirmPassword) {
      ref.read(passwordChangeFlowProvider.notifier).setStatusProcessing(
          StatusProcessingPasswordChangeFlow.showPasswordInput);
    } else {
      ref.read(passwordChangeFlowProvider.notifier).setStatusProcessing(
          StatusProcessingPasswordChangeFlow.noMatchPasswords);
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Icon(
            Icons.key,
            color: Theme.of(context).colorScheme.primary,
            size: 100,
          ),
          const SizedBox(
            height: 40,
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: initPassword,
                    obscureText: !isVisiblePassword,
                    decoration: InputDecoration(
                      label: Text(context.l10n.yourNewPassword),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            final currentState = _formKey.currentState;
                            if (currentState == null) return;
                            currentState.save();
                            ref
                                .read(passwordChangeFlowProvider.notifier)
                                .toggleVisibilityPassword();
                          },
                          child: isVisiblePassword
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (text) {
                      if (text != null &&
                          text.length >= 4 &&
                          text.length <= 20) {
                        return null;
                      } else {
                        return context.l10n.invalidNewPassword;
                      }
                    },
                    onSaved: (text) {
                      ref
                          .read(passwordChangeFlowProvider.notifier)
                          .setPassword(text ?? '');
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: initConfirmPassword,
                    obscureText: !isVisibleConfirmPassword,
                    decoration: InputDecoration(
                      label: Text(context.l10n.yourNewConfirmPassword),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            final currentState = _formKey.currentState;
                            if (currentState == null) return;
                            currentState.save();
                            ref
                                .read(passwordChangeFlowProvider.notifier)
                                .toggleConfirmVisibilityPassword();
                          },
                          child: isVisibleConfirmPassword
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (text) {
                      if (text != null &&
                          text.length >= 4 &&
                          text.length <= 20) {
                        return null;
                      } else {
                        return context.l10n.invalidNewPassword;
                      }
                    },
                    onSaved: (text) {
                      ref
                          .read(passwordChangeFlowProvider.notifier)
                          .setConfirmPassword(text ?? '');
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ChangePasswordButton(callback: () {
                    onValidation(ref);
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
