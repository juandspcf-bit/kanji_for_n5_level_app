import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/services.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/section_screen_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/score_screen/base_widgets/visible_lottie_file_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/welcome_screen/last_score_provider.dart';

class ButtonScoreKanjiList extends ConsumerWidget {
  const ButtonScoreKanjiList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        final (countCorrects, countIncorrects, countOmited) =
            ref.read(quizDataValuesProvider.notifier).getCounts();

        ref.read(lastScoreKanjiQuizProvider.notifier).setFinishedQuiz(
              section: ref.read(sectionProvider),
              uuid: ref.read(authServiceProvider).userUuid ?? '',
              countCorrects: countCorrects,
              countIncorrects: countIncorrects,
              countOmited: countOmited,
            );
        ref.read(quizDataValuesProvider.notifier).resetTheQuiz();
        ref.read(visibleLottieFileKanjiListProvider.notifier).reset();
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
      ),
      child: const Text('Restart quiz'),
    );
  }
}
