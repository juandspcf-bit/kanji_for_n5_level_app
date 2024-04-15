// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/body_list/leading_tile.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/body_list/subtitle_tile.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/body_list/title_tile.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/body_list/trailing_tile.dart';

class KanjiItem extends ConsumerWidget {
  const KanjiItem({
    super.key,
    required this.kanjiFromApi,
  });

  final KanjiFromApi kanjiFromApi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
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
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                child: TrailingTile(
                  kanjiFromApi: kanjiFromApi,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
