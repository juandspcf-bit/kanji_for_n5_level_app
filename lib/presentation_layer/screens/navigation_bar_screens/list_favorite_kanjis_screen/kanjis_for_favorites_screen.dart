import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/list_favorite_kanjis_screen/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/body_list.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/my_dialogs.dart';

class KanjisForFavoritesScreen extends ConsumerWidget with MyDialogs {
  const KanjisForFavoritesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var kanjiFavoritesList = ref.watch(favoritesKanjisProvider);

    return BodyKanjisList(
      statusResponse: kanjiFavoritesList.favoritesFetchingStatus.index,
      kanjisFromApi: kanjiFavoritesList.favoritesKanjisFromApi
          .map((e) => e.kanjiFromApi)
          .toList(),
    );
  }
}
