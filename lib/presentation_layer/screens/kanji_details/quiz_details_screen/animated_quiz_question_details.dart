import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/quiz_details_question.dart';

class AnimatedQuizQuestionDetails extends ConsumerStatefulWidget {
  const AnimatedQuizQuestionDetails({
    super.key,
    required this.windowWidth,
  });
  final double windowWidth;

  @override
  ConsumerState<AnimatedQuizQuestionDetails> createState() =>
      _AnimatesQuizQuestionScreenState();
}

class _AnimatesQuizQuestionScreenState
    extends ConsumerState<AnimatedQuizQuestionDetails> {
  var offset = 0.0;

  @override
  initState() {
    super.initState();
    offset = widget.windowWidth;
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(milliseconds: 100), () {
      setState(() {
        offset = 0;
      });
    });
    return AnimatedContainer(
      duration: const Duration(milliseconds: 1000),
      transform: Matrix4.translationValues(offset, 0, 0),
      curve: Curves.easeInOutBack,
      child: const Placeholder(),
    );
  }
}
