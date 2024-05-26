import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_audio_example_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_flash_card_data.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class AudioData extends StatelessWidget {
  const AudioData({
    super.key,
    required this.singleAudioExampleQuizData,
    required this.kanjiCharacter,
  });

  final List<SingleAudioExampleQuizData> singleAudioExampleQuizData;
  final String kanjiCharacter;

  double getCountAudioQuiz(SingleAudioExampleQuizData data) {
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

  @override
  Widget build(BuildContext context) {
    double progress;
    int countCorrects;
    int countIncorrect;
    int countOmitted;

    try {
      final data = singleAudioExampleQuizData
          .firstWhere((data) => data.kanjiCharacter == kanjiCharacter);
      progress = getCountAudioQuiz(data);
      countCorrects = data.countCorrects;
      countIncorrect = data.countIncorrect;
      countOmitted = data.countOmitted;
    } catch (e) {
      progress = 0;
      countCorrects = 0;
      countIncorrect = 0;
      countOmitted = 0;
    }

    return SizedBox(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "audio progress",
            style: TextStyle(fontWeight: FontWeight.w600),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: 50,
              width: 50,
              child: SimpleCircularProgressBar(
                size: 50,
                progressStrokeWidth: 5,
                backStrokeWidth: 5,
                startAngle: 0,
                animationDuration: 0,
                progressColors: const [
                  Colors.blueAccent,
                  Colors.amber,
                  Colors.red
                ],
                valueNotifier: ValueNotifier(
                  progress,
                ),
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("correct: $countCorrects"),
                Text("incorrect: $countIncorrect"),
                Text("omitted: $countOmitted"),
              ],
            ),
          ]),
        ],
      ),
    );
  }
}
