import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/score_screen/score_body_kanji_list_landscape.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/score_screen/score_body_kanji_list_portrait.dart';

class ScoreBodyQuizKanjiList extends ConsumerWidget {
  const ScoreBodyQuizKanjiList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);
    return Orientation.portrait == orientation
        ? const ScoreKanjiListQuizPortrait()
        : const ScoreKanjiListQuizLandscape();
  }
}
