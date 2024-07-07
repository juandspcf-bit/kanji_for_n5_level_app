import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/quiz_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/score_quiz_details/visible_lottie_file/visible_lottie_file_provider.dart';

class ButtonsResetQuiz extends ConsumerWidget {
  const ButtonsResetQuiz({super.key});

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
    return ElevatedButton.icon(
      onPressed: () async {
        ref.read(quizDetailsProvider.notifier).resetValues();
        ref.read(visibleLottieFileProvider.notifier).reset();
        ref.read(quizDetailsProvider.notifier).setScreen(Screen.welcome);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
      ),
      icon: const Icon(Icons.home),
      label: Text(context.l10n.quizSelector),
    );
  }
}
