import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_list_screen/quiz_screen/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_list_screen/quiz_screen/quiz_question_screen_landscape.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_list_screen/quiz_screen/quiz_question_screen_portrait.dart';

class QuizQuestionScreen extends ConsumerWidget {
  const QuizQuestionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizDataValuesProvider);
    final orientation = MediaQuery.orientationOf(context);
    return Orientation.portrait == orientation
        ? SingleChildScrollView(
            child: Column(
              children: [
                QuizQuestionScreenPortrait(
                  isDraggedStatusList: quizState.isDraggedStatusList,
                  randomSolutions: quizState.randomSolutions,
                  kanjisToAskMeaning: quizState.kanjisToAskMeaning,
                  imagePathFromDraggedItems:
                      quizState.imagePathsFromDraggedItems,
                  initialOpacities: quizState.initialOpacities,
                  index: quizState.index,
                ),
              ],
            ),
          )
        : QuizQuestionScreenLandscape(
            isDraggedStatusList: quizState.isDraggedStatusList,
            randomSolutions: quizState.randomSolutions,
            kanjisToAskMeaning: quizState.kanjisToAskMeaning,
            imagePathFromDraggedItems: quizState.imagePathsFromDraggedItems,
            initialOpacities: quizState.initialOpacities,
            index: quizState.index,
          );
  }
}
