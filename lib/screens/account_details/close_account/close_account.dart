import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_contract/auth_service_contract.dart';
import 'package:kanji_for_n5_level_app/auth_flow.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/close_account/close_account_provider.dart';
import 'package:kanji_for_n5_level_app/screens/common_widgets/my_dialogs.dart';
import 'package:kanji_for_n5_level_app/text_asset/text_assets.dart';

class CloseAccountScreen extends ConsumerWidget with MyDialogs {
  const CloseAccountScreen({super.key});

  Widget _dialogPassworRequest(BuildContext context, WidgetRef ref) {
    final dialogFormKey = GlobalKey<FormState>();
    var textPassword = '';
    bool onValidatePassword(BuildContext context, WidgetRef ref) {
      final currenState = dialogFormKey.currentState;
      if (currenState == null) return false;
      final isValid = currenState.validate();
      if (isValid) currenState.save();
      return isValid;
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
                .read(closeAccountProvider.notifier)
                .setShowPasswordRequest(false);
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (onValidatePassword(context, ref)) {
              ref
                  .read(closeAccountProvider.notifier)
                  .setShowPasswordRequest(false);
              ref.read(closeAccountProvider.notifier).deleteUser(
                    password: textPassword,
                  );
            }

            Navigator.of(context).pop();
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
    final closeAccountData = ref.watch(closeAccountProvider);

    ref.listen<CloseAccountData>(closeAccountProvider, (prev, current) {
      if (current.deleteUserStatus == DeleteUserStatus.success) {
        ref.read(closeAccountProvider.notifier).resetStatus();
        successDialog(context, () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) {
                return const AuthFlow();
              },
            ),
          );
        }, succefullCloseAccountMessage);
      } else if (current.deleteUserStatus == DeleteUserStatus.error) {
        errorDialog(context, () {
          ref.read(closeAccountProvider.notifier).resetStatus();
        }, current.deleteRequestStatus.message);
      }
    });

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.warning,
              color: Colors.amber,
              size: 80,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    warningCloseAccountMessage,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.justify,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                FocusScopeNode currentFocus = FocusScope.of(context);

                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                passworRequestDialog(context, ref);
              },
              style: ElevatedButton.styleFrom().copyWith(
                minimumSize: const MaterialStatePropertyAll(
                  Size.fromHeight(40),
                ),
              ),
              child: const Text(buttonCloseAccountMessage),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 100,
              height: 100,
              child: AnimatedOpacity(
                opacity: closeAccountData.deleteRequestStatus ==
                        DeleteRequestStatus.process
                    ? 1
                    : 0,
                duration: const Duration(milliseconds: 300),
                child: const CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
