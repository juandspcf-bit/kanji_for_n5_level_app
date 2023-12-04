import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/select_quiz_details_screen.dart';

class WelcomeQuizDetailsScreen extends ConsumerWidget {
  const WelcomeQuizDetailsScreen({super.key});

  final welcomeMessage = 'Select the quiz type '
      'you would like to try.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenNumber = ref.watch(selectQuizDetailsProvider);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('assets/images/quiz2.png'),
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
              height: 20,
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
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if (screenNumber.selectedOption == 0) {
                  ref
                      .read(selectQuizDetailsProvider.notifier)
                      .setScreen(ScreensQuizDetail.quizSelections);
                } else {
                  ref
                      .read(selectQuizDetailsProvider.notifier)
                      .setScreen(ScreensQuizDetail.quizFlashCard);
                }
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
      ),
    );
  }
}