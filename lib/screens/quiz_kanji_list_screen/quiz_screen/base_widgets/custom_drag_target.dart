import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_list_screen/quiz_screen/base_widgets/kanji_possible_solution_container.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_list_screen/quiz_screen/quiz_kanji_list_provider.dart';

class CustomDragTarget extends ConsumerWidget {
  const CustomDragTarget({
    super.key,
    required this.indexColumnTargets,
    required this.isDragged,
    required this.randomSolutions,
    required this.kanjiToAskMeaning,
    required this.imagePathFromDraggedItem,
    required this.initialOpacities,
  });

  final int indexColumnTargets;
  final bool isDragged;
  final List<KanjiFromApi> randomSolutions;
  final KanjiFromApi kanjiToAskMeaning;
  final List<String> imagePathFromDraggedItem;
  final List<double> initialOpacities;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DragTarget<KanjiFromApi>(
            onAcceptWithDetails: (data) {
              ref
                  .read(quizDataValuesProvider.notifier)
                  .onDraggedKanji(indexColumnTargets, data.data);
            },
            builder: (ctx, _, __) {
              if (isDragged &&
                  randomSolutions[indexColumnTargets].kanjiCharacter ==
                      kanjiToAskMeaning.kanjiCharacter &&
                  imagePathFromDraggedItem[indexColumnTargets] != "") {
                //logger.d('correct $indexColumnTargets');
                return KanjiDragTargetCorrect(
                  isDragged: isDragged,
                  randomSolution: randomSolutions[indexColumnTargets],
                  imagePathFromDraggedItem:
                      imagePathFromDraggedItem[indexColumnTargets],
                  randomKanjisToAskMeaning: kanjiToAskMeaning,
                  initialOpacitie: initialOpacities[indexColumnTargets],
                );
              } else if (isDragged &&
                  randomSolutions[indexColumnTargets].kanjiCharacter !=
                      kanjiToAskMeaning.kanjiCharacter &&
                  imagePathFromDraggedItem[indexColumnTargets] != "") {
                logger.d('incorrect $indexColumnTargets');
                return KanjiDragTargetWrong(
                  isDragged: isDragged,
                  randomSolution: randomSolutions[indexColumnTargets],
                  imagePathFromDraggedItem:
                      imagePathFromDraggedItem[indexColumnTargets],
                  randomKanjisToAskMeaning: kanjiToAskMeaning,
                  initialOpacitie: initialOpacities[indexColumnTargets],
                );
              } else {
                return KanjiDragTargetNormal(
                  isDragged: isDragged,
                  randomSolution: randomSolutions[indexColumnTargets],
                  imagePathFromDraggedItem:
                      imagePathFromDraggedItem[indexColumnTargets],
                  randomKanjisToAskMeaning: kanjiToAskMeaning,
                  initialOpacitie: initialOpacities[indexColumnTargets],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
