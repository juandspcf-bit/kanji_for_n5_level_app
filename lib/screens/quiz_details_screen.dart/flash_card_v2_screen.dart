import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/flash_card_quiz_provider.dart';
import 'package:kanji_for_n5_level_app/providers/flash_card_widget_provider.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_details_screen.dart/flash_card_widget.dart';

class FlassCardV2Screen extends ConsumerWidget {
  FlassCardV2Screen({super.key, required this.kanjiFromApi});

  final KanjiFromApi kanjiFromApi;
  //final PageController controller = PageController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flashCardState = ref.watch(flashCardProvider);
    return Expanded(
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
                'Question ${flashCardState.indexQuestion + 1} of ${kanjiFromApi.example.length}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //TODO change the size when the screen is big
              FlashCardWidget(
                japanese: flashCardState.japanese[flashCardState.indexQuestion],
                english: flashCardState.english[flashCardState.indexQuestion],
                containerSize: 300,
              ),
            ],
          ),

/*           Container(
            height: 300,
            width: 300,
            child: PageView(
              controller: controller,
              children: [
                //TODO change the size when the screen is big
                for (int i = 0; i < flashCardState.japanese.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: FlashCardWidget(
                      japanese: flashCardState.japanese[i],
                      english: flashCardState.english[i],
                      containerSize: 300 - 40,
                    ),
                  ),
              ],
            ),
          ), */
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(flashCardProvider.notifier).incrementIndex();
              ref.read(flashCardWidgetProvider.notifier).restartSide();
            },
            style: ElevatedButton.styleFrom().copyWith(
              minimumSize: const MaterialStatePropertyAll(
                Size.fromHeight(40),
              ),
            ),
            icon: const Icon(Icons.arrow_circle_right),
            label: Text(ref.read(flashCardProvider.notifier).isTheLastQuestion()
                ? 'Restart the quiz'
                : 'Next'),
          )
        ]),
      ),
    );
  }
}
