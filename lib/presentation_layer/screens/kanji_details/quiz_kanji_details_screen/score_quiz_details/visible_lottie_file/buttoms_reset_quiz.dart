import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/services.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/flash_card/flash_card_quiz_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/last_score_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/last_score_flash_card_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/quiz_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/score_quiz_details/quiz_details_score_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/score_quiz_details/visible_lottie_file/visible_lottie_file_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/section_screen_provider.dart';

class ButtomsResetQuiz extends ConsumerWidget {
  const ButtomsResetQuiz({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
            bottom: 5,
          ),
          child: ElevatedButton.icon(
            onPressed: () {
              ref.read(visibleLottieFileProvider.notifier).reset();
              ref.read(quizDetailsProvider.notifier).resetValues();
              ref.read(quizDetailsProvider.notifier).setScreen(Screen.question);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
            ),
            icon: const Icon(Icons.arrow_circle_right),
            label: const Text('Restart quiz'),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: ToQuizSelectorButton(),
        ),
      ],
    );
  }
}

class ToQuizSelectorButton extends ConsumerWidget {
  const ToQuizSelectorButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizDetailsData = ref.watch(quizDetailsProvider);
    final flashCardState = ref.watch(flashCardProvider);

    return ElevatedButton.icon(
      onPressed: () async {
        final kanjiFromApi = quizDetailsData.kanjiFromApi;
        if (kanjiFromApi == null) return;
        if (quizDetailsData.currentScreenType == Screen.flashCards &&
            flashCardState.indexQuestion != 0) {
          ref.read(lastScoreFlashCardProvider.notifier).setFinishedFlashCard(
                kanjiCharacter: kanjiFromApi.kanjiCharacter,
                section: kanjiFromApi.section,
                uuid: ref.read(authServiceProvider).userUuid ?? '',
                countUnWatched: ref
                    .read(flashCardProvider.notifier)
                    .answers
                    .where((element) => !element)
                    .length,
              );
        } else if (quizDetailsData.currentScreenType == Screen.score) {
          final scores = ref.read(quizDetailsScoreProvider);

          ref.read(lastScoreDetailsProvider.notifier).setFinishedQuiz(
                section: ref.read(sectionProvider),
                uuid: ref.read(authServiceProvider).userUuid ?? '',
                kanjiCharacter: quizDetailsData.kanjiFromApi!.kanjiCharacter,
                countCorrects: scores.correctAnswers.length,
                countIncorrects: scores.incorrectAnwers.length,
                countOmited: scores.omitted.length,
              );
        }

        ref.read(quizDetailsProvider.notifier).resetValues();
        ref.read(visibleLottieFileProvider.notifier).reset();
        ref.read(quizDetailsProvider.notifier).setScreen(Screen.welcome);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
      ),
      icon: const Icon(Icons.home),
      label: const Text('To quiz type selector'),
    );
  }
}
