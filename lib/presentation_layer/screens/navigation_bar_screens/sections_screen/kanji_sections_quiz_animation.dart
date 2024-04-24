import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/services.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/section_screen_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/kanji_quiz_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/welcome_screen/last_score_provider.dart';

class KanjiSectionsQuizAnimated extends ConsumerWidget {
  const KanjiSectionsQuizAnimated({
    super.key,
    required this.closedChild,
  });

  final Widget closedChild;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 900),
      openBuilder: (context, closedContainer) {
        var kanjiListData = ref.read(kanjiListProvider);
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
        return GestureDetector(
          onTap: () {
            var kanjiListData = ref.watch(kanjiListProvider);
            ref
                .read(quizDataValuesProvider.notifier)
                .initTheStateBeforeAccessingQuizScreen(
                    kanjiListData.kanjiList.length, kanjiListData.kanjiList);
            ref.read(lastScoreKanjiQuizProvider.notifier).getKanjiQuizLastScore(
                  ref.read(sectionProvider),
                  ref.read(authServiceProvider).userUuid ?? '',
                );
            openContainer();
          },
          child: closedChild,
        );
      },
    );
  }
}
