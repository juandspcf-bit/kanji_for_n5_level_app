import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/main_screens/main_content.dart';

class SingUpForm extends ConsumerStatefulWidget {
  const SingUpForm({super.key});

  @override
  ConsumerState<SingUpForm> createState() => _SingUpFormState();
}

class _SingUpFormState extends ConsumerState<SingUpForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController0 = TextEditingController();
  final TextEditingController textEditingController1 = TextEditingController();
  final TextEditingController textEditingController2 = TextEditingController();
  String pathAssetUser = 'assets/images/user.png';
  String pathProfileUser = '';
  final ImagePicker picker = ImagePicker();

  void onValidate() async {
    if (_formKey.currentState!.validate()) {
      final emailAddress = textEditingController0.text;
      final password1 = textEditingController1.text;
      final password2 = textEditingController2.text;
      logger.d('$password1, $password2');
      if (password1 == password2) {
        _formKey.currentState!.save();
        try {
          final credential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailAddress,
            password: password1,
          );

          if (pathProfileUser.isEmpty) return;
          final userPhoto =
              storageRef.child("userImages/${credential.user!.uid}.jpg");
          try {
            await userPhoto.putFile(File(pathProfileUser));
          } catch (e) {
            logger.e('error');
            logger.e(e);
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            logger.d('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            logger.d('The account already exists for that email.');
          }
        } catch (e) {
          logger.e(e);
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
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController0.dispose();
    textEditingController1.dispose();
    textEditingController2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
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
                      final XFile? photo =
                          await picker.pickImage(source: ImageSource.camera);
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
                        : FileImage(File(pathProfileUser)) as ImageProvider,
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
                        controller: textEditingController0,
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
        ),
      ),
    );
  }
}
