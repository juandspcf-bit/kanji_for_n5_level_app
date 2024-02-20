import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/select_quiz_details_screen.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/flash_card/flash_card_screen.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/quiz_details_question.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/welcome_screen/welcome_kanji_details_quiz_screen.dart';

class WelcomeKanjiDetailsQuizScreenPortrait extends ConsumerWidget {
  const WelcomeKanjiDetailsQuizScreenPortrait(
      {super.key, required this.kanjiFromApi});

  final KanjiFromApi kanjiFromApi;

  final welcomeMessage = 'Select the quiz type '
      'you would like to try.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenNumber = ref.watch(selectQuizDetailsProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 250,
            child: Image.asset(
              'assets/images/quiz2.png',
              fit: BoxFit.fitHeight,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  welcomeMessage,
                  style: Theme.of(context).textTheme.titleLarge,
                  softWrap: false,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          RadioListTile(
            value: 0,
            title: Text(
              'Multi optional answers',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            groupValue: screenNumber.selectedOption,
            onChanged: ((value) {
              ref.read(selectQuizDetailsProvider.notifier).setOption(value);
            }),
          ),
          const LastScoreAudioExampleScreen(),
          const SizedBox(
            height: 20,
          ),
          RadioListTile(
            value: 1,
            title: Text('Flash cards',
                style: Theme.of(context).textTheme.bodyLarge),
            groupValue: screenNumber.selectedOption,
            onChanged: ((value) {
              ref.read(selectQuizDetailsProvider.notifier).setOption(value);
            }),
          ),
          const LastFlashCardScore(),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              //ref.read(selectQuizDetailsProvider.notifier).selectScreen();
              if (ref.read(selectQuizDetailsProvider).selectedOption == 0) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) {
                    return QuizDetailsScreen(kanjiFromApi: kanjiFromApi);
                  }),
                );
              } else if (ref.read(selectQuizDetailsProvider).selectedOption ==
                  1) {
                Navigator.of(context).push(MaterialPageRoute(builder: (cxt) {
                  return FlashCardScreen(kanjiFromApi: kanjiFromApi);
                }));
              }
              ref.read(selectQuizDetailsProvider.notifier).setOption(2);
            },
            style: ElevatedButton.styleFrom().copyWith(
              minimumSize: const MaterialStatePropertyAll(
                Size.fromHeight(40),
              ),
            ),
            child: const Text('Start the quiz'),
          )
        ],
      ),
    );
  }
}
