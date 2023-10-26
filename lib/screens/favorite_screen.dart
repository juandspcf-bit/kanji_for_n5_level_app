import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_cached_provider.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_section_list.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({
    super.key,
    required this.isFromTabNav,
  });

  final bool isFromTabNav;

  @override
  ConsumerState<FavoriteScreen> createState() => FavoriteScreenState();
}

class FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  Widget buildScreen(List<String> myFavorites) {
    final sectionModel = SectionModel(
      title: "Favorites",
      sectionNumber: 0,
      kanjis: myFavorites,
    );

    return KanjiList(
      sectionModel: sectionModel,
      isFromTabNav: widget.isFromTabNav,
    );
  }

  @override
  Widget build(BuildContext context) {
    final myFavoritesCachedFromProvider = ref.watch(favoritesCachedProvider);
    return buildScreen(myFavoritesCachedFromProvider.map((e) => e.$3).toList());
  }
}
