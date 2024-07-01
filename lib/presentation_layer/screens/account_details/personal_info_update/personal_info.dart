import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/personal_info_update/persona_info_init_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/personal_info_update/personal_info_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/personal_info_update/user_form.dart';
<<<<<<< HEAD
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/loading_screen.dart';
=======
>>>>>>> new_personal_info_update
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/my_dialogs.dart';

class PersonalInfoScreen extends ConsumerWidget with MyDialogs {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalInfoData = ref.watch(personaInfoInitProvider);

    return PopScope(
      onPopInvoked: (didPop) {
        final isUpdating = ref.read(personalInfoProvider.notifier).isUpdating();
        if (!isUpdating) {
          ref.read(personalInfoProvider.notifier).reset();
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: personalInfoData.when(
          data: (data) => UserForm2(accountDetailsData: data),
          error: (_, __) => const Center(
            child: Text("Error fetching the data"),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
