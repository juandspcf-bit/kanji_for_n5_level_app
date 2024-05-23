import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/quiz_section_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_audio_example_data.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class BodyFullProgressSection extends ConsumerWidget {
  const BodyFullProgressSection({
    super.key,
    required this.quizSectionData,
    required this.section,
  });

  final QuizSectionData quizSectionData;
  final int section;

  double getCount(SingleAudioExampleQuizData data) {
    return ((data.countCorrects /
                (data.countCorrects +
                    data.countIncorrect +
                    data.countOmitted)) *
            100)
        .floorToDouble();
  }

  Color getColor(SingleAudioExampleQuizData data) {
    final count = ((data.countCorrects /
                (data.countCorrects +
                    data.countIncorrect +
                    data.countOmitted)) *
            100)
        .floorToDouble();

    if (count < 33) {
      return Colors.blueAccent;
    } else if (count < 66) {
      return Colors.greenAccent;
    } else {
      return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            /*for (int i = 0;
                i < quizSectionData.singleAudioExampleQuizData.length;
                i++)
               ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: SizedBox(
                  height: 50,
                  width: 50,
                  child: SimpleCircularProgressBar(
                    size: 50,
                    progressStrokeWidth: 5,
                    backStrokeWidth: 5,
                    startAngle: 0,
                    animationDuration: 0,
                    progressColors: [
                      getColor(quizSectionData.singleAudioExampleQuizData[i])
                    ],
                    valueNotifier: ValueNotifier(
                      getCount(quizSectionData.singleAudioExampleQuizData[i]),
                    ),
                  ),
                ),
                title: Text(
                    "audio progress for ${quizSectionData.singleAudioExampleQuizData[i].kanjiCharacter}"),
                subtitle: Text(
                    "correct ${quizSectionData.singleAudioExampleQuizData[i].countCorrects}, incorrect ${quizSectionData.singleAudioExampleQuizData[i].countIncorrect}, omitted ${quizSectionData.singleAudioExampleQuizData[i].countOmitted} "),
              ) */
          ],
        ),
      ),
    );
  }
}
