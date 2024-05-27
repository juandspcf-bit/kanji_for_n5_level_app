import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/change_email/change_email_flow.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/close_account/close_account_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/close_account/close_account_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/personal_info_update/personal_info_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/send_feedback/send_feedback_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/sign_in_screen/login_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/password_change/password_change_flow_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/password_change/password_change_flow.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/account_details/personal_info_update/personal_info.dart';

class AccountDetails extends ConsumerWidget {
  const AccountDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      ref.read(personalInfoProvider.notifier).resetData();
                      ref.read(personalInfoProvider.notifier).fetchUserData();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) {
                          return const PersonalInfo();
                        }),
                      );
                    },
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: OutlineInputBorder(
                      borderSide:
                          const BorderSide().copyWith(color: Colors.white30),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                    ),
                    title: const Text('Your data'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) {
                          return const EmailChangeFlow();
                        }),
                      );
                    },
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: OutlineInputBorder(
                      borderSide:
                          const BorderSide().copyWith(color: Colors.white30),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                    ),
                    title: const Text('Change Email'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    onTap: () {
                      ref
                          .read(passwordChangeFlowProvider.notifier)
                          .resetState();
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) {
                        return const PasswordChangeFlow();
                      }));
                    },
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: OutlineInputBorder(
                      borderSide:
                          const BorderSide().copyWith(color: Colors.white30),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                    ),
                    title: const Text('Change password'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (ctx) {
                        return const SendFeedBack();
                      }));
                    },
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: OutlineInputBorder(
                      borderSide:
                          const BorderSide().copyWith(color: Colors.white30),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                    ),
                    title: const Text('Send Feedback'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    onTap: () async {
                      ref.read(loginProvider.notifier).resetData();
                      ref.read(loginProvider.notifier).setStatusLoggingFlow(
                            StatusProcessingLoggingFlow.form,
                          );
                      await ref.read(authServiceProvider).singOut();
                      await Future.delayed(const Duration(milliseconds: 200));
                      ref
                          .read(mainScreenProvider.notifier)
                          .resetMainScreenState();

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: OutlineInputBorder(
                      borderSide:
                          const BorderSide().copyWith(color: Colors.white30),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                    ),
                    title: const Text('Logout'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    onTap: () async {
                      ref.read(closeAccountProvider.notifier).resetStatus();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) {
                          return const CloseAccountScreen();
                        }),
                      );
                    },
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: OutlineInputBorder(
                      borderSide:
                          const BorderSide().copyWith(color: Colors.white30),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12.0)),
                    ),
                    title: const Text('Close Account'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
