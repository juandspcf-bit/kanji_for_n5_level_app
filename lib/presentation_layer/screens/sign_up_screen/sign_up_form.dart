import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/password_widget.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/sign_in_screen/email_widget.dart';
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
          singUpData.statusFlow != StatusProcessingSignUpFlow.signUpProcessing,
      child: Scaffold(
        appBar:
            singUpData.statusFlow == StatusProcessingSignUpFlow.signUpProcessing
                ? null
                : AppBar(),
        body: SafeArea(
          child: singUpData.statusFlow ==
                  StatusProcessingSignUpFlow.signUpProcessing
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.l10n.creatingUser,
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
                          context.l10n.signUpToKanjiForN5,
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
                                initialValue: singUpData.firstName,
                                decoration: const InputDecoration().copyWith(
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.person),
                                  labelText: context.l10n.firstName,
                                ),
                                keyboardType: TextInputType.name,
                                validator: (text) {
                                  if (text != null &&
                                      text.isNotEmpty &&
                                      text.length > 2) {
                                    return null;
                                  } else {
                                    return context.l10n.errorFirstName;
                                  }
                                },
                                onSaved: (value) {
                                  if (value == null) return;
                                  ref
                                      .read(singUpProvider.notifier)
                                      .setFirstName(value);
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
                                  labelText: context.l10n.lastName,
                                ),
                                keyboardType: TextInputType.name,
                                validator: (text) {
                                  if (text != null &&
                                      text.isNotEmpty &&
                                      text.length > 2) {
                                    return null;
                                  } else {
                                    return context.l10n.errorLastName;
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
                                labelText: context.l10n.passwordLogin,
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
                                labelText: context.l10n.confirmPassword,
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
                          child: Text(context.l10n.signUp),
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
