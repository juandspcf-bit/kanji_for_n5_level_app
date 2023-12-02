import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_kanji_list_provider.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  final welcomeMessage = 'Guess the correct meaning by dragging '
      'the kanji to one of the empty boxes.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/quiz.png'),
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
          ElevatedButton(
            onPressed: () {
              ref.read(quizDataValuesProvider.notifier).setScreen(Screens.quiz);
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
