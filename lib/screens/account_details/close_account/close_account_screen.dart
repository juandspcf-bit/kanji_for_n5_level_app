import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_contract/auth_service_contract.dart';
import 'package:kanji_for_n5_level_app/screens/auth_flow/auth_flow.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/close_account/close_account_provider.dart';
import 'package:kanji_for_n5_level_app/screens/common_widgets/my_dialogs.dart';
import 'package:kanji_for_n5_level_app/text_asset/text_assets.dart';

class CloseAccountScreen extends ConsumerWidget with MyDialogs {
  const CloseAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final closeAccountData = ref.watch(closeAccountProvider);

    ref.listen<CloseAccountData>(closeAccountProvider, (prev, current) {
      if (current.deleteUserStatus == DeleteUserStatus.success) {
        successDialog(context, () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (ctx) {
              return const AuthFlow();
            },
          ), (Route<dynamic> route) => route.isFirst);
        }, succefullCloseAccountMessage);
      } else if (current.deleteUserStatus == DeleteUserStatus.error ||
          current.deleteUserStatus == DeleteUserStatus.wrongPassword) {
        errorDialog(context, () {}, current.deleteUserStatus.message);
      }
    });

    return PopScope(
      canPop:
          closeAccountData.deleteRequestStatus != DeleteRequestStatus.process,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
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

                    ref.read(closeAccountProvider.notifier).resetStatus();
                    showPasswordRequestTextField(
                        context: context,
                        ref: ref,
                        okayAction: (String password) {
                          ref
                              .read(closeAccountProvider.notifier)
                              .setShowPasswordRequest(false);
                          ref.read(closeAccountProvider.notifier).deleteUser(
                                password: password,
                              );
                        },
                        cancelAction: () {
                          ref
                              .read(closeAccountProvider.notifier)
                              .setShowPasswordRequest(false);
                        });
                  },
                  style: ElevatedButton.styleFrom().copyWith(
                    minimumSize: const MaterialStatePropertyAll(
                      Size.fromHeight(40),
                    ),
                  ),
                  child: closeAccountData.deleteRequestStatus ==
                          DeleteRequestStatus.process
                      ? SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        )
                      : const Text(buttonCloseAccountMessage),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
