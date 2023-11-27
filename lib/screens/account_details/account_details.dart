import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/account_details_state_provider.dart';
import 'package:kanji_for_n5_level_app/providers/main_screen_provider.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/personal_info.dart';

class AccountDetails extends ConsumerWidget {
  const AccountDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Account details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      ref
                          .read(personalInfoProvider.notifier)
                          .getInitialPersonalInfoData();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) {
                          return PersonalInfo();
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
                    title: const Text('Full name, birthsday,'),
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
