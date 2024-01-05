import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/providers/error_storing_database_status.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/providers/main_screen_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_connection_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/body_list/body_list.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/db_dialog_error_message.dart';

class FavoriteScreen extends ConsumerWidget with MyDialogs {
  const FavoriteScreen({
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
    var kanjiFavoritesList = ref.watch(favoriteskanjisProvider);
    final connectivityData = ref.watch(statusConnectionProvider);

    if (connectivityData == ConnectivityResult.none) {
      final favoritesKanjisStored = kanjiFavoritesList.kanjisFromApi
          .where((element) => element.statusStorage == StatusStorage.stored)
          .toList();
      if (favoritesKanjisStored.isNotEmpty) {
        kanjiFavoritesList = FavoritesKanjisData(
          kanjisFromApi: favoritesKanjisStored,
          favoritesFetchingStatus: FavoritesFetchingStatus.succefulFecth,
        );
      } else {
        kanjiFavoritesList = const FavoritesKanjisData(
          kanjisFromApi: [],
          favoritesFetchingStatus: FavoritesFetchingStatus.succefulFecth,
        );
      }
    }

    ref.listen<FavoritesKanjisData>(favoriteskanjisProvider, (prev, current) {
      logger.d(current.onDismissibleActionStatus.message);
      if (current.onDismissibleActionStatus ==
              OnDismissibleActionStatus.successAdded ||
          current.onDismissibleActionStatus ==
              OnDismissibleActionStatus.successRemoved ||
          current.onDismissibleActionStatus ==
              OnDismissibleActionStatus.error) {
        ScaffoldMessenger.of(context).clearSnackBars();

        var snackBar = SnackBar(
          content: Text(current.onDismissibleActionStatus.message),
          duration: const Duration(seconds: 20),
          action: SnackBarAction(
              label: 'Undo',
              onPressed: () async {
                logger.d('restoring kanji');
                final dissmisedKanji =
                    ref.read(favoriteskanjisProvider).dissmisedKanji;

                if (dissmisedKanji == null) {
                  logger.d('it is null');
                  return;
                }

                await ref
                    .read(favoriteskanjisProvider.notifier)
                    .restoreFavorite(
                      dissmisedKanji.kanjiFromApiFromDismisibleAction,
                      dissmisedKanji.index,
                    );
              }),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        ref
            .read(favoriteskanjisProvider.notifier)
            .setOnDismissibleActionStatus(OnDismissibleActionStatus.noStarted);
      }
    });

    return BodyKanjisList(
      statusResponse: kanjiFavoritesList.favoritesFetchingStatus.index,
      kanjisFromApi: kanjiFavoritesList.kanjisFromApi,
      connectivityData: connectivityData,
      mainScreenData: mainScreenData,
    );
  }
}
