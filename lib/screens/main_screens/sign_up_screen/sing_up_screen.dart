import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/screens/common_widgets/password_widget.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/sign_up_screen/sign_up_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/login_screen/email_widget.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/db_dialog_error_message.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SingUpFormState();
}

class _SingUpFormState extends ConsumerState<SignUpForm> with MyDialogs {
  final _formKey = GlobalKey<FormState>();

  static const String pathAssetUser = 'assets/images/user.png';
  final ImagePicker picker = ImagePicker();

  void onValidation() async {
    final currentState = _formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    try {
      await ref.read(singUpProvider.notifier).toCreateUser(context);
    } catch (e) {
      logger.e(e.toString());
      if (context.mounted) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final singUpData = ref.watch(singUpProvider);

    ref.listen<SingUpData>(singUpProvider, (prev, current) {
      if (current.statusCreatingUser != StatusCreatingUser.notStarted &&
          current.statusCreatingUser != StatusCreatingUser.success) {
        showMessageError(context, current.statusCreatingUser.message);
        return;
      }

      if (current.statusCreatingUser == StatusCreatingUser.success) {
        Navigator.of(context).pop();
      }
    });

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: singUpData.statusFlow ==
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
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            height: 250,
                            width: 250,
                            child: CircleAvatar(
                              //radius: 80,
                              maxRadius: 80,
                              backgroundImage: singUpData
                                      .pathProfileUser.isEmpty
                                  ? const AssetImage(pathAssetUser)
                                  : FileImage(File(singUpData.pathProfileUser))
                                      as ImageProvider,
                            ),
                          ),
                          Positioned(
                            bottom: 50,
                            right: -0,
                            child: IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  /* isScrollControlled: true,
                                  useSafeArea: true, */
                                  context: context,
                                  builder: (ctx) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            try {
                                              final XFile? photo =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.camera);
                                              if (photo != null) {
                                                ref
                                                    .read(
                                                        singUpProvider.notifier)
                                                    .setPathProfileUser(
                                                        photo.path);
                                              }
                                            } on PlatformException catch (e) {
                                              logger.e(
                                                  'Failed to pick image: $e');
                                            }
                                          },
                                          leading:
                                              const Icon(Icons.photo_camera),
                                          title: const Text('Take a picture'),
                                        ),
                                        const Divider(
                                          height: 2,
                                        ),
                                        ListTile(
                                          onTap: () async {
                                            Navigator.of(context).pop();
                                            try {
                                              final XFile? photo =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              if (photo != null) {
                                                ref
                                                    .read(
                                                        singUpProvider.notifier)
                                                    .setPathProfileUser(
                                                        photo.path);
                                              }
                                            } on PlatformException catch (e) {
                                              logger.e(
                                                  'Failed to pick image: $e');
                                            }
                                          },
                                          leading: const Icon(
                                              Icons.photo_size_select_actual),
                                          title: const Text('Select a picture'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.image_search,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: singUpData.fullName,
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
                                if (value == null) return;
                                ref
                                    .read(singUpProvider.notifier)
                                    .setFullName(value);
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
                            PasswordTextField(
                              initialValue: singUpData.password,
                              formKey: _formKey,
                              onSave: (value) {
                                if (value == null) return;
                                ref
                                    .read(singUpProvider.notifier)
                                    .setPassword(value);
                              },
                              labelText: 'password',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            PasswordTextField(
                              initialValue: singUpData.password,
                              formKey: _formKey,
                              onSave: (value) {
                                if (value == null) return;
                                ref
                                    .read(singUpProvider.notifier)
                                    .setConfirmPassword(value);
                              },
                              labelText: 'confirm password',
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

  void showMessageError(BuildContext context, String message) {
    errorDialog(context, () {
      ref
          .read(singUpProvider.notifier)
          .setStatusCreatingUser(StatusCreatingUser.notStarted);
    }, message);
  }
}
