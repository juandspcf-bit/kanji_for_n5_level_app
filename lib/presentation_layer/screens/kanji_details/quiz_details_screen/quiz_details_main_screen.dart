import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/flash_card/flash_card_quiz_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/flash_card/flash_card_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/flash_card/flash_card_widget.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/last_score_flash_card_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/quiz_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/quiz_details_question.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/welcome_screen/welcome_kanji_details_quiz_screen.dart';

class DetailsQuizScreen extends ConsumerWidget {
  const DetailsQuizScreen({super.key, required this.kanjiFromApi});

  final KanjiFromApi kanjiFromApi;

  Widget _getScreen(QuizDetailsData quizDetailsData, WidgetRef ref) {
    if (quizDetailsData.currentScreenType == Screen.quiz) {
      return QuizDetailsScreen(kanjiFromApi: kanjiFromApi);
    } else if (quizDetailsData.currentScreenType == Screen.flashCards) {
      return FlashCardsScreen(kanjiFromApi: kanjiFromApi);
    } else {
      return WelcomeScreen(
        kanjiFromApi: kanjiFromApi,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizDetailsData = ref.watch(quizDetailsProvider);
    return PopScope(
      onPopInvoked: (didPop) {
        if (quizDetailsData.currentScreenType == Screen.flashCards) {
          ref.read(lastScoreFlashCardProvider.notifier).setFinishedFlashCard(
                kanjiCharacter: kanjiFromApi.kanjiCharacter,
                section: kanjiFromApi.section,
                uuid: authService.userUuid ?? '',
                countUnWatched: ref
                    .read(flashCardProvider.notifier)
                    .answers
                    .where((element) => !element)
                    .length,
              );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Test your knowledge',
          ),
        ),
        body: _getScreen(quizDetailsData, ref),
      ),
    );
  }
}
