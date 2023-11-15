import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/column_drag_targets.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/draggable_kanji.dart';

class QuizQuestionScreen extends ConsumerWidget {
  const QuizQuestionScreen({
    super.key,
    required this.isDraggedStatusList,
    required this.randomSolutions,
    required this.kanjisToAskMeaning,
    required this.imagePathFromDraggedItems,
    required this.initialOpacities,
    required this.index,
    required this.onDraggedKanji,
    required this.onResetQuestion,
    required this.onNext,
  });

  final List<bool> isDraggedStatusList;
  final List<KanjiFromApi> randomSolutions;
  final List<KanjiFromApi> kanjisToAskMeaning;
  final List<String> imagePathFromDraggedItems;
  final List<double> initialOpacities;
  final int index;
  final void Function(int i, KanjiFromApi data) onDraggedKanji;
  final void Function() onResetQuestion;
  final void Function() onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
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
                  onDraggedKanji: onDraggedKanji)
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ElevatedButton(
              onPressed: () {
                onResetQuestion();
              },
              style: ElevatedButton.styleFrom(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                minimumSize: Size.fromHeight(
                    (Theme.of(context).textTheme.bodyLarge!.height ?? 30) + 10),
              ),
              child: const Text("Reset question"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ElevatedButton.icon(
              onPressed: () {
                onNext();
              },
              style: ElevatedButton.styleFrom(
                textStyle: Theme.of(context).textTheme.bodyLarge,
                minimumSize: Size.fromHeight(
                    (Theme.of(context).textTheme.bodyLarge!.height ?? 30) + 10),
              ),
              icon: const Icon(Icons.arrow_circle_right),
              label: const Text('Next'),
            ),
          )
        ],
      ),
    );
  }
}
