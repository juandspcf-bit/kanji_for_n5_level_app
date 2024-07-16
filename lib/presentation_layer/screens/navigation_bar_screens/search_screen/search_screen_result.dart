import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/l10n/localization.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/results_landscape.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/results_portrait.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/search_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/search_screen_result_provider.dart';

class SearchScreenResult extends ConsumerWidget {
  const SearchScreenResult({
    super.key,
    required this.word,
  });
  final String word;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.of(context).orientation;
    final searchResults = ref.watch(searchScreenResultProvider(word: word));
    return Scaffold(
      appBar: AppBar(),
      body: searchResults.when(
        data: (data) {
          if (data == null) {
            return Center(
              child: InfoStatusSearch(
                  message: context.l10n.searchMeaningWasNotFound),
            );
          }
          return orientation == Orientation.portrait
              ? SingleChildScrollView(
                  child: ResultsPortrait(kanjiFromApi: data))
              : ResultsLandscape(kanjiFromApi: data);
        },
        error: (_, e) {
          return Center(
            child: Text(
              "error",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
