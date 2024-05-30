// ignore: unused_import

import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanji_list_tile_text/subtitle_tile.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/kanji_list_tile_text/title_tile.dart';

class FullTextTile extends StatelessWidget {
  const FullTextTile({
    super.key,
    required this.kanjiFromApi,
  });

  final KanjiFromApi kanjiFromApi;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleTile(
            kanjiFromApi: kanjiFromApi,
          ),
          const SizedBox(
            height: 5,
          ),
          SubTitleTile(
            kanjiFromApi: kanjiFromApi,
          ),
        ],
      ),
    );
  }
}
