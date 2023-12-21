// ignore: implementation_imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/account_details/password_change.dart';

class PasswordChangeFlow extends ConsumerWidget {
  const PasswordChangeFlow({super.key});

  Widget getScreen() {
    return PassworChange();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: getScreen(),
      ),
    );
  }
}
