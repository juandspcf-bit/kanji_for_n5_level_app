import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/search_screen/list_kanjis_provider.dart';

class ListKanjisWidget extends ConsumerWidget {
  const ListKanjisWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listKanjiState = ref.watch(listKanjisStateProvider);

    return listKanjiState.when(
      data: (data) => ListView.builder(
          itemCount: data.kanjisCharacters.length,
          itemBuilder: (context, index) => Text(data.kanjisCharacters[index])),
      error: (_, e) {
        logger.e(e);
        return const Center(
          child: Text("error"),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
