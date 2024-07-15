import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/svg_utils/svg_utils.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/meaning_search.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/search_screen.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class ResultsPortrait extends ConsumerWidget {
  const ResultsPortrait({super.key, required this.kanjiFromApi});
  final KanjiFromApi kanjiFromApi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: SvgNetwork(
              imageUrl: kanjiFromApi.strokes.images.last,
              semanticsLabel: kanjiFromApi.kanjiCharacter,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          MeaningSearch(
            englishMeaning: kanjiFromApi.englishMeaning,
            hiraganaRomaji: kanjiFromApi.hiraganaRomaji,
            hiraganaMeaning: kanjiFromApi.hiraganaMeaning,
            katakanaRomaji: kanjiFromApi.katakanaRomaji,
            katakanaMeaning: kanjiFromApi.katakanaMeaning,
          ),
          const SizedBox(
            height: 20,
          ),
          ExampleAudiosSearch(
            examples: kanjiFromApi.example,
            statusStorage: StatusStorage.onlyOnline,
            physics: const NeverScrollableScrollPhysics(),
          ) /**/
        ],
      ),
    );
  }
}
