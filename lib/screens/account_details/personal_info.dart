import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/account_details_state_provider.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/fetchin_data.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/updating_data.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/user_data.dart';

class PersonalInfo extends ConsumerWidget {
  const PersonalInfo({super.key});

  Widget getWidgetBody(PersonalInfoData accountDetailsData) {
    if (accountDetailsData.statusFetching == 0) {
      return const FetchingData();
    } else if (accountDetailsData.statusFetching == 1) {
      return const UpdatingData();
    } else {
      return UserData(accountDetailsData: accountDetailsData);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountDetailsData = ref.watch(personalInfoProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: getWidgetBody(accountDetailsData),
      ),
    );
  }
}
