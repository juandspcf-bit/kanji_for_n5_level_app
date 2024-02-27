import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/score_screen/info_score_kanji_list.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/score_screen/screen_chart.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/score_screen/visible_lottie_file_kanji_list.dart';

class ScoreKanjiListQuizPortrait extends ConsumerWidget {
  const ScoreKanjiListQuizPortrait({
    super.key,
    required this.countCorrects,
    required this.countIncorrects,
    required this.countOmited,
    required this.resetTheQuiz,
  });

  final int countCorrects;
  final int countIncorrects;
  final int countOmited;
  final Function() resetTheQuiz;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const InfoScoreKanjiList(),
            const SizedBox(
              height: 40,
            ),
            const ScreenChart(),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(quizDataValuesProvider.notifier).resetTheQuiz();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text('Restart quiz'),
            )
          ],
        ),
        const VisibleLottieFileKanjiList(),
      ],
    );
  }
}
