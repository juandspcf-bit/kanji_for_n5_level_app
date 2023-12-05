import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/screen_chart.dart';
import 'package:lottie/lottie.dart';

class ScoreBody extends ConsumerStatefulWidget {
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
  ConsumerState<ScoreBody> createState() => _ScoreBodyState();
}

class _ScoreBodyState extends ConsumerState<ScoreBody> {
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

  double _opacity = 1.0;
  bool _visibility = true;
  @override
  void initState() {
    super.initState();
    final counts = getCounts();
    countCorrects = counts.$1;
    countIncorrects = counts.$2;
    countOmited = counts.$3;
    Future<double>.delayed(const Duration(seconds: 3), () => 0.0).then((value) {
      setState(() {
        _opacity = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Column(
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
              ref.read(quizDataValuesProvider.notifier).resetTheQuiz();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              textStyle: Theme.of(context).textTheme.bodyLarge,
              minimumSize: const Size.fromHeight(40),
            ),
            child: const Text('Restart quiz'),
          )
        ],
      ),
      Visibility(
        visible:
            (_visibility /* && countIncorrects == 0 && countOmited == 0 */),
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 3),
          // The green box must be a child of the AnimatedOpacity widget.
          child: Lottie.asset('assets/lottie_files/congrats.json',
              fit: BoxFit.fitWidth),
          onEnd: () {
            setState(() {
              _visibility = false;
            });
          },
        ),
      ),
    ]);
  }
}
