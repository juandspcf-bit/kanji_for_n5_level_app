import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/quiz_details_score/quiz_details_score_landscape.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/quiz_details_score/quiz_details_score_portrait.dart';

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
