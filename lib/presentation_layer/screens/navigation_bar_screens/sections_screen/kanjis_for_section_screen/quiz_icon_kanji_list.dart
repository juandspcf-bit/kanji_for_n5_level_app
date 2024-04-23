import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanjis_list_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/kanji_sections_quiz_animation.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/kanjis_for_section_screen/kanjis_for_section_screen.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';

class QuizIconKanjiList extends ConsumerWidget {
  const QuizIconKanjiList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityData = ref.watch(statusConnectionProvider);
    var kanjiListData = ref.watch(kanjiListProvider);

    final isAnyProcessingDataFunc =
        ref.read(kanjiListProvider.notifier).isAnyProcessingData;

    final accesToQuiz = !isAnyProcessingDataFunc() &&
        !(connectivityData == ConnectivityResult.none);

    return (kanjiListData.status == 1 && accesToQuiz)
        ? const AnimatedOpacityIcon(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: KanjiSectionsQuizAnimated(
                closedChild: Icon(Icons.quiz),
              ),
            ),
          )
        : Container();
  }
}
