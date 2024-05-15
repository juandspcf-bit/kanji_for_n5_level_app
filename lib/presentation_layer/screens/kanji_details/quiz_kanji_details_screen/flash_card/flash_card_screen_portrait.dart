import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/flash_card/flash_card_quiz_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/flash_card/flash_card_widget.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/score_quiz_details/visible_lottie_file/buttons_reset_quiz.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FlashCardScreenPortrait extends ConsumerStatefulWidget {
  const FlashCardScreenPortrait({
    super.key,
  });

  @override
  ConsumerState<FlashCardScreenPortrait> createState() =>
      _FlashCardScreenState();
}

class _FlashCardScreenState extends ConsumerState<FlashCardScreenPortrait> {
  final PageController controller = PageController();
  double index = 0;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final flashCardState = ref.watch(flashCardProvider);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 0,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Card ${flashCardState.indexQuestion + 1} of ${flashCardState.kanjiFromApi!.example.length}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 500,
            width: 300,
            child: PageView(
              controller: controller,
              onPageChanged: (indexPage) {
                ref.read(flashCardProvider.notifier).setIndex(indexPage);
              },
              children: [
                //TODO change the size when the screen is big
                for (int i = 0; i < flashCardState.japanese.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: FlashCardWidget(
                      japanese: flashCardState.japanese[i],
                      english: flashCardState.english[i],
                      width: 300 - 40,
                      height: 500,
                      index: i,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SmoothPageIndicator(
            controller: controller, // PageController
            count: flashCardState.japanese.length,
            effect: const ScaleEffect(), // your preferred effect
            onDotClicked: (index) {
              logger.d('$index');
              controller.jumpToPage(index);
            },
          ),
          const SizedBox(
            height: 50,
          ),
          const ToQuizSelectorButton(),
        ]),
      ),
    );
  }
}
