import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/login_provider.dart';
import 'package:kanji_for_n5_level_app/providers/sign_up_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/sing_up_screen.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;

  Widget _dialog(BuildContext context, String text) {
    return AlertDialog(
      title: const Text("Errro in login!!"),
      content: Text(text),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Okay"))
      ],
    );
  }

  void _dialogErrorInLogin(BuildContext context, String text) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialog(ctx, text),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  void onValidate() async {
    final currenState = _formKey.currentState;
    if (currenState == null) return;
    if (currenState.validate()) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
          logger.e(e.code);
          if (context.mounted) {
            _dialogErrorInLogin(context,
                'No user found for that email or the password is incorrect');
          }
        } else if (e.code == 'user-not-found') {
          if (context.mounted) {
            _dialogErrorInLogin(context, 'No user found for that email.');
          }
        } else if (e.code == 'wrong-password') {
          if (context.mounted) {
            _dialogErrorInLogin(
                context, 'Wrong password provided for that user.');
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    final loginDataState = ref.watch(loginProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Column(
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
                    onSaved: (value) {
                      if (value == null) return;
                      email = value;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: const InputDecoration().copyWith(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.key),
                      labelText: 'Password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (text) {
                      if (text != null &&
                          text.length >= 4 &&
                          text.length <= 10) {
                        return null;
                      } else {
                        return 'Password should be between 10 and 4 characters';
                      }
                    },
                    onSaved: (value) {
                      if (value == null) return;
                      password = value;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
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
                onValidate();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                minimumSize: const Size.fromHeight(40), // NEW
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

                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return const SingUpForm();
                }));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                minimumSize: const Size.fromHeight(40), // NEW
              ),
              child: const Text('Sing Up'),
            ),
          ],
        ),
      ),
    );
  }
}
