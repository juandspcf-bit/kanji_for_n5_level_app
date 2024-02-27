import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/sections_screen/section_screen_provider.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/screens/common_screens.dart/error_connection_screen.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/quiz_question_screen.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/score_screen/score_body.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/welcome_screen/last_score_provider.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_kanji_screen/welcome_screen/welcome_kanji_quiz_screen.dart';

class KanjiQuizScreen extends ConsumerWidget {
  const KanjiQuizScreen({
    super.key,
    required this.kanjisFromApi,
  });

  final List<KanjiFromApi> kanjisFromApi;

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

  Widget getScreen(ConnectivityResult resultStatus, QuizDataValues quizState,
      WidgetRef ref) {
    if (resultStatus == ConnectivityResult.none) {
      return const ErrorConnectionScreen(
        message: 'The internet connection has gone, restart the quiz later',
      );
    } else if (quizState.currentScreenType == Screens.score) {
      final (countCorrects, countIncorrects, countOmited) = getCounts(
        quizState.isCorrectAnswer,
        quizState.isOmittedAnswer,
      );

      ref.read(lastScoreKanjiQuizProvider.notifier).setFinishedQuiz(
            section: ref.read(sectionProvider),
            uuid: authService.user ?? '',
            countCorrects: countCorrects,
            countIncorrects: countIncorrects,
            countOmited: countOmited,
          );

      return const Center(
        child: ScoreBodyQuizKanjiList(),
      );
    } else if (quizState.currentScreenType == Screens.quiz) {
      return const SingleChildScrollView(
        child: Column(
          children: [
            QuizQuestionScreen(),
          ],
        ),
      );
    } else if (quizState.currentScreenType == Screens.welcome) {
      return const Center(child: WelcomeKanjiListQuizScreen());
    } else {
      return const Center(
        child: Text('nothing to show'),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultStatus = ref.watch(statusConnectionProvider);
    final quizState = ref.watch(quizDataValuesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Test your knowledge")),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 0,
          bottom: 0,
          right: 30,
          left: 30,
        ),
        child: getScreen(resultStatus, quizState, ref),
      ),
    );
  }
}
