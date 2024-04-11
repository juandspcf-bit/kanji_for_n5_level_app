import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/password_widget.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/login_screen/email_widget.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/sign_up_screen/profile_picture_widget.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/sign_up_screen/sign_up_provider.dart';

class SingUpForm extends ConsumerWidget {
  SingUpForm({super.key});

  final _formKey = GlobalKey<FormState>();

  static const String pathAssetUser = 'assets/images/user.png';
  final ImagePicker picker = ImagePicker();

  void onValidation(BuildContext context, WidgetRef ref) async {
    final currentState = _formKey.currentState;
    if (currentState == null || !currentState.validate()) return;
    currentState.save();

    await ref.read(singUpProvider.notifier).toCreateUser();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final singUpData = ref.watch(singUpProvider);

    return PopScope(
      canPop:
          singUpData.statusFlow != StatusProcessingSignUpFlow.signUpProccessing,
      child: Scaffold(
        appBar: singUpData.statusFlow ==
                StatusProcessingSignUpFlow.signUpProccessing
            ? null
            : AppBar(),
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 15),
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
                        ProfilePictureWidget(
                          avatarWidget: CircleAvatarImage(
                            pathProfileUser: singUpData.pathProfileUser,
                            pathAssetUser: pathAssetUser,
                          ),
                          setPathProfileUser: (path) {
                            ref
                                .read(singUpProvider.notifier)
                                .setPathProfileUser(path);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                initialValue: singUpData.firtsName,
                                decoration: const InputDecoration().copyWith(
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.person),
                                  labelText: 'First Name',
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
                                      .setFirtsName(value);
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                initialValue: singUpData.lastName,
                                decoration: const InputDecoration().copyWith(
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.person),
                                  labelText: 'Last Name',
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
                                      .setLatName(value);
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
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);

                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            onValidation(context, ref);
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
      ),
    );
  }
}
