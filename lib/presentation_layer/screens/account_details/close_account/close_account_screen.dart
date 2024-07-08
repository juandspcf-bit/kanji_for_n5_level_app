import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/auth_service/auth_service_contract.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/close_account/close_account_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/my_dialogs.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/sign_in_screen/login_provider.dart';

class CloseAccountScreen extends ConsumerWidget with MyDialogs {
  const CloseAccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final closeAccountData = ref.watch(closeAccountProvider);

    ref.listen<CloseAccountData>(closeAccountProvider, (prev, current) {
      if (current.deleteUserStatus == DeleteUserStatus.success) {
        ref.read(toastServiceProvider).showMessage(
              context,
              context.l10n.emailsNotMach,
              Icons.check_circle,
              const Duration(seconds: 3),
              "",
              null,
            );

        if (context.mounted) {
          Navigator.pop(context);
          Navigator.pop(context);
        }
        ref.read(mainScreenProvider.notifier).resetMainScreenState();
        ref.read(loginProvider.notifier).resetData();
        ref
            .read(loginProvider.notifier)
            .setStatusLoggingFlow(StatusProcessingLoggingFlow.form);

/*         successDialog(context, () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (ctx) {
              return const AuthFlow();
            },
          ), (Route<dynamic> route) => route.isFirst);
        }, "successfully closed"); */
      } else if (current.deleteUserStatus == DeleteUserStatus.error ||
          current.deleteUserStatus == DeleteUserStatus.wrongPassword) {
        //errorDialog(context, () {}, current.deleteUserStatus.message);
        ref.read(toastServiceProvider).showMessage(
              context,
              current.deleteUserStatus.message,
              Icons.error,
              const Duration(seconds: 3),
              "",
              null,
            );
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
                        context.l10n.closeAccountTitle,
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
                    minimumSize: const WidgetStatePropertyAll(
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
                      : Text(context.l10n.closeAccount),
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
