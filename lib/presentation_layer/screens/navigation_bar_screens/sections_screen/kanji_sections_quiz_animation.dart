import 'package:animations/animations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/section_screen_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/kanji_quiz_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/welcome_screen/last_score_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';

class KanjiSectionsQuizAnimated extends ConsumerWidget {
  const KanjiSectionsQuizAnimated({
    super.key,
    required this.kanjiListData,
    required this.closedChild,
  });

  final KanjiListData kanjiListData;
  final Widget closedChild;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 900),
      openBuilder: (context, closedContainer) {
        return KanjiQuizScreen(
          kanjisFromApi: kanjiListData.kanjiList,
        );
      },
      openColor: Colors.transparent,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      closedElevation: 0,
      closedColor: Colors.transparent,
      closedBuilder: (context, openContainer) {
        final connectivityData = ref.watch(statusConnectionProvider);
        final isAnyProcessingDataFunc =
            ref.read(kanjiListProvider.notifier).isAnyProcessingData;

        final accesToQuiz = !isAnyProcessingDataFunc() &&
            !(connectivityData == ConnectivityResult.none);

        return GestureDetector(
          onTap: kanjiListData.status == 1 && accesToQuiz
              ? () {
                  ref
                      .read(quizDataValuesProvider.notifier)
                      .initTheStateBeforeAccessingQuizScreen(
                          kanjiListData.kanjiList.length,
                          kanjiListData.kanjiList);
                  ref
                      .read(lastScoreKanjiQuizProvider.notifier)
                      .getKanjiQuizLastScore(
                        ref.read(sectionProvider),
                        authService.userUuid ?? '',
                      );
                  logger.d('kanji quiz animation tapped');
                  openContainer();
                }
              : null,
          child: closedChild,
        );
      },
    );
  }
}
