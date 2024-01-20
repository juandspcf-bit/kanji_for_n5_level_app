import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/flash_card/flash_card_quiz_provider.dart';

class FlashCardWidget extends ConsumerStatefulWidget {
  final String japanese;
  final String english;
  final double height;
  final double width;
  final int index;

  const FlashCardWidget({
    super.key,
    required this.japanese,
    required this.english,
    required this.height,
    required this.width,
    required this.index,
  });

  @override
  ConsumerState<FlashCardWidget> createState() => _FlashCardWidgetState();
}

class _FlashCardWidgetState extends ConsumerState<FlashCardWidget> {
  bool showFrontSide = true;

  Widget _buildFront(
    String japanese,
    BuildContext context,
  ) {
    final firtsIndex = japanese.indexOf('（');
    final lastIndex = japanese.indexOf('）');
    final subString = japanese.substring(firtsIndex + 1, lastIndex).trim();

    return Container(
      key: const ValueKey(true),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.0),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'What is the meaning of?',
                textAlign: TextAlign.center,
                maxLines: 2,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                subString,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRear(
    String japanese,
    String english,
    BuildContext context,
  ) {
    final firtsIndex = japanese.indexOf('（');
    final subString = japanese.substring(0, firtsIndex).trim();
    ref.read(flashCardProvider.notifier).answers[widget.index] = true;

    return Container(
      key: const ValueKey(false),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.0),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'The meaning is:',
              textAlign: TextAlign.center,
              maxLines: 2,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              subString,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              english,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget transitionBuilder(
      Widget widget1, Animation<double> animation, bool showFrontSide) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget1,
      builder: (context, widget2) {
        final isUnder = (ValueKey(showFrontSide) != widget2!.key);
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          origin: Offset(widget.width / 2, 0),
          transform: Matrix4.rotationY(value),
          child: widget1,
        );
      },
    );
  }

  Widget _buildFlipAnimation(
      String japanese, String english, BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        showFrontSide = !showFrontSide;
      }),
      child: Container(
        constraints: BoxConstraints.tight(Size(widget.width, widget.height)),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (Widget widget1, Animation<double> animation) {
            return transitionBuilder(widget1, animation, showFrontSide);
          },
          child: showFrontSide
              ? _buildFront(japanese, context)
              : _buildRear(japanese, english, context),
          layoutBuilder: (widget2, list) =>
              Stack(children: [widget2!, ...list]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildFlipAnimation(
      widget.japanese,
      widget.english,
      context,
    );
  }
}
