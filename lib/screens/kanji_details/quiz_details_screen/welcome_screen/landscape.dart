import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/select_quiz_details_screen.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/flash_card/flash_card_screen.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/last_score_details_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/last_score_flash_card_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/quiz_details_question.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/quiz_details_question_portrait.dart';

class WelcomeKanjiDetailsQuizScreenLandScape extends ConsumerWidget {
  const WelcomeKanjiDetailsQuizScreenLandScape(
      {super.key, required this.kanjiFromApi});

  final KanjiFromApi kanjiFromApi;

  final welcomeMessage = 'Select the quiz type '
      'you would like to try.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sizeScreen = getScreenSizeWidth(context);
    int imageSize = 128;
    switch (sizeScreen) {
      case ScreenSizeWidth.extraLarge:
        imageSize = 512;
      case ScreenSizeWidth.large:
        imageSize = 512;
      case ScreenSizeWidth.normal:
        imageSize = 256;
      case (_):
        imageSize = 170;
    }

    final screenNumber = ref.watch(selectQuizDetailsProvider);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/quiz2.png',
                height: imageSize.toDouble(),
                fit: BoxFit.fitWidth,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  welcomeMessage,
                  style: Theme.of(context).textTheme.titleSmall,
                  softWrap: false,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RadioListTile(
                value: 0,
                title: Text(
                  'Multi optional answers',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                groupValue: screenNumber.selectedOption,
                onChanged: ((value) {
                  ref.read(selectQuizDetailsProvider.notifier).setOption(value);
                }),
              ),
              const LastScoreAudioExampleScreen(),
              const SizedBox(
                height: 20,
              ),
              RadioListTile(
                value: 1,
                title: Text('Flash cards',
                    style: Theme.of(context).textTheme.bodyLarge),
                groupValue: screenNumber.selectedOption,
                onChanged: ((value) {
                  ref.read(selectQuizDetailsProvider.notifier).setOption(value);
                }),
              ),
              const LastFlashCardScore(),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ElevatedButton(
                  onPressed: () {
                    //ref.read(selectQuizDetailsProvider.notifier).selectScreen();
                    if (ref.read(selectQuizDetailsProvider).selectedOption ==
                        0) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) {
                          return QuizDetailsScreen(kanjiFromApi: kanjiFromApi);
                        }),
                      );
                    } else if (ref
                            .read(selectQuizDetailsProvider)
                            .selectedOption ==
                        1) {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (cxt) {
                        return FlashCardScreen(kanjiFromApi: kanjiFromApi);
                      }));
                    }
                    ref.read(selectQuizDetailsProvider.notifier).setOption(2);
                  },
                  style: ElevatedButton.styleFrom().copyWith(
                    minimumSize: const MaterialStatePropertyAll(
                      Size.fromHeight(40),
                    ),
                  ),
                  child: const Text('Start the quiz'),
                ),
              ),
            ],
          ),
        ) /**/
      ],
    );
  }
}

class LastScoreAudioExampleScreen extends ConsumerWidget {
  const LastScoreAudioExampleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastScoreData = ref.watch(lastScoreDetailsProvider);

    return lastScoreData.when(
      data: (data) => Builder(builder: (context) {
        logger.d(data);
        return data.isFinishedQuiz
            ? Text(
                'Last score: ${data.countCorrects} questions correct out of '
                '${data.countCorrects + data.countIncorrects + data.countOmited}',
                style: Theme.of(context).textTheme.bodySmall,
              )
            : Text(
                'Not started the audio quiz!!',
                style: Theme.of(context).textTheme.bodySmall,
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
        style: Theme.of(context).textTheme.titleLarge,
      ),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
