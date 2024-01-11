import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/personal_info/personal_info_provider.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/user_data.dart';
import 'package:kanji_for_n5_level_app/screens/common_screens.dart/loading_screen.dart';
import 'package:kanji_for_n5_level_app/screens/common_widgets/my_dialogs.dart';

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
        Navigator.of(context).pop();
        ref.read(personalInfoProvider.notifier).setShowPasswordRequest(false);
        ref.read(personalInfoProvider.notifier).updateUserData(
              textPassword,
            );
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
    if (accountDetailsData.fetchingStatus ==
        PersonalInfoFetchinStatus.processing) {
      return const ProcessProgress(message: 'Fetching data');
    } else if (accountDetailsData.updatingStatus ==
        PersonalInfoUpdatingStatus.updating) {
      return const ProcessProgress(message: 'Updating data');
    } else {
      return UserData(accountDetailsData: accountDetailsData);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personalInfoData = ref.watch(personalInfoProvider);

    ref.listen<PersonalInfoData>(personalInfoProvider, (previous, current) {
      if (current.showPasswordRequest) {
        logger.d('called password dialog');
        passworRequestDialog(context, ref);
      }

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
      body: getWidgetBody(personalInfoData),
    );
  }
}
