import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/score_screen/score_kanji_list_provider.dart';

class InfoScoreKanjiList extends ConsumerWidget {
  const InfoScoreKanjiList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiListScoreData = ref.watch(kanjiListScoreProvider);
    return Column(
      children: [
        Text(
          "This is the stats of your quiz",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(
          height: 20,
        ),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 30,

          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.square,
                  color: Color.fromARGB(255, 229, 243, 33),
                ),
                Text(
                  'Correct\n answers:\n ${kanjiListScoreData.correctAnswers.length}',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.square,
                  color: Color.fromARGB(255, 194, 88, 27),
                ),
                Text(
                  'Incorrect\n answers:\n ${kanjiListScoreData.incorrectAnswers.length}',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.square,
                  color: Color.fromARGB(255, 33, 72, 243),
                ),
                Text(
                  'Omitted\n answers:\n ${kanjiListScoreData.omitted.length}',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
