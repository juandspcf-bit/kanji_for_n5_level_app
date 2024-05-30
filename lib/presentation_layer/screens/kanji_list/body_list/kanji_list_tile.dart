// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanji_list_tile_text/full_text_tile.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/leading_tile.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanji_list_tile_text/subtitle_tile.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanji_list_tile_text/title_tile.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/trailing_tile.dart';

class KanjiListTile extends ConsumerWidget {
  const KanjiListTile({
    super.key,
    required this.kanjiFromApi,
  });

  final KanjiFromApi kanjiFromApi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LeadingTile(
            kanjiFromApi: kanjiFromApi,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FullTextTile(kanjiFromApi: kanjiFromApi),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            child: TrailingTile(
              kanjiFromApi: kanjiFromApi,
            ),
          )
        ],
      ),
    );
  }
}
