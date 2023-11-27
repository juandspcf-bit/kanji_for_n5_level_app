import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/account_details_state_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

class PersonalInfo extends ConsumerWidget {
  PersonalInfo({super.key});

  final ImagePicker picker = ImagePicker();
  final String pathAssetUser = 'assets/images/user.png';

  final _formKey = GlobalKey<FormState>();

  Widget getWidget(PersonalInfoData accountDetailsData, WidgetRef ref,
      BuildContext context) {
    if (accountDetailsData.statusFetching == 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Fetching data',
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
      );
    } else if (accountDetailsData.statusFetching == 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Updating data',
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
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              try {
                final XFile? photo =
                    await picker.pickImage(source: ImageSource.camera);
                if (photo != null) {
                  ref
                      .read(personalInfoProvider.notifier)
                      .setProfilePath(photo.path);
                }

                /*                       setState(() {
                            if (photo != null) {
                              pathProfileUser = photo.path;
                            }
                          }); */
              } on PlatformException catch (e) {
                logger.e('Failed to pick image: $e');
              }
            },
            child: CircleAvatar(
              radius: 80,
              backgroundImage: accountDetailsData.pathProfileUser.isEmpty
                  ? AssetImage(pathAssetUser)
                  : FileImage(File(accountDetailsData.pathProfileUser))
                      as ImageProvider,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: accountDetailsData.name,
                    decoration: const InputDecoration(
                      label: Text('Full name'),
                      suffixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (text) {
                      if (text != null && text.isNotEmpty && text.length > 2) {
                        return null;
                      } else {
                        return 'Please provide a not to short name';
                      }
                    },
                    onSaved: (text) {
                      if (text == null) return;
                      ref.read(personalInfoProvider.notifier).setName(text);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: accountDetailsData.email,
                    decoration: const InputDecoration(
                      label: Text('Your email'),
                      suffixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (text) {
                      if (text != null && EmailValidator.validate(text)) {
                        return null;
                      } else {
                        return 'Not a valid email';
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onValidate(ref);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      minimumSize: const Size.fromHeight(40), // NEW
                    ),
                    child: const Text('Save the info'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      );
    }
  }

  void onValidate(WidgetRef ref) async {
    final currentFormState = _formKey.currentState;
    if (currentFormState == null) return;
    if (!currentFormState.validate()) return;
    currentFormState.save();
    final accountDetailsData = ref.read(personalInfoProvider);
    ref.read(personalInfoProvider.notifier).setStatus(1);
    await FirebaseAuth.instance.currentUser!
        .updateDisplayName(accountDetailsData.name);
    await FirebaseAuth.instance.currentUser!
        .updateEmail(accountDetailsData.email);
    if (accountDetailsData.pathProfileUser.isNotEmpty) {
      try {
        final userPhoto = storageRef
            .child("userImages/${FirebaseAuth.instance.currentUser!.uid}.jpg");

        await userPhoto.putFile(File(accountDetailsData.pathProfileUser));
      } catch (e) {
        logger.e('error');
        logger.e(e);
      }
    }
    ref.read(personalInfoProvider.notifier).setStatus(2);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountDetailsData = ref.watch(personalInfoProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: getWidget(accountDetailsData, ref, context),
      ),
    );
  }
}
