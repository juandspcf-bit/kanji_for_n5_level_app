import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kanji_for_n5_level_app/models/quiz_section_data.dart';
import 'package:kanji_for_n5_level_app/models/section_model.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_audio_example_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_flash_card_data.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class BodyFullProgressSection extends ConsumerWidget {
  const BodyFullProgressSection({
    super.key,
    required this.quizSectionData,
  });

  final QuizSectionData quizSectionData;

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

  Widget getAudioData(
      List<SingleAudioExampleQuizData> singleAudioExampleQuizData,
      String kanjiCharacter) {
    Color color;
    double progress;
    int countCorrects;
    int countIncorrect;
    int countOmitted;

    try {
      final data = singleAudioExampleQuizData
          .firstWhere((data) => data.kanjiCharacter == kanjiCharacter);
      color = getColor(data);
      progress = getCount(data);
      countCorrects = data.countCorrects;
      countIncorrect = data.countIncorrect;
      countOmitted = data.countOmitted;
    } catch (e) {
      color = Colors.blueAccent;
      progress = 0;
      countCorrects = 0;
      countIncorrect = 0;
      countOmitted = 0;
    }

    return SizedBox(
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "audio progress",
            style: TextStyle(fontWeight: FontWeight.w600),
            textAlign: TextAlign.start,
          ),
          ListTile(
            //contentPadding: const EdgeInsets.symmetric(vertical: 10),
            leading: SizedBox(
              height: 50,
              width: 50,
              child: SimpleCircularProgressBar(
                size: 50,
                progressStrokeWidth: 5,
                backStrokeWidth: 5,
                startAngle: 0,
                animationDuration: 0,
                progressColors: [color],
                valueNotifier: ValueNotifier(
                  progress,
                ),
              ),
            ),
            /*           title: const Padding(
              padding: EdgeInsets.only(bottom: 7),
              child: Text("audio progress",
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ), */
            subtitle: Text(
                "correct $countCorrects, incorrect $countIncorrect, omitted $countOmitted "),
          ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "flash cards progress",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          ListTile(
            //contentPadding: const EdgeInsets.symmetric(vertical: 10),
            leading: allRevisedFlashCards
                ? SvgPicture.asset(
                    "assets/icons/done.svg",
                    width: 50,
                    height: 50,
                  )
                : SvgPicture.asset(
                    "assets/icons/undone.svg",
                    width: 50,
                    height: 50,
                  ),
            subtitle: Text(allRevisedFlashCards
                ? "all revised flash cards"
                : "no all the cards revised"),
          ),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              for (int i = 0; i < kanjisCharacters.length; i++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
