import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/login_provider.dart';
import 'package:kanji_for_n5_level_app/providers/modal_email_reset_password_provider.dart';
import 'package:kanji_for_n5_level_app/providers/sign_up_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/sing_up_screen.dart';

class ToLoginFormScreen extends ConsumerStatefulWidget {
  const ToLoginFormScreen({super.key});

  @override
  ConsumerState<ToLoginFormScreen> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<ToLoginFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';

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

  void onValidate(WidgetRef ref) async {
    final currenState = _formKey.currentState;
    if (currenState == null) return;
    if (currenState.validate()) {
      currenState.save();
      final result = await ref.read(loginProvider.notifier).onValidate(
            email,
            password,
          );

      logger.d(result);
      switch (result) {
        case StatusLogingRequest.invalidCredentials:
        case StatusLogingRequest.userNotFound:
        case StatusLogingRequest.wrongPassword:
          {
            if (context.mounted) {
              var snackBar = SnackBar(
                content: Text(result.message),
                duration: const Duration(seconds: 3),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          }
        case StatusLogingRequest.tooManyRequest:
          {
            if (context.mounted) {
              const text =
                  'Access to this account has been temporarily disabled '
                  'due to many failed login attempts. You can immediately restore it by '
                  'resetting your password or you can try again later.';
              _dialogErrorInLogin(context, text);
            }
          }

          break;
        default:
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (context.mounted) FlutterNativeSplash.remove();
    });
    final dataState = ref.watch(loginProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: dataState.statusFetching == 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login to your account',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    ),
                  ],
                ),
              )
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
                          initialValue: email,
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
                          initialValue: password,
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
                                text.length <= 20) {
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
                      onValidate(ref);
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
