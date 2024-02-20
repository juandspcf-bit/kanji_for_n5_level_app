import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_details_score_screen.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/quiz_details_provider.dart';

class InfoScore extends ConsumerWidget {
  const InfoScore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scores = ref.watch(quizDetailsScoreProvider);
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "This is the stats of your quiz",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 30,

            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.square,
                    color: Color.fromARGB(255, 229, 243, 33),
                  ),
                  Text(
                    'Correct\n answers:\n ${scores.correctAnswers.length}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.square,
                    color: Color.fromARGB(255, 194, 88, 27),
                  ),
                  Text(
                    'Incorrect\n answers:\n ${scores.incorrectAnwers.length}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.square,
                    color: Color.fromARGB(255, 33, 72, 243),
                  ),
                  Text(
                    'Omited\n answers:\n ${scores.omitted.length}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 5,
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                ref.read(quizDetailsProvider.notifier).resetValues();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              icon: const Icon(Icons.arrow_circle_right),
              label: const Text('Restart quiz'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: ElevatedButton.icon(
              onPressed: () {
                ref.read(quizDetailsProvider.notifier).resetValues();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              icon: const Icon(Icons.arrow_circle_right),
              label: const Text('To quiz type selector'),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
