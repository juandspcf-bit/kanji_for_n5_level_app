import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_firebase_impl/auth_service_firebase.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_details_score_screen.dart';
import 'package:kanji_for_n5_level_app/providers/select_quiz_details_screen.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/common_screens.dart/error_connection_screen.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/sections_screen/section_screen_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen.dart/flash_card_screen.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen.dart/last_score_details_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen.dart/quiz_details_question.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen.dart/quiz_details_score.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen.dart/welcome_kanji_details_quiz_screen.dart';

class DetailsQuizScreen extends ConsumerWidget {
  const DetailsQuizScreen({super.key, required this.kanjiFromApi});

  final KanjiFromApi kanjiFromApi;

  (int, int, int) getCounts(
    List<bool> isCorrectAnswer,
    List<bool> isOmittedAnswer,
  ) {
    int countCorrects = isCorrectAnswer.map((e) {
      if (e == true) {
        return 1;
      }
      return 0;
    }).reduce((value, element) => value + element);

    int countOmited = isOmittedAnswer.map((e) {
      if (e == true) {
        return 1;
      }
      return 0;
    }).reduce((value, element) => value + element);

    int countIncorrects = isCorrectAnswer.length - countCorrects - countOmited;

    return (countCorrects, countIncorrects, countOmited);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultStatus = ref.watch(statusConnectionProvider);
    final screenNumber = ref.watch(selectQuizDetailsProvider);
    final scores = ref.watch(quizDetailsScoreProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Test your knowledge',
        ),
      ),
      //body: _selectScreen(resultStatus, screenNumber.screensQuizDetail),
      body: Builder(
        builder: (context) {
          if (resultStatus == ConnectivityResult.none &&
              kanjiFromApi.statusStorage == StatusStorage.onlyOnline) {
            return const ErrorConnectionScreen(
              message:
                  'The internet connection has gone, restart the quiz later',
            );
          } else if (screenNumber.screensQuizDetail ==
              ScreensQuizDetail.welcome) {
            return const WelcomeKanjiDetailsQuizScreen();
          } else if (screenNumber.screensQuizDetail ==
              ScreensQuizDetail.quizSelections) {
            return QuestionScreen(kanjiFromApi: kanjiFromApi);
          } else if (screenNumber.screensQuizDetail ==
              ScreensQuizDetail.scoreSelections) {
            ref.read(lastScoreDetailsProvider.notifier).setFinishedQuiz(
                  section: ref.read(sectionProvider),
                  uuid: authService.user ?? '',
                  countCorrects: scores.correctAnswers.length,
                  countIncorrects: scores.incorrectAnwers.length,
                  countOmited: scores.omitted.length,
                );
            return const QuizDetailsScore();
          } else if (screenNumber.screensQuizDetail ==
              ScreensQuizDetail.quizFlashCard) {
            return FlassCardScreen(kanjiFromApi: kanjiFromApi);
          } else {
            return const Center(
              child: Text('Error'),
            );
          }
        },
      ),
    );
  }
}
