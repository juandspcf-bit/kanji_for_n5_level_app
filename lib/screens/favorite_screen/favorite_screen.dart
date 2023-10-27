import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/networking/request_api.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_cached_provider.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_kanjis_providers.dart';
import 'package:kanji_for_n5_level_app/screens/favorite_screen/body_list.dart';
import 'package:kanji_for_n5_level_app/screens/kaji_details.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({
    super.key,
    //required this.isFromTabNav,
  });

  //final bool isFromTabNav;

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  void navigateToKanjiDetails(
    BuildContext context,
    KanjiFromApi? kanjiFromApi,
  ) {
    if (kanjiFromApi == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) {
        return KanjiDetails(
          kanjiFromApi: kanjiFromApi,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kanjis = ref.watch(favoritesCachedProvider);
    int status = 0;
    if (kanjis.isNotEmpty) {
      status = 1;
    }
    return BodyKanjisList(
      statusResponse: status,
      kanjisModel: kanjis,
      navigateToKanjiDetails: navigateToKanjiDetails,
    );
  }
}
