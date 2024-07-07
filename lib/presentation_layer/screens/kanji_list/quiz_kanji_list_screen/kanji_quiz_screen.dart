import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/section_screen_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/animated_quiz_question_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/quiz_kanji_list_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/common_screens/error_screens.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/score_screen/score_body.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/welcome_screen/last_score_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/quiz_kanji_list_screen/welcome_screen/welcome_kanji_quiz_screen.dart';

class KanjiQuizScreen extends ConsumerWidget {
  const KanjiQuizScreen({
    super.key,
  });

  Widget getScreen(
    BuildContext context,
    ConnectionStatus resultStatus,
    QuizDataValues quizState,
    WidgetRef ref,
  ) {
    if (resultStatus == ConnectionStatus.noConnected) {
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
          final (countCorrects, countIncorrect, countOmitted) =
              ref.read(quizDataValuesProvider.notifier).getCounts();

          ref.read(lastScoreKanjiQuizProvider.notifier).setFinishedQuiz(
                section: ref.read(sectionProvider),
                uuid: ref.read(authServiceProvider).userUuid ?? '',
                countCorrects: countCorrects,
                countIncorrect: countIncorrect,
                countOmitted: countOmitted,
              );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.testYourKnowledge)),
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
