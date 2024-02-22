import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/flash_card/flash_card_screen_landscape.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/quiz_details_screen/flash_card/flash_card_screen_portrait.dart';

class FlashCardsScreen extends ConsumerWidget {
  const FlashCardsScreen({
    super.key,
    required this.kanjiFromApi,
  });

  final KanjiFromApi kanjiFromApi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);

    return Orientation.portrait == orientation
        ? FlashCardScreenPortrait(kanjiFromApi: kanjiFromApi)
        : FlashCardScreenLandscape(kanjiFromApi: kanjiFromApi);
  }
}
