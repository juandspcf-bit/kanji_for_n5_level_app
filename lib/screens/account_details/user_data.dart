import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/account_details_state_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/db_dialog_error_message.dart';

class UserData extends ConsumerWidget with MyDialogs {
  UserData({
    super.key,
    required this.accountDetailsData,
  });

  final PersonalInfoData accountDetailsData;

  final ImagePicker picker = ImagePicker();
  final String pathAssetUser = 'assets/images/user.png';
  final String pathErrorImage = 'assets/images/computer.png';

  final _formKey = GlobalKey<FormState>();

  Widget _dialogPassworRequest(BuildContext context, WidgetRef ref) {
    final dialogFormKey = GlobalKey<FormState>();
    var textPassword = '';
    void onValidatePassword(BuildContext context, WidgetRef ref) {
      final currenState = dialogFormKey.currentState;
      if (currenState == null) return;
      if (currenState.validate()) {
        currenState.save();
        ref.read(personalInfoProvider.notifier).setShowPasswordRequest(false);
        ref.read(personalInfoProvider.notifier).updateUserData(textPassword);

        Navigator.of(context).pop();
      }
    }

    return AlertDialog(
      title: const Text('Type your password'),
      content: Form(
        key: dialogFormKey,
        child: TextFormField(
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            label: Text('password'),
            suffixIcon: Icon(Icons.key),
            border: OutlineInputBorder(),
          ),
          validator: (text) {
            if (text != null && text.length >= 4 && text.length <= 20) {
              return null;
            } else {
              return 'Invalid password';
            }
          },
          onSaved: (value) {
            if (value == null) return;
            textPassword = value;
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            ref
                .read(personalInfoProvider.notifier)
                .setShowPasswordRequest(false);
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            onValidatePassword(context, ref);
          },
          child: const Text("Okay"),
        ),
      ],
    );
  }

  void passworRequestDialog(BuildContext buildContext, WidgetRef ref) {
    showGeneralDialog(
      context: buildContext,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: _dialogPassworRequest(buildContext, ref),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusConnectionData = ref.watch(statusConnectionProvider);

    ref.listen<PersonalInfoData>(personalInfoProvider, (previous, current) {
      if (current.showPasswordRequest) {
        passworRequestDialog(context, ref);
      }

      if (current.statusFetching == 3) {
        errorDialog(
          context,
          ref,
          'an error happend during updating process',
          const Icon(
            Icons.error_rounded,
            color: Colors.amberAccent,
            size: 70,
          ),
        );
      }
    });

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
                  onSaved: (text) {
                    if (text == null) return;
                    ref.read(personalInfoProvider.notifier).setEmail(text);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: statusConnectionData == ConnectivityResult.none
                      ? null
                      : () {
                          ref
                              .read(personalInfoProvider.notifier)
                              .onValidate(_formKey);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    minimumSize: const Size.fromHeight(40), // NEW
                  ),
                  child: const Text('Update your info'),
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
