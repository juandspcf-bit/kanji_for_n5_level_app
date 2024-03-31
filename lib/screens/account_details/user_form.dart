import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/config_files/assets_paths.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/personal_info/personal_info_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/screens/sign_up_screen/profile_picture_widget.dart';

class UserForm extends ConsumerWidget {
  UserForm({
    super.key,
    required this.accountDetailsData,
  });

  void _setDatePicker(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 100, 1, 1);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    if (pickedDate == null) return;
    ref.read(personalInfoProvider.notifier).setBirthdate(
        '${pickedDate.year}/${pickedDate.month}/${pickedDate.day}');
  }

  final PersonalInfoData accountDetailsData;

  void onValidate(WidgetRef ref) async {
    final currentFormState = _formKey.currentState;
    if (currentFormState == null) return;
    if (!currentFormState.validate()) return;
    currentFormState.save();

    ref.read(personalInfoProvider.notifier).updateUserData();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusConnectionData = ref.watch(statusConnectionProvider);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          getImageProfileWidget(accountDetailsData, ref),
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
                    initialValue: accountDetailsData.firstName,
                    decoration: const InputDecoration(
                      label: Text('Firts name'),
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
                    initialValue: accountDetailsData.lastName,
                    decoration: const InputDecoration(
                      label: Text('Last name'),
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
                      ref.read(personalInfoProvider.notifier).setLastName(text);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          _setDatePicker(context, ref);
                        },
                        icon: const Icon(Icons.calendar_month_outlined),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text('Your Birthday: ${accountDetailsData.birthdate}'),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: statusConnectionData == ConnectivityResult.none
                        ? null
                        : () {
                            onValidate(ref);
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
      ),
    );
  }

  Widget getImageProfileWidget(
      PersonalInfoData accountDetailsData, WidgetRef ref) {
    if (accountDetailsData.pathProfileTemporal.isNotEmpty) {
      return ProfilePictureWidget(
        avatarWidget: CircleAvatarImage(
          pathProfileUser: accountDetailsData.pathProfileTemporal,
          pathAssetUser: pathAssetUser,
        ),
        setPathProfileUser: (path) {
          ref.read(personalInfoProvider.notifier).setProfileTemporalPath(path);
        },
      );
    } else {
      return ProfilePictureWidget(
        avatarWidget: CircularAvatarNetworkImage(
            pathProfileUser: accountDetailsData.pathProfileUser,
            pathErrorImage: pathAssetUser),
        setPathProfileUser: (path) {
          ref.read(personalInfoProvider.notifier).setProfileTemporalPath(path);
        },
      );
    }
  }
}
