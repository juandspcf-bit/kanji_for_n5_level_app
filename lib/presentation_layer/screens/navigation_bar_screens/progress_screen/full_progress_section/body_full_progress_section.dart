import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/models/quiz_section_data.dart';
import 'package:kanji_for_n5_level_app/models/section_model.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_audio_example_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_flash_card_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_section_data.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class BodyFullProgressSection extends ConsumerWidget {
  const BodyFullProgressSection({
    super.key,
    required this.quizSectionData,
  });

  final QuizSectionData quizSectionData;

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

  Widget getAudioData(
      List<SingleAudioExampleQuizData> singleAudioExampleQuizData,
      String kanjiCharacter) {
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

  Widget getFlashCardData(List<SingleQuizFlashCardData> singleQuizFlashCardData,
      String kanjiCharacter) {
    bool allRevisedFlashCards;
    try {
      final data = singleQuizFlashCardData
          .firstWhere((data) => data.kanjiCharacter == kanjiCharacter);
      allRevisedFlashCards = data.allRevisedFlashCards;
    } catch (e) {
      allRevisedFlashCards = false;
    }

    return SizedBox(
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "flash cards progress",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              width: 30,
            ),
            allRevisedFlashCards
                ? SvgPicture.asset(
                    "assets/icons/done.svg",
                    width: 50,
                    height: 50,
                  )
                : SvgPicture.asset(
                    "assets/icons/undone_red.svg",
                    width: 50,
                    height: 50,
                  ),
            const SizedBox(
              width: 10,
            ),
            Text(allRevisedFlashCards ? "all revised" : "not all revised"),
          ]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjisCharacters =
        listSections[quizSectionData.singleQuizSectionData.section - 1]
            .kanjisCharacters;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  bottom: 40,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Kanji quiz progress",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .fontSize),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: SimpleCircularProgressBar(
                        size: 100,
                        progressStrokeWidth: 10,
                        backStrokeWidth: 10,
                        startAngle: 0,
                        animationDuration: 0,
                        progressColors: const [
                          Colors.blueAccent,
                          Colors.amber,
                          Colors.red
                        ],
                        valueNotifier: ValueNotifier(
                          getCountKanjiQuiz(
                              quizSectionData.singleQuizSectionData),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                        "correct: ${quizSectionData.singleQuizSectionData.countCorrects}, incorrect: ${quizSectionData.singleQuizSectionData.countIncorrect}, omitted: ${quizSectionData.singleQuizSectionData.countOmitted} "),
                  ],
                ),
              ),
              for (int i = 0; i < kanjisCharacters.length; i++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Text(
                        kanjisCharacters[i],
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: getAudioData(
                              quizSectionData.singleAudioExampleQuizData,
                              kanjisCharacters[i]),
                        ),
                        Expanded(
                          child: getFlashCardData(
                              quizSectionData.singleQuizFlashCardData,
                              kanjisCharacters[i]),
                        ),
                      ],
                    ),
                    const Divider()
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
