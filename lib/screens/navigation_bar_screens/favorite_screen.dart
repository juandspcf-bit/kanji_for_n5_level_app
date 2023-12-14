import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/error_storing_database_status.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/providers/main_screen_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/body_list.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/db_dialog_error_message.dart';

class FavoriteScreen extends ConsumerWidget with DialogErrorInDB {
  const FavoriteScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityData = ref.watch(statusConnectionProvider);
    final mainScreenData = ref.watch(mainScreenProvider);
    if (ref.watch(errorDatabaseStatusProvider)) {
      dbDeletingErrorDialog(context, ref);
    }
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
      connectivityData: connectivityData,
      mainScreenData: mainScreenData,
    );
  }
}
