import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/sign_up_screen/sign_up_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/login_screen/email_widget.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SingUpFormState();
}

class _SingUpFormState extends ConsumerState<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  late String fullName;
  late String emailAddress;
  late String password1;
  late String password2;

  String pathAssetUser = 'assets/images/user.png';
  String pathProfileUser = '';
  final ImagePicker picker = ImagePicker();

  Widget _dialog(BuildContext context) {
    return AlertDialog(
      title: const Text("Error!!"),
      content: const Text('There is a error in the user creation, try again'),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Okay"))
      ],
    );
  }

  void _scaleDialogForUserCreationError(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialog(ctx),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  void onValidation() async {
    final currentState = _formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();
    if (password1 == password2) {
      try {
        await ref.read(singUpProvider.notifier).createUser(
              pathProfileUser,
              fullName,
              emailAddress,
              password1,
              password2,
            );
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } on ErrorDataBaseException catch (e) {
        logger.e(e.toString());
        if (context.mounted) {
          _scaleDialogForUserCreationError(context);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords should match'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final singUpData = ref.watch(singUpProvider);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: singUpData.statusFetching ==
                StatusProcessingSignUpFlow.signUpProccessing
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Creating user',
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
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
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
                      InkWell(
                        onTap: () async {
                          try {
                            final XFile? photo = await picker.pickImage(
                                source: ImageSource.camera);
                            setState(() {
                              if (photo != null) {
                                pathProfileUser = photo.path;
                              }
                            });
                          } on PlatformException catch (e) {
                            logger.e('Failed to pick image: $e');
                          }
                        },
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: pathProfileUser.isEmpty
                              ? AssetImage(pathAssetUser)
                              : FileImage(File(pathProfileUser))
                                  as ImageProvider,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration().copyWith(
                                border: const OutlineInputBorder(),
                                prefixIcon: const Icon(Icons.person),
                                labelText: 'Full Name',
                              ),
                              keyboardType: TextInputType.name,
                              validator: (text) {
                                if (text != null &&
                                    text.isNotEmpty &&
                                    text.length > 2) {
                                  return null;
                                } else {
                                  return 'Please provide a not to short name';
                                }
                              },
                              onSaved: (value) {
                                fullName = value ?? '';
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            EmailTextField(
                              initialValue: singUpData.emailAddress,
                              setEmail: (email) {
                                if (email == null) return;
                                ref
                                    .read(singUpProvider.notifier)
                                    .setEmail(email);
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
                                    text.length <= 15) {
                                  return null;
                                } else {
                                  return 'Password should be between 15 and 4 characters';
                                }
                              },
                              onSaved: (value) {
                                password1 = value ?? '';
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
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
                                    text.length <= 15) {
                                  return null;
                                } else {
                                  return 'Password should be between 15 and 4 characters';
                                }
                              },
                              onSaved: (value) {
                                password2 = value ?? '';
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
                          onValidation();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                          minimumSize: const Size.fromHeight(40), // NEW
                        ),
                        child: const Text('Sing Up'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
