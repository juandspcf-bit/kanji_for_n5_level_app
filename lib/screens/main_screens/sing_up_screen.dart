import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/sign_up_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

class SingUpForm extends ConsumerStatefulWidget {
  const SingUpForm({super.key});

  @override
  ConsumerState<SingUpForm> createState() => _SingUpFormState();
}

class _SingUpFormState extends ConsumerState<SingUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textEditingControllerFullName =
      TextEditingController();
  final TextEditingController textEditingController0 = TextEditingController();
  final TextEditingController textEditingController1 = TextEditingController();
  final TextEditingController textEditingController2 = TextEditingController();
  String pathAssetUser = 'assets/images/user.png';
  String pathProfileUser = '';
  final ImagePicker picker = ImagePicker();

  @override
  void dispose() {
    super.dispose();
    textEditingControllerFullName.dispose();
    textEditingController0.dispose();
    textEditingController1.dispose();
    textEditingController2.dispose();
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
                              controller: textEditingControllerFullName,
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
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: textEditingController0,
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
                                    text.length <= 15) {
                                  return null;
                                } else {
                                  return 'Password should be between 15 and 4 characters';
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
                                    text.length <= 15) {
                                  return null;
                                } else {
                                  return 'Password should be between 15 and 4 characters';
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
                          ref.read(singUpProvider.notifier).onValidate(
                              _formKey,
                              pathProfileUser,
                              textEditingControllerFullName.text,
                              textEditingController0.text,
                              textEditingController1.text,
                              textEditingController2.text,
                              context);
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
