import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/last_score_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/last_score_flash_card_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/welcome_screen/landscape.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/welcome_screen/portrait.dart';

class QuizWelcomeDetails extends ConsumerWidget {
  const QuizWelcomeDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);
    return Orientation.portrait == orientation
        ? const WelcomeKanjiDetailsQuizScreenPortrait()
        : const WelcomeKanjiDetailsQuizScreenLandScape();
  }
}

class LastScoreAudioExampleScreen extends ConsumerWidget {
  const LastScoreAudioExampleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastScoreData = ref.watch(lastScoreDetailsProvider);

    return lastScoreData.when(
      data: (data) => Builder(builder: (context) {
        return data.isFinishedQuiz
            ? Text(
                'Last score: ${data.countCorrects} questions correct out of '
                '${data.countCorrects + data.countIncorrect + data.countOmitted}',
                style: Theme.of(context).textTheme.bodySmall,
              )
            : Text(
                'Not started the audio quiz!!',
                style: Theme.of(context).textTheme.bodySmall,
              );
      }),
      error: (error, stack) => Text(
        'Oops, something unexpected happened',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      loading: () => const CircularProgressIndicator(),
    );
  }
}

class LastFlashCardScore extends ConsumerWidget {
  const LastFlashCardScore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastScoreData = ref.watch(lastScoreFlashCardProvider);

    return lastScoreData.when(
      data: (data) => Builder(builder: (context) {
        logger.d(data);
        return data.allRevisedFlashCards
            ? Text(
                'You have revised all flash cards',
                style: Theme.of(context).textTheme.bodySmall,
              )
            : Text(
                'No revised the flash cards!!',
                style: Theme.of(context).textTheme.bodySmall,
              );
      }),
      error: (error, stack) => Text(
        'Oops, something unexpected happened',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
