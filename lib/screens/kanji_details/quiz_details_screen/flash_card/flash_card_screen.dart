import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/flash_card/flash_card_quiz_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/flash_card/flash_card_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class FlassCardScreen extends ConsumerStatefulWidget {
  const FlassCardScreen({super.key, required this.kanjiFromApi});

  final KanjiFromApi kanjiFromApi;

  @override
  ConsumerState<FlassCardScreen> createState() => _FlassCardScreenState();
}

class _FlassCardScreenState extends ConsumerState<FlassCardScreen> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 0,
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Card ${flashCardState.indexQuestion + 1} of ${widget.kanjiFromApi.example.length}',
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
            })
      ]),
    );
  }
}
