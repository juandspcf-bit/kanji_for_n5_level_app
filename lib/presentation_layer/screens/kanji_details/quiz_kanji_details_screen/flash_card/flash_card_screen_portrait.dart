import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/flash_card/custom_flash_page_view.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/flash_card/flash_card_quiz_provider.dart';
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
    final sizeLevel = getScreenSizeHeight(context);

    var height = 350;
    if (sizeLevel == ScreenSizeHeight.normal) height = 500;

    final flashCardState = ref.watch(flashCardProvider);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${context.l10n.card} ${flashCardState.indexQuestion + 1} of ${flashCardState.kanjiFromApi!.example.length}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomFlashPageView(
              flashCardState: flashCardState,
              height: height,
              controller: controller,
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
          ],
        ),
      ),
    );
  }
}
