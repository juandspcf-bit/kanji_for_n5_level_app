import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/quiz_section_data.dart';
import 'package:kanji_for_n5_level_app/models/section_model.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/full_progress_section/audio_data.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/full_progress_section/flash_card_data.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/full_progress_section/kanji_character_title.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/progress_screen/full_progress_section/kanji_quiz_section_data.dart';

class BodyFullProgressSectionLandscape extends ConsumerWidget {
  const BodyFullProgressSectionLandscape({
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: KanjiQuizSectionData(
                quizSectionData: quizSectionData,
              ),
            ),
            Expanded(
              flex: 1,
              child: ListView(
                children: [
                  for (int i = 0; i < kanjisCharacters.length; i++)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        KanjiCharacterTitle(
                          kanjisCharacters: kanjisCharacters,
                          index: i,
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
                                kanjiCharacter: kanjisCharacters[i],
                                leftPadding: 10,
                              ),
                            )
                          ],
                        ),
                        const Divider()
                      ],
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
