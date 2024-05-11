import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/personal_info/personal_info_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/user_form.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/loading_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/my_dialogs.dart';

class PersonalInfo extends ConsumerWidget with MyDialogs {
  const PersonalInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalInfoData = ref.watch(personalInfoProvider);

    ref.listen<PersonalInfoData>(personalInfoProvider, (previous, current) {
      if (current.updatingStatus == PersonalInfoUpdatingStatus.error) {
        errorDialog(
          context,
          () {
            ref
                .read(personalInfoProvider.notifier)
                .setUpdatingStatus(PersonalInfoUpdatingStatus.noStarted);
            ref
                .read(personalInfoProvider.notifier)
                .setShowPasswordRequest(false);
          },
          'an error happend during updating process',
        );
      }

      if (current.updatingStatus == PersonalInfoUpdatingStatus.succes) {
        successDialog(
          context,
          () {
            ref
                .read(personalInfoProvider.notifier)
                .setUpdatingStatus(PersonalInfoUpdatingStatus.noStarted);
            ref
                .read(personalInfoProvider.notifier)
                .setShowPasswordRequest(false);
          },
          'succeful updating process',
        );
      }

      if (current.updatingStatus == PersonalInfoUpdatingStatus.noUpdate) {
        scaleDialog(
          context,
          () {
            ref
                .read(personalInfoProvider.notifier)
                .setUpdatingStatus(PersonalInfoUpdatingStatus.noStarted);
            ref
                .read(personalInfoProvider.notifier)
                .setShowPasswordRequest(false);
          },
          'nothing to update',
          const Icon(
            Icons.gpp_maybe_rounded,
            color: Colors.amberAccent,
            size: 70,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(),
      body: Builder(builder: (ctx) {
        if (personalInfoData.fetchingStatus ==
            PersonalInfoFetchinStatus.processing) {
          return const ProcessProgress(message: 'Fetching data');
        } /* else if (personalInfoData.updatingStatus ==
            PersonalInfoUpdatingStatus.updating) {
          return const ProcessProgress(message: 'Updating data');
        } */
        else {
          return UserForm(accountDetailsData: personalInfoData);
        }
      }),
    );
  }
}
