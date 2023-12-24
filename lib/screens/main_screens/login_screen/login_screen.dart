import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/login_provider.dart';
import 'package:kanji_for_n5_level_app/providers/modal_email_reset_password_provider.dart';
import 'package:kanji_for_n5_level_app/providers/sign_up_provider.dart';
import 'package:kanji_for_n5_level_app/screens/common_widgets/password_widget.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/login_screen/login_progress.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/sing_up_screen.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/db_dialog_error_message.dart';

class ToLoginFormScreen extends ConsumerWidget with MyDialogs {
  ToLoginFormScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  void onValidate(BuildContext context, WidgetRef ref) async {
    final currenState = _formKey.currentState;
    if (currenState == null) return;
    if (currenState.validate()) {
      currenState.save();
      ref.read(loginProvider.notifier).onValidate();
      final result = await ref.read(loginProvider.notifier).onValidate();

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
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) FlutterNativeSplash.remove();
    });
    final loginFormData = ref.watch(loginProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: loginFormData.statusFetching != StatusProcessingLoggingFlow.form
            ? const LoginProgress()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Loging to Kanji for N5',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: loginFormData.email,
                          decoration: const InputDecoration().copyWith(
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.email),
                            labelText: 'Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (text) {
                            if (text != null && EmailValidator.validate(text)) {
                              return null;
                            } else {
                              return 'Not a valid email';
                            }
                          },
                          onSaved: (value) {
                            if (value == null) return;
                            ref.read(loginProvider.notifier).setEmail(value);
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        PasswordTextField(
                          initialValue: loginFormData.password,
                          onSave: (value) {
                            if (value == null) return;
                            ref.read(loginProvider.notifier).setPassword(value);
                          },
                          onToggleVisibility: () {
                            final currentState = _formKey.currentState;
                            if (currentState == null) return;
                            currentState.save();
                            ref.read(loginProvider.notifier).toggleVisibility();
                          },
                          isPasswordVisible: loginFormData.isVisiblePassword,
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
                          showModalBottomSheet(
                              isScrollControlled: true,
                              useSafeArea: true,
                              context: context,
                              builder: (ctx) {
                                return ModalEmailResetPassword();
                              });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(context)
                              .colorScheme
                              .onBackground, //Text Color
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
                      onValidate(context, ref);
                    },
                    style: ElevatedButton.styleFrom().copyWith(
                      minimumSize: const MaterialStatePropertyAll(
                        Size.fromHeight(40),
                      ),
                    ),
                    child: const Text('Login'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);

                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }

                      ref.read(singUpProvider.notifier).setStatus(1);

                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) {
                        return const SingUpForm();
                      }));
                    },
                    style: ElevatedButton.styleFrom().copyWith(
                      minimumSize: const MaterialStatePropertyAll(
                        Size.fromHeight(40),
                      ),
                    ),
                    child: const Text('Sing Up'),
                  ),
                ],
              ),
      ),
    );
  }
}

class ModalEmailResetPassword extends ConsumerWidget {
  ModalEmailResetPassword({
    super.key,
  });

  final _formKey = GlobalKey<FormState>();

  bool onValidate(WidgetRef ref, BuildContext context) {
    final currentState = _formKey.currentState;
    if (currentState == null) return false;
    if (!currentState.validate()) return false;
    currentState.save();
    ref.read(modalEmailResetProvider.notifier).onValidate().then((result) {
      if (context.mounted) {
        var snackBar = SnackBar(
          content: Text(result.message),
          duration: const Duration(seconds: 3),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Center(
          child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
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
            child: TextFormField(
              decoration: const InputDecoration().copyWith(
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email),
                  labelText: 'Email',
                  hintText: '***@***.com'),
              keyboardType: TextInputType.emailAddress,
              validator: (text) {
                if (text != null && EmailValidator.validate(text)) {
                  return null;
                } else {
                  return 'Not a valid email';
                }
              },
              onSaved: (email) {
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
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom().copyWith(
              minimumSize: const MaterialStatePropertyAll(
                Size.fromHeight(40),
              ),
            ),
            child: const Text('Reset password'),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Text(
              'Click above to reset your password and an email will be sent to your inbox'
              ' with some instructions.',
              style: Theme.of(context).textTheme.bodyLarge,
              softWrap: false,
              maxLines: 3,
              overflow: TextOverflow.ellipsis, // new
            ),
          ),
        ],
      )),
    );
  }
}
