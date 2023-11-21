import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main_screens/main_content.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController1 = TextEditingController();
  final TextEditingController textEditingController2 = TextEditingController();

  void onValidate() {
    if (_formKey.currentState!.validate()) {
      final password1 = textEditingController1.text;
      final password2 = textEditingController2.text;
      logger.d('$password1, $password2');
      if (password1 == password2) {
        _formKey.currentState!.save();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords should match'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController1.dispose();
    textEditingController2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign Up to Kanji for N5',
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
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: textEditingController1,
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
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: textEditingController2,
                    decoration: const InputDecoration().copyWith(
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.key),
                      labelText: 'Confirm Password',
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
                  )
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
              child: const Text('Sing Up'),
            ),
          ],
        ),
      ),
    );
  }
}
