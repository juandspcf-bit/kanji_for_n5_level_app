import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/flash_card/flash_card_screen.dart';

class AnimatedQuizFlashCardsDetails extends ConsumerStatefulWidget {
  const AnimatedQuizFlashCardsDetails({
    super.key,
    required this.windowWidth,
  });
  final double windowWidth;

  @override
  ConsumerState<AnimatedQuizFlashCardsDetails> createState() =>
      _AnimatesQuizQuestionScreenState();
}

class _AnimatesQuizQuestionScreenState
    extends ConsumerState<AnimatedQuizFlashCardsDetails> {
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
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).width * 0.3,
            ),
            SvgPicture.asset(
              'assets/images/cards-fill-svgrepo-com.svg',
              height: 250,
              width: 250,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              semanticsLabel: '',
            ),
          ],
        ),
        AnimatedContainer(
          color: Theme.of(context).colorScheme.surface,
          duration: const Duration(milliseconds: 1000),
          transform: Matrix4.translationValues(offset, 0, 0),
          curve: Curves.easeInOutBack,
          child: const FlashCardsDetails(),
        ),
      ],
    );
  }
}
