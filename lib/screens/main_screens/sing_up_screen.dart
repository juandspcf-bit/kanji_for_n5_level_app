import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kanji_for_n5_level_app/providers/sign_up_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

class SingUpForm extends ConsumerStatefulWidget {
  const SingUpForm({super.key});

  @override
  ConsumerState<SingUpForm> createState() => _SingUpFormState();
}

class _SingUpFormState extends ConsumerState<SingUpForm> {
  final _formKey = GlobalKey<FormState>();

  late String fullName;
  late String emailAddress;
  late String password1;
  late String password2;

  String pathAssetUser = 'assets/images/user.png';
  String pathProfileUser = '';
  final ImagePicker picker = ImagePicker();

  void onValidation() async {
    final currentState = _formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();
    if (password1 == password2) {
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
    FlutterNativeSplash.remove();
    final signUpDataState = ref.watch(singUpProvider);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: signUpDataState.statusFetching == 0
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
                            TextFormField(
                              decoration: const InputDecoration().copyWith(
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.email),
                                  labelText: 'Email',
                                  hintText: '***@***.com'),
                              keyboardType: TextInputType.emailAddress,
                              validator: (text) {
                                if (text != null &&
                                    EmailValidator.validate(text)) {
                                  return null;
                                } else {
                                  return 'Not a valid email';
                                }
                              },
                              onSaved: (value) {
                                emailAddress = value ?? '';
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
