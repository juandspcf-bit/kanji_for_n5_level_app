import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/close_account/close_account.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/close_account/close_account_provider.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/personal_info/personal_info_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/login_screen/login_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/providers/password_change_flow_provider.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/password_change_flow.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/personal_info/personal_info.dart';

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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        ref.read(personalInfoProvider.notifier).resetData();
                        ref
                            .read(personalInfoProvider.notifier)
                            .getInitialPersonalInfoData();
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) {
                            return const PersonalInfo();
                          }),
                        );
                      },
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      shape: OutlineInputBorder(
                        borderSide:
                            const BorderSide().copyWith(color: Colors.white30),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0)),
                      ),
                      title: const Text('Name, email,'),
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      shape: OutlineInputBorder(
                        borderSide:
                            const BorderSide().copyWith(color: Colors.white30),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0)),
                      ),
                      title: const Text('Password'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        ref
                            .read(mainScreenProvider.notifier)
                            .resetMainScreenState();
                        ref.read(loginProvider.notifier).resetData();
                        ref.read(loginProvider.notifier).setStatusLoggingFlow(
                            StatusProcessingLoggingFlow.form);
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
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
      ),
    );
  }
}
