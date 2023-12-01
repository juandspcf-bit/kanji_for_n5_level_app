// ignore: implementation_imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:kanji_for_n5_level_app/Databases/favorites_db_utils.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/column_drag_provider.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_screens/main_content.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/kanji_possible_solution_container.dart';

class ColumnDragTargets extends ConsumerWidget {
  const ColumnDragTargets({
    super.key,
    required this.isDragged,
    required this.randomSolutions,
    required this.kanjiToAskMeaning,
    required this.imagePathFromDraggedItem,
    required this.initialOpacities,
  });

  final bool isDragged;
  final List<KanjiFromApi> randomSolutions;
  final KanjiFromApi kanjiToAskMeaning;
  final List<String> imagePathFromDraggedItem;
  final List<double> initialOpacities;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (int indexColumnTargets = 0;
            indexColumnTargets < randomSolutions.length;
            indexColumnTargets++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              DragTarget<KanjiFromApi>(onAccept: (data) {
                ref
                    .read(quizDataValuesProvider.notifier)
                    .onDraggedKanji(indexColumnTargets, data);
              }, builder: (ctx, _, __) {
                if (isDragged &&
                    randomSolutions[indexColumnTargets].kanjiCharacter ==
                        kanjiToAskMeaning.kanjiCharacter &&
                    imagePathFromDraggedItem[indexColumnTargets] != "") {
                  logger.d('correct $indexColumnTargets');
                } else if (isDragged &&
                    randomSolutions[indexColumnTargets].kanjiCharacter !=
                        kanjiToAskMeaning.kanjiCharacter &&
                    imagePathFromDraggedItem[indexColumnTargets] != "") {
                  logger.d('incorrect $indexColumnTargets');
                }

                return KanjiDragTarget(
                    isDragged: isDragged,
                    randomSolution: randomSolutions[indexColumnTargets],
                    imagePathFromDraggedItem:
                        imagePathFromDraggedItem[indexColumnTargets],
                    randomKanjisToAskMeaning: kanjiToAskMeaning,
                    initialOpacitie: initialOpacities[indexColumnTargets]);
              }),
            ],
          ),
      ],
    );
  }
}
