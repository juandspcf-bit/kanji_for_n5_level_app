import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/score_screen/button_score_kanji_list.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/score_screen/info_score_kanji_list.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/score_screen/screen_chart.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/score_screen/visible_lottie_file_kanji_list.dart';

class ScoreKanjiListQuizPortrait extends ConsumerWidget {
  const ScoreKanjiListQuizPortrait({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [
            SizedBox(
              height: 20,
            ),
            InfoScoreKanjiList(),
            SizedBox(
              height: 40,
            ),
            ScreenChart(),
            SizedBox(
              height: 40,
            ),
            ButtonScoreKanjiList(),
          ],
        ),
        VisibleLottieFileKanjiList(),
      ],
    );
  }
}
