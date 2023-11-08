import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_details_providers.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_details_score_screen.dart';
import 'package:kanji_for_n5_level_app/providers/select_quiz_details_screen.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_content.dart';
import 'package:lottie/lottie.dart';

class QuizDetailsScreen extends ConsumerStatefulWidget {
  const QuizDetailsScreen({super.key, required this.kanjiFromApi});

  final KanjiFromApi kanjiFromApi;

  @override
  ConsumerState<QuizDetailsScreen> createState() => _QuizDetailsScreenState();
}

class _QuizDetailsScreenState extends ConsumerState<QuizDetailsScreen> {
  Widget _selectScreen(int screenNumber) {
    if (screenNumber == 0) {
      return QuestionScreen(kanjiFromApi: widget.kanjiFromApi);
    } else if (screenNumber == 1) {
      return const QuizDetailsScore();
    } else {
      return const Center(
        child: Text('Error'),
      );
    }
  }

  final assetsAudioPlayer = AssetsAudioPlayer();
  @override
  Widget build(BuildContext context) {
    final screenNumber = ref.watch(selectQuizDetailsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Test your knowledge',
        ),
      ),
      body: _selectScreen(screenNumber),
    );
  }
}

class QuestionScreen extends ConsumerWidget {
  final assetsAudioPlayer = AssetsAudioPlayer();
  final KanjiFromApi kanjiFromApi;

  QuestionScreen({super.key, required this.kanjiFromApi});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateQuiz = ref.watch(quizDetailsProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Question ${stateQuiz.indexQuestion + 1} of ${kanjiFromApi.example.length}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            color: Theme.of(context).colorScheme.onPrimary,
            splashColor: Colors.deepOrange,
            onPressed: () async {
              final assetsAudioPlayer = AssetsAudioPlayer();

              try {
                if (kanjiFromApi.statusStorage == StatusStorage.onlyOnline) {
                  await assetsAudioPlayer.open(
                    Audio.network(stateQuiz.audioQuestion),
                  );
                } else if (kanjiFromApi.statusStorage == StatusStorage.stored) {
                  await assetsAudioPlayer.open(
                    Audio.file(stateQuiz.audioQuestion),
                  );
                }
              } catch (t) {
                //mp3 unreachable
              }
            },
            icon: const Icon(
              Icons.play_arrow_rounded,
              size: 80,
            ),
          ),
        ),
        RadioListTile(
            value: 0,
            title: Text(stateQuiz.answer1.hiraganaMeaning),
            subtitle: Text(stateQuiz.answer1.englishMeaning),
            groupValue: stateQuiz.selectedAnswer,
            onChanged: ((value) {
              ref.read(quizDetailsProvider.notifier).setAnswer(value ?? 4);
            })),
        RadioListTile(
            value: 1,
            title: Text(stateQuiz.answer2.hiraganaMeaning),
            subtitle: Text(stateQuiz.answer2.englishMeaning),
            groupValue: stateQuiz.selectedAnswer,
            onChanged: ((value) {
              ref.read(quizDetailsProvider.notifier).setAnswer(value ?? 4);
            })),
        RadioListTile(
            value: 2,
            title: Text(stateQuiz.answer3.hiraganaMeaning),
            subtitle: Text(stateQuiz.answer3.englishMeaning),
            groupValue: stateQuiz.selectedAnswer,
            onChanged: ((value) {
              ref.read(quizDetailsProvider.notifier).setAnswer(value ?? 4);
            })),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () {
              if (ref
                  .read(quizDetailsProvider.notifier)
                  .isQuizDataLenghtReached()) {
                ref.read(quizDetailsScoreProvider.notifier).setAnswers();
                ref.read(selectQuizDetailsProvider.notifier).setScreen(1);
                return;
              }

              ref.read(quizDetailsProvider.notifier).setQuizState(ref
                      .read(quizDetailsProvider.notifier)
                      .getQuizStateCurrentIndex() +
                  1);
            },
            style: ElevatedButton.styleFrom(
              textStyle: Theme.of(context).textTheme.bodyLarge,
              minimumSize: Size.fromHeight(
                  (Theme.of(context).textTheme.bodyLarge!.height ?? 30) + 10),
            ),
            icon: const Icon(Icons.arrow_circle_right),
            label: const Text('Next'),
          ),
        ),
      ],
    );
  }
}

class QuizDetailsScore extends ConsumerWidget {
  const QuizDetailsScore({super.key});

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
    return Column(
      children: [
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
              ref.read(selectQuizDetailsProvider.notifier).setScreen(0);
            },
            style: ElevatedButton.styleFrom(
              textStyle: Theme.of(context).textTheme.bodyLarge,
              minimumSize: Size.fromHeight(
                  (Theme.of(context).textTheme.bodyLarge!.height ?? 30) + 10),
            ),
            icon: const Icon(Icons.arrow_circle_right),
            label: const Text('Restart quiz'),
          ),
        ),
      ],
    );
  }
}
