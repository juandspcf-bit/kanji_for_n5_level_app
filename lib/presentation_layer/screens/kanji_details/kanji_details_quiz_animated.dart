import 'package:animations/animations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/details_quizz_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/flash_card/flash_card_quiz_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/last_score_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/last_score_flash_card_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/quiz_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/section_screen_provider.dart';
import 'package:kanji_for_n5_level_app/providers/select_quiz_details_screen.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class KanjiDetailsQuizAnimated extends ConsumerWidget {
  const KanjiDetailsQuizAnimated({
    super.key,
    required this.kanjiFromApi,
    required this.closedChild,
  });

  final KanjiFromApi kanjiFromApi;
  final Widget closedChild;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 900),
      openBuilder: (context, closedContainer) {
        return DetailsQuizScreen(
          kanjiFromApi: kanjiFromApi,
        );
      },
      openColor: Colors.transparent,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      closedElevation: 0,
      closedColor: Colors.transparent,
      closedBuilder: (context, openContainer) {
        final statusConnectionData = ref.watch(statusConnectionProvider);

        final accesToQuiz = statusConnectionData == ConnectivityResult.none &&
            kanjiFromApi.statusStorage == StatusStorage.onlyOnline;

        return GestureDetector(
          onTap: accesToQuiz
              ? () {
                  ref
                      .read(quizDetailsProvider.notifier)
                      .setDataQuiz(kanjiFromApi);
                  ref.read(quizDetailsProvider.notifier).setQuizState(0);
                  ref
                      .read(selectQuizDetailsProvider.notifier)
                      .setScreen(ScreensQuizDetail.welcome);
                  ref.read(selectQuizDetailsProvider.notifier).setOption(2);
                  ref
                      .read(flashCardProvider.notifier)
                      .initTheQuiz(kanjiFromApi);
                  ref
                      .read(lastScoreDetailsProvider.notifier)
                      .getSingleAudioExampleQuizDataDB(
                        kanjiFromApi.kanjiCharacter,
                        ref.read(sectionProvider),
                        authService.userUuid ?? '',
                      );
                  ref
                      .read(lastScoreFlashCardProvider.notifier)
                      .getSingleFlashCardDataDB(
                        kanjiFromApi.kanjiCharacter,
                        ref.read(sectionProvider),
                        authService.userUuid ?? '',
                      );

                  openContainer();
                }
              : null,
          child: closedChild,
        );
      },
    );
  }
}
