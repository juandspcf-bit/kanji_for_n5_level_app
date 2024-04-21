import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/config_files/screen_config.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/quiz_screen/base_widgets/column_drag_targets.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/quiz_screen/base_widgets/draggable_kanji.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/quiz_screen/base_widgets/next_question_button.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/quiz_screen/base_widgets/reset_question_button.dart';

class QuizQuestionScreenPortrait extends ConsumerWidget {
  const QuizQuestionScreenPortrait({
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
        return const Row(
          children: [
            Expanded(child: ResetQuestionButton()),
            SizedBox(
              width: 20,
            ),
            Expanded(child: NextQuestionButton()),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sizeScreen = getScreenSizeHeight(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          'Question ${index + 1} of ${kanjisToAskMeaning.length}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DraggableKanji(
                isDragged: isDraggedStatusList[index],
                kanjiToAskMeaning: kanjisToAskMeaning[index]),
            ColumnDragTargets(
              isDragged: isDraggedStatusList[index],
              randomSolutions: randomSolutions,
              kanjiToAskMeaning: kanjisToAskMeaning[index],
              imagePathFromDraggedItem: imagePathFromDraggedItems,
              initialOpacities: initialOpacities,
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        getButtons(sizeScreen)
      ],
    );
  }
}
