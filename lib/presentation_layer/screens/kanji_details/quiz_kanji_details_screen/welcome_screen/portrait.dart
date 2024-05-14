import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/quiz_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/welcome_screen/welcome_kanji_details_quiz_screen.dart';

class WelcomeKanjiDetailsQuizScreenPortrait extends ConsumerWidget {
  const WelcomeKanjiDetailsQuizScreenPortrait({super.key});

  final welcomeMessage = 'Select the quiz type '
      'you would like to try.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizDetailsData = ref.watch(quizDetailsProvider);
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
            groupValue: quizDetailsData.selectedOption,
            onChanged: ((value) {
              ref.read(quizDetailsProvider.notifier).setOption(value);
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
            groupValue: quizDetailsData.selectedOption,
            onChanged: ((value) {
              ref.read(quizDetailsProvider.notifier).setOption(value);
            }),
          ),
          const LastFlashCardScore(),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              if (quizDetailsData.selectedOption == 0) {
                ref
                    .read(quizDetailsProvider.notifier)
                    .setScreen(Screen.question);
              } else if (quizDetailsData.selectedOption == 1) {
                ref
                    .read(quizDetailsProvider.notifier)
                    .setScreen(Screen.flashCards);
              }
              ref.read(quizDetailsProvider.notifier).setOption(2);
            },
            style: ElevatedButton.styleFrom().copyWith(
              minimumSize: const WidgetStatePropertyAll(
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
