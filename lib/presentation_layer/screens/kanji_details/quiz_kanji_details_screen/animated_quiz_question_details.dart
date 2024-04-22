import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/quiz_details_question.dart';

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
    final orientation = MediaQuery.orientationOf(context);
    Timer(const Duration(milliseconds: 200), () {
      if (context.mounted) {
        setState(
          () {
            offset = 0;
          },
        );
      }
    });
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          mainAxisAlignment: Orientation.portrait == orientation
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            SizedBox(
              height: Orientation.portrait == orientation
                  ? MediaQuery.sizeOf(context).width * 0.3
                  : 0,
            ),
            Image.asset(
              'assets/images/kanji-study-svgrepo-com.png',
              height: 250,
              width: 250,
            ),
          ],
        ),
        AnimatedContainer(
          //
          color: Theme.of(context).colorScheme.surface,
          duration: const Duration(milliseconds: 1000),
          transform: Matrix4.translationValues(offset, 0, 0),
          curve: Curves.easeInOutBack,
          child: const QuizQuestionDetails(),
        ),
      ],
    );
  }
}
