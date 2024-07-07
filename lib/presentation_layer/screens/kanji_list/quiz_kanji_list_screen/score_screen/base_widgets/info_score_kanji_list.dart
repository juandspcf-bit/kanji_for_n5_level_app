import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/score_screen/score_kanji_list_provider.dart';

class InfoScoreKanjiList extends ConsumerWidget {
  const InfoScoreKanjiList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiListScoreData = ref.watch(kanjiListScoreProvider);
    return Column(
      children: [
        Text(
          context.l10n.quizScoreStatsTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(
          height: 20,
        ),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 30,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.square,
                  color: Color.fromARGB(255, 229, 243, 33),
                ),
                Text(
                  '${context.l10n.correctAnswers} ${kanjiListScoreData.correctAnswers.length}',
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
                  '${context.l10n.incorrectAnswers} ${kanjiListScoreData.incorrectAnswers.length}',
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
                  '${context.l10n.omittedAnswers} ${kanjiListScoreData.omitted.length}',
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
