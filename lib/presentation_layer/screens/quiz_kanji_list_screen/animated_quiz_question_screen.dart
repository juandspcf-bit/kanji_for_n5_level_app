import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/quiz_kanji_list_screen/quiz_screen/quiz_question_screen.dart';

class AnimatesQuizQuestionScreen extends ConsumerStatefulWidget {
  const AnimatesQuizQuestionScreen({
    super.key,
    required this.windowWidth,
  });
  final double windowWidth;

  @override
  ConsumerState<AnimatesQuizQuestionScreen> createState() =>
      _AnimatesQuizQuestionScreenState();
}

class _AnimatesQuizQuestionScreenState
    extends ConsumerState<AnimatesQuizQuestionScreen> {
  var offset = 0.0;

  @override
  initState() {
    super.initState();
    offset = widget.windowWidth;
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(milliseconds: 200), () {
      setState(() {
        offset = 0;
      });
    });
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      transform: Matrix4.translationValues(offset, 0, 0),
      child: const QuizQuestionScreen(),
    );
  }
}
