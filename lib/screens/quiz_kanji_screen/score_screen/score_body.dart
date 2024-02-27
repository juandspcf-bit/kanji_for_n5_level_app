import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/score_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/score_screen/info_score_kanji_list.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/score_screen/screen_chart.dart';
import 'package:lottie/lottie.dart';

class ScoreBody extends ConsumerStatefulWidget {
  const ScoreBody({
    super.key,
    required this.countCorrects,
    required this.countIncorrects,
    required this.countOmited,
    required this.resetTheQuiz,
  });

  final int countCorrects;
  final int countIncorrects;
  final int countOmited;
  final Function() resetTheQuiz;

  @override
  ConsumerState<ScoreBody> createState() => _ScoreBodyState();
}

class _ScoreBodyState extends ConsumerState<ScoreBody> {
  double _opacity = 1.0;
  bool _visibility = true;
  @override
  void initState() {
    super.initState();
    Future<double>.delayed(const Duration(seconds: 3), () => 0.0).then((value) {
      setState(() {
        _opacity = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final lottieFilesState = ref.watch(lottieFilesProvider);
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const InfoScoreKanjiList(),
            const SizedBox(
              height: 40,
            ),
            ScreenChart(
              countCorrects: widget.countCorrects,
              countIncorrects: widget.countIncorrects,
              countOmited: widget.countOmited,
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(quizDataValuesProvider.notifier).resetTheQuiz();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
              ),
              child: const Text('Restart quiz'),
            )
          ],
        ),
        Visibility(
          visible: (_visibility &&
              widget.countIncorrects == 0 &&
              widget.countOmited == 0),
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(seconds: 3),
            // The green box must be a child of the AnimatedOpacity widget.
            child: Lottie(
              composition: lottieFilesState.lottieComposition,
            ),
            onEnd: () {
              setState(() {
                _visibility = false;
              });
            },
          ),
        ),
      ],
    );
  }
}
