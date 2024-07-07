import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/quiz_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/welcome_screen/welcome_kanji_details_quiz_screen.dart';

class WelcomeKanjiDetailsQuizScreenLandScape extends ConsumerWidget {
  const WelcomeKanjiDetailsQuizScreenLandScape({
    super.key,
  });

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

    final quizDetailsData = ref.watch(quizDetailsProvider);
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
                  context.l10n.detailsKanjiQuizWelcomeMessage,
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
                  context.l10n.multiOptionsAnswer,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                groupValue: quizDetailsData.selectedOption,
                onChanged: ((value) {
                  ref.read(quizDetailsProvider.notifier).setOption(value);
                }),
              ),
              const LastScoreAudioExampleScreen(),
              const SizedBox(
                height: 20,
              ),
              RadioListTile(
                value: 1,
                title: Text(context.l10n.flashCards,
                    style: Theme.of(context).textTheme.bodyLarge),
                groupValue: quizDetailsData.selectedOption,
                onChanged: ((value) {
                  ref.read(quizDetailsProvider.notifier).setOption(value);
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
                    if (quizDetailsData.selectedOption == 0) {
                      ref
                          .read(quizDetailsProvider.notifier)
                          .setScreen(Screen.question);
                    } else if (quizDetailsData.selectedOption == 1) {
                      ref
                          .read(quizDetailsProvider.notifier)
                          .setScreen(Screen.flashCards);
                    }
                    ref.read(quizDetailsProvider.notifier).setOption(2);
                  },
                  style: ElevatedButton.styleFrom().copyWith(
                    minimumSize: const WidgetStatePropertyAll(
                      Size.fromHeight(40),
                    ),
                  ),
                  child: Text(context.l10n.startTheQuiz),
                ),
              ),
            ],
          ),
        ) /**/
      ],
    );
  }
}
