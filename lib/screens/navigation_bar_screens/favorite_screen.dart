import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/body_list.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({
    super.key,
  });

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    var kanjiFavoritesList = ref.watch(favoriteskanjisProvider);
    final resultStatus = ref.watch(statusConnectionProvider);

    if (resultStatus == ConnectivityResult.none) {
      final favoritesKanjisStored = kanjiFavoritesList.$1
          .where((element) => element.statusStorage == StatusStorage.stored)
          .toList();
      if (favoritesKanjisStored.isNotEmpty) {
        kanjiFavoritesList = (favoritesKanjisStored, 1);
      } else {
        kanjiFavoritesList = (<KanjiFromApi>[], 1);
      }
    }

    return BodyKanjisList(
      statusResponse: kanjiFavoritesList.$2,
      kanjisFromApi: kanjiFavoritesList.$1,
    );
  }
}
