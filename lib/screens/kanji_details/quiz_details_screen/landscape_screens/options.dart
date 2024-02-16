import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/select_quiz_details_screen.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/kaji_details_screen.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/details_quizz_screen.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/flash_card/flash_card_quiz_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/last_score_details_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/last_score_flash_card_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/quiz_details_provider.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/sections_screen/section_screen_provider.dart';

class OptionsDetails extends ConsumerWidget {
  const OptionsDetails({super.key, required this.kanjiFromApi});

  final KanjiFromApi kanjiFromApi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            ref.read(quizDetailsProvider.notifier).setDataQuiz(kanjiFromApi);
            ref.read(quizDetailsProvider.notifier).setQuizState(0);
            ref
                .read(selectQuizDetailsProvider.notifier)
                .setScreen(ScreensQuizDetail.welcome);
            ref.read(selectQuizDetailsProvider.notifier).setOption(2);
            ref.read(flashCardProvider.notifier).initTheQuiz(kanjiFromApi);
            ref
                .read(lastScoreDetailsProvider.notifier)
                .getSingleAudioExampleQuizDataDB(
                  kanjiFromApi.kanjiCharacter,
                  ref.read(sectionProvider),
                  authService.user ?? '',
                );
            ref
                .read(lastScoreFlashCardProvider.notifier)
                .getSingleFlashCardDataDB(
                  kanjiFromApi.kanjiCharacter,
                  ref.read(sectionProvider),
                  authService.user ?? '',
                );

            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return DetailsQuizScreen(kanjiFromApi: kanjiFromApi);
              },
            ));
          },
          icon: const Icon(Icons.quiz),
          label: const Text('start a quiz'),
          style: ElevatedButton.styleFrom().copyWith(
            minimumSize: const MaterialStatePropertyAll(
              Size(300, 40),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton.icon(
          onPressed: () {
            ref
                .read(kanjiDetailsProvider.notifier)
                .storeToFavorites(kanjiFromApi);
          },
          icon: const IconFavorites(),
          label: const Text('add to favorites'),
          style: ElevatedButton.styleFrom().copyWith(
            minimumSize: const MaterialStatePropertyAll(
              Size(300, 40),
            ),
          ),
        ),
      ],
    ));
  }
}
