import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/quiz_details_provider.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_details_score_screen.dart';
import 'package:kanji_for_n5_level_app/providers/score_kanji_list_provider.dart';
import 'package:lottie/lottie.dart';

class _QuizDetailsScore extends ConsumerState<QuizDetailsScore> {
  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Corrects';
        break;
      case 1:
        text = 'Incorrects';
        break;
      case 2:
        text = 'Omited';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
      show: true,
      border: const Border(
          bottom: BorderSide(color: Color.fromARGB(255, 255, 255, 255))));

  LinearGradient get _barsGradientCorrect => const LinearGradient(
        colors: [
          Color.fromARGB(255, 229, 243, 33),
          Color.fromARGB(255, 234, 236, 203),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  LinearGradient get _barsGradientIncorrect => const LinearGradient(
        colors: [
          Color.fromARGB(255, 194, 88, 27),
          Color.fromARGB(255, 241, 226, 217),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  LinearGradient get _barsGradientOmited => const LinearGradient(
        colors: [
          Color.fromARGB(255, 33, 72, 243),
          Color.fromARGB(255, 202, 208, 238),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

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
    final scores = ref.watch(quizDetailsScoreProvider);
    final lottieFilesState = ref.watch(lottieFilesProvider);
    return PopScope(
      onPopInvoked: (didPop) {
        ref.read(quizDetailsProvider.notifier).resetValues();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your score'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            top: 0,
            bottom: 0,
            right: 30,
            left: 30,
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
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
                            'Correct\n answers:\n ${scores.correctAnswers.length}',
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
                            'Incorrect\n answers:\n ${scores.incorrectAnwers.length}',
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
                            'Omited\n answers:\n ${scores.omitted.length}',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 256,
                        height: 256,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: BarChart(
                          BarChartData(
                              titlesData: titlesData,
                              gridData: const FlGridData(show: false),
                              alignment: BarChartAlignment.spaceAround,
                              borderData: borderData,
                              barGroups: [
                                BarChartGroupData(
                                  x: 0,
                                  barsSpace: 20,
                                  barRods: [
                                    BarChartRodData(
                                        width: 10,
                                        toY: scores.correctAnswers.length
                                            .toDouble(),
                                        //color: Colors.amber,
                                        gradient: _barsGradientCorrect),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 1,
                                  barRods: [
                                    BarChartRodData(
                                      width: 10,
                                      toY: scores.incorrectAnwers.length
                                          .toDouble(),
                                      gradient: _barsGradientIncorrect,
                                    ),
                                  ],
                                ),
                                BarChartGroupData(
                                  x: 2,
                                  barRods: [
                                    BarChartRodData(
                                      width: 10,
                                      toY: scores.omitted.length.toDouble(),
                                      gradient: _barsGradientOmited,
                                    ),
                                  ],
                                )
                              ]
                              // read about it in the BarChartData section
                              ),
                          swapAnimationDuration:
                              const Duration(milliseconds: 150), // Optional
                          swapAnimationCurve: Curves.linear, // Optional
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref.read(quizDetailsProvider.notifier).resetValues();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(40),
                      ),
                      icon: const Icon(Icons.arrow_circle_right),
                      label: const Text('Restart quiz'),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: (_visibility &&
                    scores.incorrectAnwers.isEmpty &&
                    scores.omitted.isEmpty),
                child: AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(milliseconds: 3000),
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
          ),
        ),
      ),
    );
  }
}

class QuizDetailsScore extends ConsumerStatefulWidget {
  const QuizDetailsScore({super.key});

  @override
  ConsumerState<QuizDetailsScore> createState() => _QuizDetailsScore();
}
