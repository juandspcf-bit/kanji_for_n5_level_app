// ignore: implementation_imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/kanji_possible_solution_container.dart';

class ColumnDragTargets extends ConsumerWidget {
  const ColumnDragTargets({
    super.key,
    required this.isDragged,
    required this.randomSolutions,
    required this.kanjiToAskMeaning,
    required this.imagePathFromDraggedItem,
    required this.initialOpacitie,
    required this.onDraggedKanji,
  });

  final bool isDragged;
  final List<KanjiFromApi> randomSolutions;
  final KanjiFromApi kanjiToAskMeaning;
  final List<String> imagePathFromDraggedItem;
  final List<double> initialOpacitie;
  final void Function(int i, KanjiFromApi data) onDraggedKanji;

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
                onDraggedKanji(indexColumnTargets, data);
              }, builder: (ctx, _, __) {
                return KanjiDragTarget(
                    isDragged: isDragged,
                    randomSolution: randomSolutions[indexColumnTargets],
                    imagePathFromDraggedItem:
                        imagePathFromDraggedItem[indexColumnTargets],
                    randomKanjisToAskMeaning: kanjiToAskMeaning,
                    initialOpacitie: initialOpacitie[indexColumnTargets]);
              }),
            ],
          ),
      ],
    );
  }
}
