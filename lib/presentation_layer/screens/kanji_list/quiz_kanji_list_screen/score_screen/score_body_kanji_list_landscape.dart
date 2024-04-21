import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/score_screen/base_widgets/button_score_kanji_list.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/score_screen/base_widgets/info_score_kanji_list.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/score_screen/base_widgets/bar_chart_score_kanji_list.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/score_screen/base_widgets/visible_lottie_file_kanji_list.dart';

class ScoreKanjiListQuizLandscape extends ConsumerWidget {
  const ScoreKanjiListQuizLandscape({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InfoScoreKanjiList(),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonScoreKanjiList(),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: ScreenChart(),
            ),
          ],
        ),
        VisibleLottieFileKanjiList(),
      ],
    );
  }
}
