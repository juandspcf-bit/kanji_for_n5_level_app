import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/quiz_details_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/score_quiz_details/barchar_landscape.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/score_quiz_details/info_score.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/score_quiz_details/visible_lottie_file/buttoms_reset_quiz.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/score_quiz_details/visible_lottie_file/visible_lottie_file.dart';

class QuizDetailsScorePortrait extends ConsumerWidget {
  const QuizDetailsScorePortrait({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      onPopInvoked: (didPop) {
        ref.read(quizDetailsProvider.notifier).resetValues();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your score'),
        ),
        body: const Padding(
          padding: EdgeInsets.only(
            top: 0,
            bottom: 0,
            right: 30,
            left: 30,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  InfoScore(),
                  SizedBox(
                    height: 20,
                  ),
                  BarChartLandscape(),
                  SizedBox(
                    height: 20,
                  ),
                  ButtomsResetQuiz(),
                ],
              ),
              VisibleLottieFile(),
            ],
          ),
        ),
      ),
    );
  }
}
