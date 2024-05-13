import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/personal_info_update/personal_info_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/user_form.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/loading_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/my_dialogs.dart';

class PersonalInfo extends ConsumerWidget with MyDialogs {
  const PersonalInfo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalInfoData = ref.watch(personalInfoProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Builder(builder: (ctx) {
        if (personalInfoData.fetchingStatus ==
            PersonalInfoFetchingStatus.processing) {
          return const ProcessProgress(message: 'Fetching data');
        } else {
          return UserForm(accountDetailsData: personalInfoData);
        }
      }),
    );
  }
}
