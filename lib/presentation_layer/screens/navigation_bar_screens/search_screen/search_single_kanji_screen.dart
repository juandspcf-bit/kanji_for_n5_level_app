import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/search_screen.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/search_single_kanji_provider.dart';

class SearchSingleKanjiScreen extends ConsumerWidget {
  const SearchSingleKanjiScreen({
    super.key,
    required this.kanjiCharacter,
  });

  final String kanjiCharacter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchSingleKanjiScreenState =
        ref.watch(searchSingleKanjiProvider(kanjiCharacter: kanjiCharacter));

    return Scaffold(
      appBar: AppBar(),
      body: searchSingleKanjiScreenState.when(
        data: (data) {
          return SingleChildScrollView(
            child: Results(
              kanjiFromApi: data,
            ),
          );
        },
        error: (_, e) {
          return const Center(
            child: Text("error"),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
