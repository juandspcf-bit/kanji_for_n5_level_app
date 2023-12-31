import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/select_quiz_details_screen.dart';

class WelcomeKanjiDetailsQuizScreen extends ConsumerWidget {
  const WelcomeKanjiDetailsQuizScreen({super.key});

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
            title: const Text('Multi optional answers'),
            groupValue: screenNumber.selectedOption,
            onChanged: ((value) {
              ref.read(selectQuizDetailsProvider.notifier).setOption(value);
            }),
          ),
          RadioListTile(
            value: 1,
            title: const Text('Flash cards'),
            groupValue: screenNumber.selectedOption,
            onChanged: ((value) {
              ref.read(selectQuizDetailsProvider.notifier).setOption(value);
            }),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(selectQuizDetailsProvider.notifier).selectScreen();
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
