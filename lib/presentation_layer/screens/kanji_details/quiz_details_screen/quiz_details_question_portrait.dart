import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/score_quiz_details/quiz_details_score_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/last_score_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/quiz_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/big_play_button.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/score_quiz_details/visible_lottie_file/buttoms_reset_quiz.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/score_quiz_details/visible_lottie_file/visible_lottie_file_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/section_screen_provider.dart';

class QuestionScreenPortrait extends ConsumerWidget {
  String formatText(String japanese) {
    final firtsIndex = japanese.indexOf('（');
    logger.d('the firtsIndex is $firtsIndex of $japanese');
    return japanese.substring(0, firtsIndex).trim();
  }

  const QuestionScreenPortrait({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizDetailData = ref.watch(quizDetailsProvider);
    return PopScope(
      onPopInvoked: (didPop) {},
      child: Padding(
        padding: const EdgeInsets.only(
          top: 0,
          bottom: 0,
          right: 30,
          left: 30,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Question ${quizDetailData.indexQuestion + 1} of ${quizDetailData.kanjiFromApi!.example.length}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(100)),
              child: BigPlayButton(
                sizeOval: 90,
                sizeIcon: 60,
                statusStorage: quizDetailData.kanjiFromApi!.statusStorage,
                audioQuestion: quizDetailData.audioQuestion,
              ),
            ),
            RadioListTile(
                value: 0,
                title: Text(formatText(quizDetailData.answer1.hiraganaMeaning)),
                subtitle: Text(quizDetailData.answer1.englishMeaning),
                groupValue: quizDetailData.selectedAnswer,
                onChanged: ((value) {
                  ref.read(quizDetailsProvider.notifier).setAnswer(value ?? 4);
                })),
            RadioListTile(
                value: 1,
                title: Text(formatText(quizDetailData.answer2.hiraganaMeaning)),
                subtitle: Text(quizDetailData.answer2.englishMeaning),
                groupValue: quizDetailData.selectedAnswer,
                onChanged: ((value) {
                  ref.read(quizDetailsProvider.notifier).setAnswer(value ?? 4);
                })),
            RadioListTile(
                value: 2,
                title: Text(formatText(quizDetailData.answer3.hiraganaMeaning)),
                subtitle: Text(quizDetailData.answer3.englishMeaning),
                groupValue: quizDetailData.selectedAnswer,
                onChanged: ((value) {
                  ref.read(quizDetailsProvider.notifier).setAnswer(value ?? 4);
                })),
            ElevatedButton.icon(
              onPressed: () {
                bool isReachedEnd =
                    ref.read(quizDetailsProvider.notifier).onNext();
                if (isReachedEnd) {
                  final scores = ref.read(quizDetailsScoreProvider);

                  ref.read(lastScoreDetailsProvider.notifier).setFinishedQuiz(
                        section: ref.read(sectionProvider),
                        uuid: authService.userUuid ?? '',
                        kanjiCharacter:
                            quizDetailData.kanjiFromApi!.kanjiCharacter,
                        countCorrects: scores.correctAnswers.length,
                        countIncorrects: scores.incorrectAnwers.length,
                        countOmited: scores.omitted.length,
                      );

                  ref.read(quizDetailsProvider.notifier).resetValues();
                  ref
                      .read(visibleLottieFileProvider.notifier)
                      .setInitialDelay();
                  ref
                      .read(quizDetailsProvider.notifier)
                      .setScreen(Screen.score);
                }
              },
              style: ElevatedButton.styleFrom().copyWith(
                minimumSize: const MaterialStatePropertyAll(
                  Size.fromHeight(40),
                ),
              ),
              icon: const Icon(Icons.arrow_circle_right),
              label: const Text('Next'),
            ),
            const ButtomsResetQuiz(),
          ],
        ),
      ),
    );
  }
}
