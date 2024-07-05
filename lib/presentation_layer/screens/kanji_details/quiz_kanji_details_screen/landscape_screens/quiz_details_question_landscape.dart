import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/score_quiz_details/quiz_details_score_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/last_score_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/quiz_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/score_quiz_details/quiz_score_details.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/score_quiz_details/visible_lottie_file/buttons_reset_quiz.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/score_quiz_details/visible_lottie_file/visible_lottie_file_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/example_audio_widget.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_examples/example_audio_widget_stream/example_audio_widget.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/section_screen_provider.dart';

class QuestionScreenLandscape extends ConsumerWidget {
  String formatText(String japanese) {
    final firstIndex = japanese.indexOf('（');
    return japanese.substring(0, firstIndex).trim();
  }

  const QuestionScreenLandscape({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizDetailData = ref.watch(quizDetailsProvider);
    return Padding(
      padding: const EdgeInsets.only(
        top: 0,
        bottom: 0,
        right: 30,
        left: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Question ${quizDetailData.indexQuestion + 1}'
                        ' of ${quizDetailData.kanjiFromApi!.example.length}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(100)),
                  child: AudioExampleButtonWidget(
                    audioQuestion: quizDetailData.audioQuestion,
                    sizeOval: 90,
                    sizeIcon: 60,
                    statusStorage: quizDetailData.kanjiFromApi!.statusStorage,
                    onPrimaryColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RadioListTile(
                      value: 0,
                      title: Text(
                          formatText(quizDetailData.answer1.hiraganaMeaning)),
                      subtitle: Text(quizDetailData.answer1.englishMeaning),
                      groupValue: quizDetailData.selectedAnswer,
                      onChanged: ((value) {
                        ref
                            .read(quizDetailsProvider.notifier)
                            .setAnswer(value ?? 4);
                      })),
                  RadioListTile(
                      value: 1,
                      title: Text(
                          formatText(quizDetailData.answer2.hiraganaMeaning)),
                      subtitle: Text(quizDetailData.answer2.englishMeaning),
                      groupValue: quizDetailData.selectedAnswer,
                      onChanged: ((value) {
                        ref
                            .read(quizDetailsProvider.notifier)
                            .setAnswer(value ?? 4);
                      })),
                  RadioListTile(
                      value: 2,
                      title: Text(
                          formatText(quizDetailData.answer3.hiraganaMeaning)),
                      subtitle: Text(quizDetailData.answer3.englishMeaning),
                      groupValue: quizDetailData.selectedAnswer,
                      onChanged: ((value) {
                        ref
                            .read(quizDetailsProvider.notifier)
                            .setAnswer(value ?? 4);
                      })),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    bool isReachedEnd =
                        ref.read(quizDetailsProvider.notifier).onNext();
                    if (isReachedEnd) {
                      final scores = ref.read(quizDetailsScoreProvider);

                      ref
                          .read(lastScoreDetailsProvider.notifier)
                          .setFinishedQuiz(
                            section: ref.read(sectionProvider),
                            uuid: ref.read(authServiceProvider).userUuid ?? '',
                            kanjiCharacter:
                                quizDetailData.kanjiFromApi!.kanjiCharacter,
                            countCorrects: scores.correctAnswers.length,
                            countIncorrect: scores.incorrectAnswers.length,
                            countOmitted: scores.omitted.length,
                          );

                      ref.read(quizDetailsProvider.notifier).resetValues();

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) {
                            ref
                                .read(visibleLottieFileProvider.notifier)
                                .setInitialDelay();
                            return const QuizScoreDetails();
                          },
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom().copyWith(
                    minimumSize: const WidgetStatePropertyAll(
                      Size.fromHeight(40),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_circle_right),
                  label: const Text('Next'),
                ),
                const SizedBox(
                  height: 10,
                ),
                const ToQuizSelectorButton(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
