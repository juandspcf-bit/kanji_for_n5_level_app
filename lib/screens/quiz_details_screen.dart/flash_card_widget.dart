import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/flash_card_widget_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';

class FlashCardWidget extends ConsumerWidget {
  final String japanese;
  final String english;
  final double containerSize;

  const FlashCardWidget(
      {super.key,
      required this.japanese,
      required this.english,
      required this.containerSize});

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
    logger.d('the firtsIndex is $firtsIndex of $japanese');
    final subString = japanese.substring(0, firtsIndex).trim();

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
      Widget widget, Animation<double> animation, bool showFrontSide) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(showFrontSide) != widget!.key);
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          origin: Offset(containerSize / 2, 0),
          transform: Matrix4.rotationY(value),
          child: widget,
        );
      },
    );
  }

  Widget _buildFlipAnimation(String japanese, String english,
      bool showFrontSide, BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => ref.read(flashCardWidgetProvider.notifier).toggleState(),
      child: Container(
        constraints: BoxConstraints.tight(Size.square(containerSize)),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (Widget widget, Animation<double> animation) {
            return transitionBuilder(widget, animation, showFrontSide);
          },
          child: showFrontSide
              ? _buildFront(japanese, context)
              : _buildRear(japanese, english, context),
          layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flashCardWidget = ref.watch(flashCardWidgetProvider);
    return _buildFlipAnimation(
      japanese,
      english,
      flashCardWidget.showFrontSide,
      context,
      ref,
    );
  }
}
