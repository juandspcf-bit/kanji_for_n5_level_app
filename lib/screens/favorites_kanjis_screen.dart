import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_kanjis_providers.dart';
import 'package:kanji_for_n5_level_app/screens/kanji_section_list.dart';

class FavoritesKanjisScreen extends StatefulWidget {
  const FavoritesKanjisScreen({super.key, required this.isFromTabNav});

  final bool isFromTabNav;

  @override
  State<FavoritesKanjisScreen> createState() => _FavoritesKanjisScreenState();
}

class _FavoritesKanjisScreenState extends State<FavoritesKanjisScreen> {
  late List<String> myFavoritesCachedList;
  late SectionModel sectionModel;

  void updateList() {
    print("is updated");
    myFavoritesCachedList = myFavoritesCached
        .map(
          (e) => e.$3,
        )
        .toList();
    setState(() {
      sectionModel = SectionModel(
        title: "Favorites",
        sectionNumber: 0,
        kanjis: myFavoritesCachedList,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    myFavoritesCachedList = myFavoritesCached
        .map(
          (e) => e.$3,
        )
        .toList();

    sectionModel = SectionModel(
      title: "Favorites",
      sectionNumber: 0,
      kanjis: myFavoritesCachedList,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("is updated2");
    return KanjiList(
      sectionModel: sectionModel,
      isFromTabNav: widget.isFromTabNav,
      updateList: updateList,
    );
  }
}
