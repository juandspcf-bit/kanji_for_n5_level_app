import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kanji_for_n5_level_app/providers/account_details_state_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

class UserData extends ConsumerWidget {
  UserData({
    super.key,
    required this.accountDetailsData,
  });

  final PersonalInfoData accountDetailsData;

  final ImagePicker picker = ImagePicker();
  final String pathAssetUser = 'assets/images/user.png';
  final String pathErrorImage = 'assets/images/computer.png';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    .setProfileTemporalPath(photo.path);
              }
            } on PlatformException catch (e) {
              logger.e('Failed to pick image: $e');
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(300),
            child: getImageProfileWidget(accountDetailsData),
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
                    ref
                        .read(personalInfoProvider.notifier)
                        .onValidate(_formKey, ref);
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

  Widget getImageProfileWidget(PersonalInfoData accountDetailsData) {
    if (accountDetailsData.pathProfileUser.isNotEmpty) {
      return CachedNetworkImage(
        width: 128,
        height: 128,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CircularProgressIndicator(),
        imageUrl: accountDetailsData.pathProfileUser,
        errorWidget: (context, url, error) => Image.asset(pathErrorImage),
      );
    } else if (accountDetailsData.pathProfileTemporal.isNotEmpty) {
      return FadeInImage(
          width: 128,
          height: 128,
          fit: BoxFit.cover,
          placeholder: AssetImage(pathAssetUser),
          image: FileImage(File(accountDetailsData.pathProfileTemporal)));
    } else {
      return FadeInImage(
          width: 128,
          height: 128,
          fit: BoxFit.cover,
          placeholder: AssetImage(pathAssetUser),
          image: AssetImage(pathAssetUser));
    }
  }
}
