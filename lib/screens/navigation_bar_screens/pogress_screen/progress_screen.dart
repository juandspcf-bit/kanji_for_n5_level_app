import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/pogress_screen/my_time_line_tile.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/pogress_screen/progress_screen_provider.dart';

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
              isFirts: i == 0,
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
/*           MyTimeLineTile(
            section: 1,
            isFirts: true,
            isLast: false,
            isAllCorrectKanjiQuizSection: true,
            isFinishedKanjiQuizSection: true,
            isFinishedAudioQuizSection: true,
            isAllCorrectAudioQuizSection: true,
            isFinishedFlashCardSection: true,
          ),
          MyTimeLineTile(
            section: 2,
            isFirts: false,
            isLast: false,
            isAllCorrectKanjiQuizSection: false,
            isFinishedKanjiQuizSection: true,
            isFinishedAudioQuizSection: true,
            isAllCorrectAudioQuizSection: false,
            isFinishedFlashCardSection: true,
          ),
          MyTimeLineTile(
            section: 3,
            isFirts: false,
            isLast: true,
            isAllCorrectKanjiQuizSection: false,
            isFinishedKanjiQuizSection: false,
            isFinishedAudioQuizSection: false,
            isAllCorrectAudioQuizSection: false,
            isFinishedFlashCardSection: false,
          ), */
        ],
      ),
    );
  }
}
