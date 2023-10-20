import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_kanjis_providers.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_section_list.dart';

class FavoriteScreen extends ConsumerWidget {
  const FavoriteScreen({
    super.key,
    required this.isFromTabNav,
  });

  final bool isFromTabNav;

  Widget buildScreen() {
    final myFavorites = myFavoritesCached.map((e) => e.$3).toList();

    final sectionModel = SectionModel(
      title: "Favorites",
      sectionNumber: 0,
      kanjis: myFavorites,
    );

    return KanjiList(
      sectionModel: sectionModel,
      isFromTabNav: isFromTabNav,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return buildScreen();
  }
}
