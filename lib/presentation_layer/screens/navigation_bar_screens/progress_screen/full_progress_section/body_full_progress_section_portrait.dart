import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/quiz_section_data.dart';
import 'package:kanji_for_n5_level_app/models/section_model.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/full_progress_section/audio_data.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/full_progress_section/flash_card_data.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/utils.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class BodyFullProgressSectionPortrait extends ConsumerWidget {
  const BodyFullProgressSectionPortrait({
    super.key,
    required this.quizSectionData,
  });

  final QuizSectionData quizSectionData;

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
                          child: AudioData(
                            singleAudioExampleQuizData:
                                quizSectionData.singleAudioExampleQuizData,
                            kanjiCharacter: kanjisCharacters[i],
                          ),
                        ),
                        Expanded(
                          child: FlashCardSectionData(
                              singleQuizFlashCardData:
                                  quizSectionData.singleQuizFlashCardData,
                              kanjiCharacter: kanjisCharacters[i]),
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
