import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/flash_card/flash_card_quiz_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/quiz_details_main_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/last_score_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/last_score_flash_card_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_kanji_details_screen/quiz_details_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/video_widget/video_player_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/tabs_details/tab_media/video_widget/video_status_playing.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/sections_screen/section_screen_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class DetailsQuizScreenAnimated extends ConsumerWidget {
  const DetailsQuizScreenAnimated({
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

        final accessToQuiz =
            statusConnectionData == ConnectionStatus.noConnected &&
                kanjiFromApi.statusStorage == StatusStorage.onlyOnline;

        return GestureDetector(
          onTap: !accessToQuiz
              ? () {
                  ref
                      .read(quizDetailsProvider.notifier)
                      .setDataQuiz(kanjiFromApi);
                  ref.read(quizDetailsProvider.notifier).setQuizState(0);

                  ref
                      .read(flashCardProvider.notifier)
                      .initTheQuiz(kanjiFromApi);

                  ref
                      .read(lastScoreDetailsProvider.notifier)
                      .getSingleAudioExampleQuizDataDB(
                        kanjiFromApi.kanjiCharacter,
                        ref.read(sectionProvider),
                        ref.read(authServiceProvider).userUuid ?? '',
                      );

                  ref
                      .read(lastScoreFlashCardProvider.notifier)
                      .getSingleFlashCardDataDB(
                        kanjiFromApi.kanjiCharacter,
                        ref.read(sectionProvider),
                        ref.read(authServiceProvider).userUuid ?? '',
                      );

                  ref
                      .read(quizDetailsProvider.notifier)
                      .setScreen(Screen.welcome);
                  ref.read(quizDetailsProvider.notifier).setOption(2);
                  ref.read(quizDetailsProvider.notifier).resetValues();

/*                   //pause video player
                  ref
                      .read(videoPlayerObjectProvider)
                      .videoPlayerController
                      .pause();
                  ref
                      .read(videoStatusPlayingProvider.notifier)
                      .setIsPlaying(false); */

                  openContainer();
                }
              : null,
          child: closedChild,
        );
      },
    );
  }
}
