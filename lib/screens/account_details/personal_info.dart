import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/account_details_state_provider.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/fetchin_data.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/updating_data.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/user_data.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/db_dialog_error_message.dart';

class PersonalInfo extends ConsumerWidget with MyDialogs {
  const PersonalInfo({super.key});

  Widget _dialogPassworRequest(BuildContext context, WidgetRef ref) {
    final dialogFormKey = GlobalKey<FormState>();
    var textPassword = '';
    void onValidatePassword(BuildContext context, WidgetRef ref) {
      final currenState = dialogFormKey.currentState;
      if (currenState == null) return;
      if (currenState.validate()) {
        currenState.save();
        ref.read(personalInfoProvider.notifier).setShowPasswordRequest(false);
        ref.read(personalInfoProvider.notifier).updateUserData(textPassword,
            () {
          errorDialog(context, () {}, 'errorrrrr');
        });

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
    final personalInfoData = ref.watch(personalInfoProvider);

    ref.listen<PersonalInfoData>(personalInfoProvider, (previous, current) {
      logger.d('status ${current.statusFetching} is called');
      if (current.showPasswordRequest) {
        logger.d('called password dialog');
        passworRequestDialog(context, ref);
      }

      if (current.statusFetching == 3) {
        logger.d('status 3 is called');
        errorDialog(
          context,
          () {
            ref.read(personalInfoProvider.notifier).setStatus(2);
            ref
                .read(personalInfoProvider.notifier)
                .setShowPasswordRequest(false);
          },
          'an error happend during updating process',
        );
      }

      if (current.statusFetching == 4) {
        successDialog(
          context,
          () {
            ref.read(personalInfoProvider.notifier).setStatus(2);
            ref
                .read(personalInfoProvider.notifier)
                .setShowPasswordRequest(false);
          },
          'succeful updating process',
        );
      }
    });

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: getWidgetBody(personalInfoData),
      ),
    );
  }
}
