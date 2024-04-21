import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/landscape_screens/quiz_details_question_landscape.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/quiz_details_question_portrait.dart';

class QuizQuestionDetails extends ConsumerWidget {
  const QuizQuestionDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);

    return Orientation.portrait == orientation
        ? const QuestionScreenPortrait()
        : const QuestionScreenLandscape();
  }
}
