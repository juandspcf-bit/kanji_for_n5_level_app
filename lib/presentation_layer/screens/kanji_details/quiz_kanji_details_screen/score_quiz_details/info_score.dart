import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/score_quiz_details/quiz_details_score_provider.dart';

class InfoScore extends ConsumerWidget {
  const InfoScore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scores = ref.watch(quizDetailsScoreProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
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
                  '${context.l10n.correctAnswers} ${scores.correctAnswers.length}',
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
                  '${context.l10n.incorrectAnswers} ${scores.incorrectAnswers.length}',
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
                  '${context.l10n.omittedAnswers} ${scores.omitted.length}',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
