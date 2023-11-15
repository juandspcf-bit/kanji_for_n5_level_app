import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/kanji_details_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/strokes_images.dart';

class TabStrokes extends ConsumerWidget {
  const TabStrokes({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kanjiDetailsData = ref.watch(kanjiDetailsProvider);
    final kanjiFromApi = kanjiDetailsData!.kanjiFromApi;
    final statusStorage = kanjiDetailsData.statusStorage;
    return StrokesImages(
      kanjiFromApi: kanjiFromApi,
      statusStorage: statusStorage,
    );
  }
}
