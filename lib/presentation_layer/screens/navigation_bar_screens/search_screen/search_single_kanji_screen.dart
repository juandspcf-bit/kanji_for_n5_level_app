import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/results_landscape.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/results_portrait.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/search_single_kanji_provider.dart';

class SearchSingleKanjiScreen extends ConsumerWidget {
  const SearchSingleKanjiScreen({
    super.key,
    required this.kanjiCharacter,
  });

  final String kanjiCharacter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orientation = MediaQuery.of(context).orientation;
    final searchSingleKanjiScreenState =
        ref.watch(searchSingleKanjiProvider(kanjiCharacter: kanjiCharacter));

    return Scaffold(
      appBar: AppBar(),
      body: searchSingleKanjiScreenState.when(
        data: (data) {
          return orientation == Orientation.portrait
              ? SingleChildScrollView(
                  child: ResultsPortrait(kanjiFromApi: data))
              : ResultsLandscape(kanjiFromApi: data);
        },
        error: (_, e) {
          return Center(
            child: Text("error", style: Theme.of(context).textTheme.titleLarge),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
