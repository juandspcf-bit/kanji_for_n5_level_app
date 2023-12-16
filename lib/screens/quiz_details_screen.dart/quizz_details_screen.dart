import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/select_quiz_details_screen.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/error_connection_tabs.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_details_screen.dart/flash_card_screen.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_details_screen.dart/quiz_details_question.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_details_screen.dart/quiz_details_score.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_details_screen.dart/welcome_kanji_details_quiz_screen.dart';

class QuizDetailsScreen extends ConsumerWidget {
  const QuizDetailsScreen({super.key, required this.kanjiFromApi});

  final KanjiFromApi kanjiFromApi;

  Widget _selectScreen(
      ConnectivityResult resultStatus, ScreensQuizDetail screenNumber) {
    if (resultStatus == ConnectivityResult.none &&
        kanjiFromApi.statusStorage == StatusStorage.onlyOnline) {
      return const ErrorConnectionScreen(
        message: 'The internet connection has gone, restart the quiz later',
      );
    } else if (screenNumber == ScreensQuizDetail.welcome) {
      return const WelcomeKanjiDetailsQuizScreen();
    } else if (screenNumber == ScreensQuizDetail.quizSelections) {
      return QuestionScreen(kanjiFromApi: kanjiFromApi);
    } else if (screenNumber == ScreensQuizDetail.scoreSelections) {
      return const QuizDetailsScore();
    } else if (screenNumber == ScreensQuizDetail.quizFlashCard) {
      return FlassCardScreen(kanjiFromApi: kanjiFromApi);
    } else {
      return const Center(
        child: Text('Error'),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultStatus = ref.watch(statusConnectionProvider);
    final screenNumber = ref.watch(selectQuizDetailsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Test your knowledge',
        ),
      ),
      body: _selectScreen(resultStatus, screenNumber.screensQuizDetail),
    );
  }
}
