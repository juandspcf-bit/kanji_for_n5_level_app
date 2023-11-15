import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_details/strokes_images.dart';

class TabStrokes extends ConsumerWidget {
  const TabStrokes({
    super.key,
    required this.kanjiFromApi,
    required this.statusStorage,
  });

  final KanjiFromApi kanjiFromApi;
  final StatusStorage statusStorage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StrokesImages(
      kanjiFromApi: kanjiFromApi,
      statusStorage: statusStorage,
    );
  }
}
