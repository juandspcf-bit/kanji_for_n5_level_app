import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_list_screen/quiz_screen/base_widgets/draggable_kanji.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_list_screen/quiz_screen/base_widgets/next_question_button.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_list_screen/quiz_screen/base_widgets/reset_question_button.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_list_screen/quiz_screen/base_widgets/row_drag_targets.dart';

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

  Widget getButtons(ScreenSizeHeight heightScreen) {
    switch (heightScreen) {
      case ScreenSizeHeight.normal:
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ResetQuestionButton(),
            NextQuestionButton(),
          ],
        );

      default:
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ResetQuestionButton(),
            NextQuestionButton(),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heightScreen = getScreenSizeHeight(context);
    final widhtScreen = getScreenSizeWidth(context);

    int padding = 10;
    switch (widhtScreen) {
      case ScreenSizeWidth.extraLarge:
        padding = 50;
      case ScreenSizeWidth.large:
        padding = 30;
      case ScreenSizeWidth.normal:
        padding = 10;
      case (_):
        padding = 10;
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                SizedBox(
                  height: padding.toDouble(),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Question ${index + 1} of ${kanjisToAskMeaning.length}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  getButtons(heightScreen),
                ],
              ))
        ],
      ),
    );
  }
}
