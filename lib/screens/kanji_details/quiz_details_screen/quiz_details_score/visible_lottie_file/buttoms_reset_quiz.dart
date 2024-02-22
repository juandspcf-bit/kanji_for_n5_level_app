import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/quiz_details_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/quiz_details_score/visible_lottie_file/visible_lottie_file_provider.dart';

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
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
            ),
            icon: const Icon(Icons.arrow_circle_right),
            label: const Text('Restart quiz'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: ElevatedButton.icon(
            onPressed: () {
              ref.read(quizDetailsProvider.notifier).resetValues();
              ref.read(visibleLottieFileProvider.notifier).reset();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
            ),
            icon: const Icon(Icons.arrow_circle_right),
            label: const Text('To quiz type selector'),
          ),
        ),
      ],
    );
  }
}
