import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/animated_opacity_icon.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/kanji_quiz_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/welcome_screen/last_score_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/section_screen_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

class QuizIconKanjiList extends ConsumerWidget {
  const QuizIconKanjiList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityData = ref.watch(statusConnectionProvider);
    var kanjiListData = ref.watch(kanjiListProvider);

    final isAnyProcessingDataFunc =
        ref.read(kanjiListProvider.notifier).isAnyProcessingData;

    final accessToQuiz = isAnyProcessingDataFunc() ||
        connectivityData == ConnectionStatus.noConnected ||
        kanjiListData.kanjiList.isEmpty;

    return (kanjiListData.status == 1 && !accessToQuiz)
        ? AnimatedOpacityIcon(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: IconButton(
                  onPressed: () {
                    var kanjiListData = ref.read(kanjiListProvider);
                    ref
                        .read(quizDataValuesProvider.notifier)
                        .initTheStateBeforeAccessingQuizScreen(
                            kanjiListData.kanjiList.length,
                            kanjiListData.kanjiList);
                    ref
                        .read(lastScoreKanjiQuizProvider.notifier)
                        .getKanjiQuizLastScore(
                          ref.read(sectionProvider),
                          ref.read(authServiceProvider).userUuid ?? '',
                        );

                    Navigator.of(context).push(PageAnimationTransition(
                        page: const KanjiQuizScreen(),
                        pageAnimationType: FadeAnimationTransition()));
                  },
                  icon: const Icon(Icons.quiz)),
            ),
          )
        : Container();
  }
}
