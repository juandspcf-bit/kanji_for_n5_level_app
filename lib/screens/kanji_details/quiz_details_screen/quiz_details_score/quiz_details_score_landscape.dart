import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/quiz_details_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/quiz_details_score/barchar_landscape.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/quiz_details_score/info_score.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/quiz_details_score/visible_lottie_file.dart';

class QuizDetailsScoreLandscape extends ConsumerStatefulWidget {
  const QuizDetailsScoreLandscape({super.key});

  @override
  ConsumerState<QuizDetailsScoreLandscape> createState() => _QuizDetailsScore();
}

class _QuizDetailsScore extends ConsumerState<QuizDetailsScoreLandscape> {
  @override
  Widget build(BuildContext context) {
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
            alignment: Alignment.topCenter,
            children: [
              Row(
                children: [
                  InfoScore(),
                  BarChartLandscape(),
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
