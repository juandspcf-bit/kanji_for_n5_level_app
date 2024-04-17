import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/score_quiz_details/barchar_landscape.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/score_quiz_details/info_score.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/score_quiz_details/visible_lottie_file/buttoms_reset_quiz.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/score_quiz_details/visible_lottie_file/visible_lottie_file.dart';

class QuizDetailsScoreLandscape extends ConsumerWidget {
  const QuizDetailsScoreLandscape({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.only(
        top: 0,
        bottom: 0,
        right: 30,
        left: 30,
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    InfoScore(),
                    ButtomsResetQuiz(),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: BarChartLandscape(),
              ),
            ],
          ),
          VisibleLottieFile(),
        ],
      ),
    );
  }
}
