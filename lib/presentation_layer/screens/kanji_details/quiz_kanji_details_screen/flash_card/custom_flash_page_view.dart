import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/flash_card/flash_card_quiz_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/flash_card/flash_card_widget.dart';

class CustomFlashPageView extends ConsumerWidget {
  final FlashCardData flashCardState;
  final int height;
  final PageController controller;

  const CustomFlashPageView({
    super.key,
    required this.flashCardState,
    required this.height,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height.toDouble(),
      width: 300,
      child: PageView(
        controller: controller,
        onPageChanged: (indexPage) {
          ref.read(flashCardProvider.notifier).setIndex(indexPage);
        },
        children: [
          for (int i = 0; i < flashCardState.japanese.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: FlashCardWidget(
                japanese: flashCardState.japanese[i],
                english: flashCardState.english[i],
                width: 300 - 40,
                height: height.toDouble(),
                index: i,
              ),
            ),
        ],
      ),
    );
  }
}
