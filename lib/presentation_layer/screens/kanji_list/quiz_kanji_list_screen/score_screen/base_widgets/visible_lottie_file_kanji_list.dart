import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/score_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/score_screen/score_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/score_screen/base_widgets/visible_lottie_file_kanji_list_provider.dart';
import 'package:lottie/lottie.dart';

class VisibleLottieFileKanjiList extends ConsumerWidget {
  const VisibleLottieFileKanjiList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleLottieFileData = ref.watch(visibleLottieFileKanjiListProvider);
    final scores = ref.watch(kanjiListScoreProvider);
    final lottieFilesState = ref.watch(lottieFilesProvider);
    return Visibility(
      visible: (visibleLottieFileData.visibility &&
          scores.incorrectAnswers.isEmpty &&
          scores.omitted.isEmpty),
      child: AnimatedOpacity(
        opacity: visibleLottieFileData.opacity,
        duration: const Duration(milliseconds: 3000),
        child: Lottie(
          composition: lottieFilesState.lottieComposition,
        ),
        onEnd: () {
          ref
              .read(visibleLottieFileKanjiListProvider.notifier)
              .setVisibility(false);
        },
      ),
    );
  }
}
