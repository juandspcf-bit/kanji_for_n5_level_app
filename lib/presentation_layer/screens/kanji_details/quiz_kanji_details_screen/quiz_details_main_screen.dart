import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/animated_quiz_flash_cards.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/animated_quiz_question_details.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/quiz_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/score_quiz_details/quiz_score_details.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/welcome_screen/welcome_kanji_details_quiz_screen.dart';

class DetailsQuizScreen extends ConsumerWidget {
  const DetailsQuizScreen({super.key, required this.kanjiFromApi});

  final KanjiFromApi kanjiFromApi;

  String _getTitle(Screen screen) {
    switch (screen) {
      case Screen.flashCards:
        return 'Review what you have learn';
      case Screen.question:
        return 'Guess the right meaning';
      case Screen.score:
        return 'Your score';
      default:
        return 'Test your knowledge';
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
            _getTitle(quizDetailsData.currentScreenType),
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
