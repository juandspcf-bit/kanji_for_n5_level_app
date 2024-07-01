import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/config_files/assets_paths.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/personal_info_update/persona_info_init_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/personal_info_update/personal_info_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/sign_up_screen/profile_picture_widget.dart';

class UserForm2 extends ConsumerWidget {
  UserForm2({
    super.key,
    required this.accountDetailsData,
  });

  final PersonalInfoDataInit accountDetailsData;

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

  void onValidate(WidgetRef ref) async {
    final currentFormState = _formKey.currentState;
    if (currentFormState == null) return;
    if (!currentFormState.validate()) return;
    currentFormState.save();
    if (ref.read(personalInfoProvider).birthdate == "") {
      ref
          .read(personalInfoProvider.notifier)
          .setBirthdate(accountDetailsData.birthdate);
    }
    ref.read(personalInfoProvider.notifier).updateUserData();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusConnectionData = ref.watch(statusConnectionProvider);
    final personalInfo = ref.watch(personalInfoProvider);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          if (personalInfo.pathProfileTemporal == "")
            ProfilePictureWidget(
              avatarWidget: CircularAvatarNetworkImage(
                  pathProfileUser: accountDetailsData.link,
                  pathErrorImage: pathAssetUser),
              setPathProfileUser: (path) {
                ref
                    .read(personalInfoProvider.notifier)
                    .setProfileTemporalPath(path);
              },
            )
          else
            ProfilePictureWidget(
              avatarWidget: CircleAvatarImage(
                pathProfileUser: personalInfo.pathProfileTemporal,
                pathAssetUser: pathAssetUser,
              ),
              setPathProfileUser: (path) {
                ref
                    .read(personalInfoProvider.notifier)
                    .setProfileTemporalPath(path);
              },
            ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: personalInfo.firstName != ""
                        ? personalInfo.firstName
                        : accountDetailsData.firstName,
                    decoration: const InputDecoration(
                      label: Text('First name'),
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
                      ref
                          .read(personalInfoProvider.notifier)
                          .setFirstName(text);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: personalInfo.lastName != ""
                        ? personalInfo.lastName
                        : accountDetailsData.lastName,
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
                      Text(
                          'Your Birthday: ${personalInfo.birthdate != "" ? personalInfo.birthdate : accountDetailsData.birthdate}'),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed:
                        statusConnectionData == ConnectionStatus.noConnected
                            ? null
                            : () {
                                if (personalInfo.updatingStatus !=
                                    PersonalInfoUpdatingStatus.updating) {
                                  onValidate(ref);
                                }
                              },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: personalInfo.updatingStatus ==
                            PersonalInfoUpdatingStatus.updating
                        ? SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        : const Text('Update your info'),
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
}
