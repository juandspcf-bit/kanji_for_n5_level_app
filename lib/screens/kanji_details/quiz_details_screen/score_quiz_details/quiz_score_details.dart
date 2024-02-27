import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/score_quiz_details/score_body_quiz_details_landscape.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/score_quiz_details/score_body_quiz_details_portrait.dart';

class QuizScoreDetails extends ConsumerWidget {
  const QuizScoreDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);
    logger.d('orientation is $orientation');
    return Orientation.portrait == orientation
        ? const QuizDetailsScorePortrait()
        : const QuizDetailsScoreLandscape();
  }
}
