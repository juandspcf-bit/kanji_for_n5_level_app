import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/flash_card/flash_card_screen_landscape.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_details/quiz_details_screen/flash_card/flash_card_screen_portrait.dart';

class FlashCardsDetails extends ConsumerWidget {
  const FlashCardsDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.orientationOf(context);

    return Orientation.portrait == orientation
        ? const FlashCardScreenPortrait()
        : const FlashCardScreenLandscape();
  }
}
