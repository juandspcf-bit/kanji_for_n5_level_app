import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/score_quiz_details/quiz_details_score_screen.dart';
import 'package:kanji_for_n5_level_app/providers/score_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/score_quiz_details/visible_lottie_file/visible_lottie_file_provider.dart';
import 'package:lottie/lottie.dart';

class VisibleLottieFile extends ConsumerWidget {
  const VisibleLottieFile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleLottieFileData = ref.watch(visibleLottieFileProvider);
    final scores = ref.watch(quizDetailsScoreProvider);
    final lottieFilesState = ref.watch(lottieFilesProvider);
    return Visibility(
      visible: (visibleLottieFileData.visibility &&
          scores.incorrectAnwers.isEmpty &&
          scores.omitted.isEmpty),
      child: AnimatedOpacity(
        opacity: visibleLottieFileData.opacity,
        duration: const Duration(milliseconds: 3000),
        child: Lottie(
          composition: lottieFilesState.lottieComposition,
        ),
        onEnd: () {
          ref.read(visibleLottieFileProvider.notifier).setVisibility(false);
        },
      ),
    );
  }
}
