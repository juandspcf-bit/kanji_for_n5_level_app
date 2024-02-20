import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_details_score_screen.dart';

class BarChartLandscape extends ConsumerWidget {
  const BarChartLandscape({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scores = ref.watch(quizDetailsScoreProvider);
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 256,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
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
                              toY: scores.correctAnswers.length.toDouble(),
                              //color: Colors.amber,
                              gradient: _barsGradientCorrect),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            width: 10,
                            toY: scores.incorrectAnwers.length.toDouble(),
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
          ),
        ],
      ),
    );
  }
}
