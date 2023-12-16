import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/error_connection_tabs.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/quiz_question_screen.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/score_body.dart';
import 'package:kanji_for_n5_level_app/screens/quiz_screen/welcome_kanji_list_quiz_screen.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({
    super.key,
    required this.kanjisFromApi,
  });

  final List<KanjiFromApi> kanjisFromApi;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  void showSnackBarQuizz(String message, int duration) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: duration),
        content: Text(message),
      ),
    );
  }

  Widget getScreen(ConnectivityResult resultStatus, QuizDataValues quizState) {
    if (resultStatus == ConnectivityResult.none) {
      return const ErrorConnectionScreen(
        message: 'The internet connection has gone, restart the quiz later',
      );
    } else if (quizState.currentScreenType == Screens.score) {
      return Center(
        child: ScoreBody(
          isCorrectAnswer: quizState.isCorrectAnswer,
          isOmittedAnswer: quizState.isOmittedAnswer,
          resetTheQuiz: ref.read(quizDataValuesProvider.notifier).resetTheQuiz,
        ),
      );
    } else if (quizState.currentScreenType == Screens.quiz) {
      return SingleChildScrollView(
        child: Column(
          children: [
            QuizQuestionScreen(
              isDraggedStatusList: quizState.isDraggedStatusList,
              randomSolutions: quizState.randomSolutions,
              kanjisToAskMeaning: quizState.kanjisToAskMeaning,
              imagePathFromDraggedItems: quizState.imagePathsFromDraggedItems,
              initialOpacities: quizState.initialOpacities,
              index: quizState.index,
            ),
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
  Widget build(BuildContext context) {
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
        child: getScreen(resultStatus, quizState),
      ),
    );
  }
}
