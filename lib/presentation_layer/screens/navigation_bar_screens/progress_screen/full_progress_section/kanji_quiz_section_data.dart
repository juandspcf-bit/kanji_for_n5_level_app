import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/models/quiz_section_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_section_data.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class KanjiQuizSectionData extends StatelessWidget {
  const KanjiQuizSectionData({
    super.key,
    required this.quizSectionData,
  });

  double getCountKanjiQuiz(SingleQuizSectionData data) {
    if (data.countCorrects == 0 &&
        data.countIncorrect == 0 &&
        data.countOmitted == 0) return 0;
    return ((data.countCorrects /
                (data.countCorrects +
                    data.countIncorrect +
                    data.countOmitted)) *
            100)
        .floorToDouble();
  }

  final QuizSectionData quizSectionData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            "Kanji quiz progress",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: Theme.of(context).textTheme.titleMedium!.fontSize),
          ),
        ),
        SizedBox(
          height: 100,
          width: 100,
          child: SimpleCircularProgressBar(
            mergeMode: true,
            size: 100,
            progressStrokeWidth: 10,
            backStrokeWidth: 10,
            startAngle: 0,
            animationDuration: 0,
            progressColors: const [
              Colors.blueAccent,
              Colors.green,
              Colors.amber,
            ],
            valueNotifier: ValueNotifier(
              getCountKanjiQuiz(quizSectionData.singleQuizSectionData),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
            "correct: ${quizSectionData.singleQuizSectionData.countCorrects}, incorrect: ${quizSectionData.singleQuizSectionData.countIncorrect}, omitted: ${quizSectionData.singleQuizSectionData.countOmitted} "),
      ],
    );
  }
}
