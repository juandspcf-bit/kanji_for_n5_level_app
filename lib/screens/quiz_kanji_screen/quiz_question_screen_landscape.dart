import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/draggable_kanji.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/next_question_button.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/reset_question_button.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/row_drag_targets.dart';

class QuizQuestionScreenLandscape extends ConsumerWidget {
  const QuizQuestionScreenLandscape({
    super.key,
    required this.isDraggedStatusList,
    required this.randomSolutions,
    required this.kanjisToAskMeaning,
    required this.imagePathFromDraggedItems,
    required this.initialOpacities,
    required this.index,
  });

  final List<bool> isDraggedStatusList;
  final List<KanjiFromApi> randomSolutions;
  final List<KanjiFromApi> kanjisToAskMeaning;
  final List<String> imagePathFromDraggedItems;
  final List<double> initialOpacities;
  final int index;

  Widget getButtons(ScreenSizeHeight sizeScreen) {
    switch (sizeScreen) {
      case ScreenSizeHeight.normal:
        return const Column(
          children: [
            ResetQuestionButton(),
            NextQuestionButton(),
          ],
        );

      default:
        return const Column(
          children: [
            ResetQuestionButton(),
            NextQuestionButton(),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sizeScreen = getScreenSizeHeight(context);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                RowDragTargets(
                  isDragged: isDraggedStatusList[index],
                  randomSolutions: randomSolutions,
                  kanjiToAskMeaning: kanjisToAskMeaning[index],
                  imagePathFromDraggedItem: imagePathFromDraggedItems,
                  initialOpacities: initialOpacities,
                ),
                const SizedBox(
                  height: 10,
                ),
                DraggableKanji(
                    isDragged: isDraggedStatusList[index],
                    kanjiToAskMeaning: kanjisToAskMeaning[index]),
                //
              ],
            ),
          ),
          Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    'Question ${index + 1} of ${kanjisToAskMeaning.length}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  getButtons(sizeScreen),
                ],
              ))
        ],
      ),
    );
  }
}
