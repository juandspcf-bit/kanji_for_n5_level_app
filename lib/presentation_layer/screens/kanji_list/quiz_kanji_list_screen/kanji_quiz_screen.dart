import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/auth_service/auth_service_firebase.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/section_screen_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/animated_quiz_question_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/error_connection_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/score_screen/score_body.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/welcome_screen/last_score_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/welcome_screen/welcome_kanji_quiz_screen.dart';

class KanjiQuizScreen extends ConsumerWidget {
  const KanjiQuizScreen({
    super.key,
    required this.kanjisFromApi,
  });

  final List<KanjiFromApi> kanjisFromApi;

  Widget getScreen(
    BuildContext context,
    ConnectivityResult resultStatus,
    QuizDataValues quizState,
    WidgetRef ref,
  ) {
    if (resultStatus == ConnectivityResult.none) {
      return const ErrorConnectionScreen(
        message: 'The internet connection has gone, restart the quiz later',
      );
    } else if (quizState.currentScreenType == Screens.score) {
      return const Center(
        child: ScoreBodyQuizKanjiList(),
      );
    } else if (quizState.currentScreenType == Screens.quiz) {
      return AnimatesQuizQuestionScreen(
        windowWidth: MediaQuery.sizeOf(context).width,
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

    return PopScope(
      onPopInvoked: (didPop) {
        if (quizState.currentScreenType == Screens.score) {
          final (countCorrects, countIncorrects, countOmited) =
              ref.read(quizDataValuesProvider.notifier).getCounts();

          ref.read(lastScoreKanjiQuizProvider.notifier).setFinishedQuiz(
                section: ref.read(sectionProvider),
                uuid: ref.read(authServiceProvider).userUuid ?? '',
                countCorrects: countCorrects,
                countIncorrects: countIncorrects,
                countOmited: countOmited,
              );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Test your knowledge")),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: getScreen(
            context,
            resultStatus,
            quizState,
            ref,
          ),
        ),
      ),
    );
  }
}
