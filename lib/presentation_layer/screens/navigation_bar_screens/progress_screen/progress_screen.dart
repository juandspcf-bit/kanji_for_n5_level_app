import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/my_time_line_tile.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/progress_screen_provider.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressTimelineData = ref.watch(progressTimelineProvider);
    //logger.d(progressTimelineData.allAudioQuizCorrectStatusList);
    //logger.d(progressTimelineData.allAudioQuizFinishedStatusList);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ListView(
        children: [
          for (int i = 0;
              i < progressTimelineData.allKanjiQuizCorrectStatusList.length;
              i++)
            MyTimeLineTile(
              section: i + 1,
              isFirst: i == 0,
              isLast: i ==
                  progressTimelineData.allKanjiQuizCorrectStatusList.length - 1,
              isAllCorrectKanjiQuizSection:
                  progressTimelineData.allKanjiQuizCorrectStatusList[i],
              isFinishedKanjiQuizSection:
                  progressTimelineData.allKanjiQuizFinishedStatusList[i],
              isFinishedAudioQuizSection:
                  progressTimelineData.allAudioQuizFinishedStatusList[i],
              isAllCorrectAudioQuizSection:
                  progressTimelineData.allAudioQuizCorrectStatusList[i],
              isFinishedFlashCardSection:
                  progressTimelineData.allRevisedFlashCardsStatusList[i],
            )
        ],
      ),
    );
  }
}
