import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/quiz_kanji_list_screen/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/quiz_kanji_list_screen/welcome_screen/last_score_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/text_asset/text_assets.dart';

class WelcomeKanjiListQuizScreenPortrait extends ConsumerWidget {
  const WelcomeKanjiListQuizScreenPortrait({super.key});

  final welcomeMessage = 'Guess the correct meaning by dragging '
      'the kanji to one of the empty boxes.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20,
        ),
        const LastScoreKanjiQuiz(),
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

class LastScoreKanjiQuiz extends ConsumerWidget {
  const LastScoreKanjiQuiz({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastScoreData = ref.watch(lastScoreKanjiQuizProvider);

    return lastScoreData.when(
      data: (data) => Builder(builder: (context) {
        return data.isFinishedQuiz
            ? Text(
                'You have completed this quiz with ${data.countCorrects}'
                ' questions correct\nout of ${data.countCorrects + data.countIncorrects + data.countOmited}',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              )
            : Text(
                noFinishedQuizMessage,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              );
      }),
      error: (error, stack) => Text(
        errorFinishedQuizMessage,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
