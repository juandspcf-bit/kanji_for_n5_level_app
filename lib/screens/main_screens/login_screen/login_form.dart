import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_contract/auth_service_contract.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/login_screen/login_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/login_screen/modal_email_reset_password_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/sign_up_screen/sign_up_provider.dart';
import 'package:kanji_for_n5_level_app/screens/common_widgets/password_widget.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/login_screen/email_widget.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/sign_up_screen/sing_up_screen.dart';
import 'package:kanji_for_n5_level_app/screens/common_widgets/my_dialogs.dart';

class LoginForm extends ConsumerWidget {
  LoginForm({
    super.key,
    required this.loginFormData,
    required this.setEmail,
    required this.setPassword,
    required this.onSuccefulValidation,
  });
  final _formKey = GlobalKey<FormState>();
  final LogingData loginFormData;
  final void Function(String? value) setEmail;
  final void Function(String? value) setPassword;
  final void Function() onSuccefulValidation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person,
            size: 80,
          ),
          const SizedBox(
            height: 40,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                EmailTextField(
                  initialValue: loginFormData.email,
                  setEmail: (text) {
                    setEmail(text);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                PasswordTextField(
                  initialValue: loginFormData.password,
                  formKey: _formKey,
                  onSave: setPassword,
                  labelText: 'password',
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: TextButton(
                onPressed: () async {
                  ref.read(modalEmailResetProvider.notifier).resetData();
                  showModalBottomSheet(
                      isScrollControlled: true,
                      useSafeArea: true,
                      context: context,
                      builder: (ctx) {
                        return ModalEmailResetPassword();
                      });
                },
                style: TextButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).colorScheme.onBackground, //Text Color
                ),
                child: Text(
                  'Forgotten password?',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }

              final currenState = _formKey.currentState;
              if (currenState == null) return;
              if (currenState.validate()) {
                currenState.save();
                onSuccefulValidation();
              }
            },
            style: ElevatedButton.styleFrom().copyWith(
              minimumSize: const MaterialStatePropertyAll(
                Size.fromHeight(40),
              ),
            ),
            child: const Text('Login'),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }

              ref.read(singUpProvider.notifier).resetStatus();

              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                return const SignUpForm();
              }));
            },
            style: ElevatedButton.styleFrom().copyWith(
              minimumSize: const MaterialStatePropertyAll(
                Size.fromHeight(40),
              ),
            ),
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}

class ModalEmailResetPassword extends ConsumerWidget with MyDialogs {
  ModalEmailResetPassword({
    super.key,
  });

  final _formKey = GlobalKey<FormState>();

  bool onValidate(WidgetRef ref, BuildContext context) {
    final currentState = _formKey.currentState;
    if (currentState == null) return false;
    if (!currentState.validate()) return false;
    currentState.save();
    ref
        .read(modalEmailResetProvider.notifier)
        .sendPasswordResetEmail()
        .then((result) {
      if (result == StatusResetPasswordRequest.success) {
        Navigator.of(context).pop();
        ref
            .read(loginProvider.notifier)
            .setStatusResetEmail(StatusResetEmail.success);
      } else {
        logger.e(result.message);
        ref
            .read(loginProvider.notifier)
            .setStatusResetEmail(StatusResetEmail.error);
      }
    });
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modalEmailResetData = ref.watch(modalEmailResetProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Center(
          child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: modalEmailResetData.requestStatus ==
                      StatusSendingRequest.sending
                  ? null
                  : () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                      Navigator.of(context).pop();
                    },
              icon: const Icon(Icons.close_outlined),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Form(
            key: _formKey,
            child: EmailTextField(
              initialValue: '',
              setEmail: (email) {
                if (email == null) return;
                ref.read(modalEmailResetProvider.notifier).setEmail(email);
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              FocusScopeNode currentFocus = FocusScope.of(context);

              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }

              if (!onValidate(ref, context)) return;
            },
            style: ElevatedButton.styleFrom().copyWith(
              minimumSize: const MaterialStatePropertyAll(
                Size.fromHeight(40),
              ),
            ),
            child: modalEmailResetData.requestStatus ==
                    StatusSendingRequest.sending
                ? SizedBox(
                    height: 40 - 15,
                    width: 40 - 15,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                : const Text('Reset password'),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: modalEmailResetData.requestStatus ==
                    StatusSendingRequest.sending
                ? Text(
                    'sending link',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  )
                : Text(
                    'Click above to reset your password and an email will be sent to your inbox'
                    ' with some instructions.',
                    style: Theme.of(context).textTheme.bodyLarge,
                    softWrap: false,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify, // new
                  ),
          ),
        ],
      )),
    );
  }
}
