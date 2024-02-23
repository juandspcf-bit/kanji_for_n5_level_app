import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/welcome_screen/welcome_kanji_quiz_screen_landscape.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/welcome_screen/welcome_kanji_quiz_screen_portrait.dart';

class WelcomeKanjiListQuizScreen extends ConsumerWidget {
  const WelcomeKanjiListQuizScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);
    return Orientation.portrait == orientation
        ? const WelcomeKanjiListQuizScreenPortrait()
        : const WelcomeKanjiListQuizScreenLandscape();
  }
}
