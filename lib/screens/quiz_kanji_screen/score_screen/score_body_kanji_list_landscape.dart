import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/score_screen/info_score_kanji_list.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/score_screen/screen_chart.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/score_screen/visible_lottie_file_kanji_list.dart';

class ScoreKanjiListQuizLandscape extends ConsumerWidget {
  const ScoreKanjiListQuizLandscape({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
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
                  const InfoScoreKanjiList(),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(quizDataValuesProvider.notifier).resetTheQuiz();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                    ),
                    child: const Text('Restart quiz'),
                  ),
                ],
              ),
            ),
            const Expanded(
              flex: 3,
              child: ScreenChart(),
            ),
          ],
        ),
        const VisibleLottieFileKanjiList(),
      ],
    );
  }
}
