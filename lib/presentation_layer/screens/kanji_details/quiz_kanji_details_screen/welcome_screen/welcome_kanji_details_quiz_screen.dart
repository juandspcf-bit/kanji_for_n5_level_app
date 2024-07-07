import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
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
                '${context.l10n.lastScore} ${data.countCorrects} ${context.l10n.questionsCorrectOutOf} '
                '${data.countCorrects + data.countIncorrect + data.countOmitted}',
                style: Theme.of(context).textTheme.bodySmall,
              )
            : Text(
                context.l10n.notStartedTheAudioQuiz,
                style: Theme.of(context).textTheme.bodySmall,
              );
      }),
      error: (error, stack) => Text(
        context.l10n.errorDetailsQuiz,
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
                context.l10n.allRevisedFlashcards,
                style: Theme.of(context).textTheme.bodySmall,
              )
            : Text(
                context.l10n.notRevisedFlashcards,
                style: Theme.of(context).textTheme.bodySmall,
              );
      }),
      error: (error, stack) => Text(
        context.l10n.errorDetailsQuiz,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
