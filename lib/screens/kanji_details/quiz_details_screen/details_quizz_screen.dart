import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/flash_card/flash_card_quiz_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/welcome_kanji_details_quiz_screen.dart';

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
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) {
          logger.d(ref.read(flashCardProvider.notifier).answers);
          //TODO store to db
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Test your knowledge',
          ),
        ),
        //body: _selectScreen(resultStatus, screenNumber.screensQuizDetail),
        body: WelcomeKanjiDetailsQuizScreen(
          kanjiFromApi: kanjiFromApi,
        ),
      ),
    );
  }
}
