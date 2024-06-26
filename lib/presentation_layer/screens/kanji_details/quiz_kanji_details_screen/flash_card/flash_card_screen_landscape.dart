import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/flash_card/flash_card_quiz_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/flash_card/flash_card_widget.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/score_quiz_details/visible_lottie_file/buttons_reset_quiz.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FlashCardScreenLandscape extends ConsumerStatefulWidget {
  const FlashCardScreenLandscape({
    super.key,
  });

  @override
  ConsumerState<FlashCardScreenLandscape> createState() =>
      _FlashCardScreenState();
}

class _FlashCardScreenState extends ConsumerState<FlashCardScreenLandscape> {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              SmoothPageIndicator(
                controller: controller,
                axisDirection: Axis.vertical, // PageController
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ToQuizSelectorButton(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: SizedBox(
              height: 250,
              width: 400,
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
                        width: 400 - 40,
                        height: 250,
                        index: i,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
