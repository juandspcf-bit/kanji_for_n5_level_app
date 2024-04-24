import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/welcome_screen/last_score_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/text_asset/text_assets.dart';

class WelcomeKanjiListQuizScreenLandscape extends ConsumerWidget {
  const WelcomeKanjiListQuizScreenLandscape({super.key});

  final welcomeMessage = 'Guess the correct meaning by dragging '
      'the kanji to one of the empty boxes.';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sizeScreen = getScreenSizeWidth(context);
    int imageSize = 256;
    switch (sizeScreen) {
      case ScreenSizeWidth.extraLarge:
        imageSize = 512;
      case ScreenSizeWidth.large:
        imageSize = 512;
      case ScreenSizeWidth.normal:
        imageSize = 256;
      case (_):
        imageSize = 200;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: imageSize.toDouble(),
                child: Image.asset(
                  'assets/images/quiz.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const LastScoreKanjiQuiz(),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(quizDataValuesProvider.notifier)
                        .setScreen(Screens.quiz);
                  },
                  style: ElevatedButton.styleFrom().copyWith(
                    minimumSize: const MaterialStatePropertyAll(
                      Size.fromHeight(40),
                    ),
                  ),
                  child: const Text('Start the quiz'),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class LastScoreKanjiQuiz extends ConsumerWidget {
  const LastScoreKanjiQuiz({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);
    final textThemeParent = Theme.of(context).textTheme;
    final sizeScreen = getScreenSizeWidth(context);
    var textTheme = textThemeParent.titleMedium;
    switch (sizeScreen) {
      case ScreenSizeWidth.extraLarge:
        textTheme = textThemeParent.titleLarge;
      case ScreenSizeWidth.large:
        textTheme = textThemeParent.titleLarge;
      case ScreenSizeWidth.normal:
        textTheme = textThemeParent.titleMedium;
      case (_):
        textTheme = textThemeParent.titleMedium;
    }

    final lastScoreData = ref.watch(lastScoreKanjiQuizProvider);

    return lastScoreData.when(
      data: (data) => Builder(builder: (context) {
        return data.isFinishedQuiz
            ? Orientation.portrait == orientation
                ? Text(
                    'You have completed this quiz with ${data.countCorrects}'
                    ' questions correct\nout of ${data.countCorrects + data.countIncorrects + data.countOmited}',
                    style: textTheme,
                    textAlign: TextAlign.center,
                  )
                : Text(
                    'You have completed this quiz with ${data.countCorrects}'
                    ' questions correct out of ${data.countCorrects + data.countIncorrects + data.countOmited}',
                    style: textTheme,
                    textAlign: TextAlign.center,
                  )
            : Text(
                noFinishedQuizMessage,
                style: textTheme,
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