import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/screen_chart.dart';

class ScoreBody extends StatefulWidget {
  const ScoreBody({
    super.key,
    required this.isCorrectAnswer,
    required this.isOmittedAnswer,
    required this.resetTheQuiz,
  });

  final List<bool> isCorrectAnswer;
  final List<bool> isOmittedAnswer;
  final Function() resetTheQuiz;

  @override
  State<ScoreBody> createState() => _ScoreBodyState();
}

class _ScoreBodyState extends State<ScoreBody> {
  int countCorrects = 0, countIncorrects = 0, countOmited = 0;

  (int, int, int) getCounts() {
    int countCorrects = widget.isCorrectAnswer.map((e) {
      if (e == true) {
        return 1;
      }
      return 0;
    }).reduce((value, element) => value + element);

    int countOmited = widget.isOmittedAnswer.map((e) {
      if (e == true) {
        return 1;
      }
      return 0;
    }).reduce((value, element) => value + element);

    int countIncorrects =
        widget.isCorrectAnswer.length - countCorrects - countOmited;

    return (countCorrects, countIncorrects, countOmited);
  }

  @override
  void initState() {
    super.initState();
    final counts = getCounts();
    countCorrects = counts.$1;
    countIncorrects = counts.$2;
    countOmited = counts.$3;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
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
                  'Correct\n answers:\n $countCorrects',
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
                  'Incorrect\n answers:\n $countIncorrects',
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
                  'Omited\n answers:\n $countOmited',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        ScreenChart(
          countCorrects: countCorrects,
          countIncorrects: countIncorrects,
          countOmited: countOmited,
        ),
        const SizedBox(
          height: 40,
        ),
        ElevatedButton(
            onPressed: () {
              widget.resetTheQuiz();
            },
            child: const Text('Restart quiz'))
      ],
    );
  }
}
