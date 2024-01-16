import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/welcome_screen/last_score_provider.dart';

class WelcomeKanjiListQuizScreen extends ConsumerWidget {
  const WelcomeKanjiListQuizScreen({super.key});

  final welcomeMessage = 'Guess the correct meaning by dragging '
      'the kanji to one of the empty boxes.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const LastScore(),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 250,
          child: Image.asset(
            'assets/images/quiz.png',
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
    );
  }
}

class LastScore extends ConsumerWidget {
  const LastScore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastScoreData = ref.watch(lastScoreProvider);

    return lastScoreData.when(
      data: (data) => Builder(builder: (context) {
        logger.d('data ${data.section}');
        return data.isFinishedKanjiQuizz
            ? Text(
                'Hello you have completed this quiz ${data.countCorrects}, ${data.countIncorrects}',
                style: Theme.of(context).textTheme.titleLarge,
              )
            : Text(
                'Hello complete de quiz!!',
                style: Theme.of(context).textTheme.titleLarge,
              );
      }),
      error: (error, stack) => Text(
        'Oops, something unexpected happened',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
