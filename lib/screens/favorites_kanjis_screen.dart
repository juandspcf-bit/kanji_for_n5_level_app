import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_kanjis_providers.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_section_list.dart';

class FavoritesKanjisScreen extends StatelessWidget {
  const FavoritesKanjisScreen({super.key, required this.isFromTabNav});

  final bool isFromTabNav;

  @override
  Widget build(BuildContext context) {
    final myFavoritesCachedList = myFavoritesCached
        .map(
          (e) => e.$3,
        )
        .toList();

    final sectionModel = SectionModel(
      title: "Favorites",
      sectionNumber: 0,
      kanjis: myFavoritesCachedList,
    );

    return KanjiList(
      sectionModel: sectionModel,
      isFromTabNav: isFromTabNav,
    );
  }
}
