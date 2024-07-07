import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/animated_quiz_flash_cards.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/animated_quiz_question_details.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/quiz_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/score_quiz_details/quiz_score_details.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/welcome_screen/welcome_kanji_details_quiz_screen.dart';

class DetailsQuizScreen extends ConsumerWidget {
  const DetailsQuizScreen({
    super.key,
  });

  String _getTitle(Screen screen, BuildContext context) {
    switch (screen) {
      case Screen.flashCards:
        return context.l10n.flashCardsTitle;
      case Screen.question:
        return context.l10n.guessTheRightMeaning;
      case Screen.score:
        return context.l10n.testYourKnowledge;
      default:
        return context.l10n.testYourKnowledge;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizDetailsData = ref.watch(quizDetailsProvider);
    return PopScope(
      onPopInvoked: (didPop) {},
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _getTitle(
              quizDetailsData.currentScreenType,
              context,
            ),
          ),
        ),
        body: Builder(
          builder: (context) {
            switch (quizDetailsData.currentScreenType) {
              case Screen.question:
                return AnimatedQuizQuestionDetails(
                  windowWidth: MediaQuery.sizeOf(context).width,
                );
              case Screen.flashCards:
                return AnimatedQuizFlashCardsDetails(
                  windowWidth: MediaQuery.sizeOf(context).width,
                );
              case Screen.score:
                return const QuizScoreDetails();
              default:
                return const QuizWelcomeDetails();
            }
          },
        ),
      ),
    );
  }
}
