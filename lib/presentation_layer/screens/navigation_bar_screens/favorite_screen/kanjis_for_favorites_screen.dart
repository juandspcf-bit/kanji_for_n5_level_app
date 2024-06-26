import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/providers/error_storing_database_status.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/navigation_bar_screens/favorite_screen/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/main_screens/main_content_provider.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/screens/kanji_list/body_list/body_list.dart';
import 'package:kanji_for_n5_level_app/presentation_layer/common_widgets/my_dialogs.dart';

class KanjisForFavoritesScreen extends ConsumerWidget with MyDialogs {
  const KanjisForFavoritesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainScreenData = ref.watch(mainScreenProvider);
    if (ref.watch(errorDatabaseStatusProvider)) {
      errorDialog(
        context,
        () {
          ref
              .read(errorDatabaseStatusProvider.notifier)
              .setDeletingError(false);
        },
        'An issue happened when deleting this item, please go back to the section'
        ' list and access the content again to see the updated content.',
      );
    }
    var kanjiFavoritesList = ref.watch(favoritesKanjisProvider);

    return BodyKanjisList(
      statusResponse: kanjiFavoritesList.favoritesFetchingStatus.index,
      kanjisFromApi: kanjiFavoritesList.favoritesKanjisFromApi
          .map((e) => e.kanjiFromApi)
          .toList(),
      mainScreenData: mainScreenData,
    );
  }
}
