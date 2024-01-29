import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_favorites.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/screens/navigation_bar_screens/favorite_screen/favorites_kanjis_provider.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';

class KanjiDetailsProvider extends Notifier<KanjiDetailsData?> {
  @override
  KanjiDetailsData? build() {
    return null;
  }

  void setInitValues(
    KanjiFromApi kanjiFromApi,
    StatusStorage statusStorage,
    bool favoriteStatus,
  ) {
    state = KanjiDetailsData(
        favoriteStatus: favoriteStatus,
        kanjiFromApi: kanjiFromApi,
        statusStorage: statusStorage,
        storingToFavoritesStatus: StoringToFavoritesStatus.noStarted);
  }

  void setFavoritesStatusInKanjiDetailsData(bool value) {
    state = KanjiDetailsData(
        favoriteStatus: value,
        kanjiFromApi: state!.kanjiFromApi,
        statusStorage: state!.statusStorage,
        storingToFavoritesStatus: state!.storingToFavoritesStatus);
  }

  void setStoringToFavoritesStatus(
      StoringToFavoritesStatus storingToFavoritesStatus) {
    state = KanjiDetailsData(
      favoriteStatus: state!.favoriteStatus,
      kanjiFromApi: state!.kanjiFromApi,
      statusStorage: state!.statusStorage,
      storingToFavoritesStatus: storingToFavoritesStatus,
    );
  }

  ///initial point function for storing a kanji in favorites
  void storeToFavorites(KanjiFromApi kanjiFromApi) async {
    setStoringToFavoritesStatus(StoringToFavoritesStatus.processing);
    final queryKanji = ref
        .read(favoriteskanjisProvider.notifier)
        .searchInFavorites(kanjiFromApi.kanjiCharacter);

    if (!queryKanji) {
      try {
        final timeStamp = DateTime.now().millisecondsSinceEpoch;
        await cloudDBService.insertFavoriteCloudDB(
          kanjiFromApi.kanjiCharacter,
          timeStamp,
          authService.user ?? '',
        );
        await insertFavorite(kanjiFromApi.kanjiCharacter, timeStamp);
        final storedItems =
            ref.read(storedKanjisProvider.notifier).getStoresItems();
        ref.read(favoriteskanjisProvider.notifier).addItem(
            storedItems.values.fold(
              [],
              (previousValue, element) {
                previousValue.addAll(element);
                return previousValue;
              },
            ),
            FavoriteKanji(kanjiFromApi: kanjiFromApi, timeStamp: timeStamp));
        Future.delayed(
          const Duration(
            seconds: 1,
          ),
          () {
            setStoringToFavoritesStatus(StoringToFavoritesStatus.successAdded);
            setFavoritesStatusInKanjiDetailsData(!queryKanji);
          },
        );
      } catch (e) {
        logger.e(e);
        setStoringToFavoritesStatus(StoringToFavoritesStatus.noStarted);
      }
    } else {
      try {
        await deleteFavorite(kanjiFromApi.kanjiCharacter);
        ref.read(favoriteskanjisProvider.notifier).removeItem(kanjiFromApi);
        Future.delayed(
          const Duration(
            seconds: 1,
          ),
          () {
            setStoringToFavoritesStatus(
                StoringToFavoritesStatus.successRemoved);
            setFavoritesStatusInKanjiDetailsData(!queryKanji);
          },
        );
      } catch (e) {
        logger.e(e);
        setStoringToFavoritesStatus(StoringToFavoritesStatus.noStarted);
      }
    }
  }
}

enum StoringToFavoritesStatus {
  noStarted('Not started'),
  processing('Processing'),
  successAdded('Added to favorites!'),
  successRemoved('Removed from favorites'),
  error('error in storing');

  const StoringToFavoritesStatus(this.message);
  final String message;
  @override
  String toString() => message;
}

final kanjiDetailsProvider =
    NotifierProvider<KanjiDetailsProvider, KanjiDetailsData?>(
        KanjiDetailsProvider.new);

class KanjiDetailsData {
  final KanjiFromApi kanjiFromApi;
  final StatusStorage statusStorage;
  final bool favoriteStatus;
  final StoringToFavoritesStatus storingToFavoritesStatus;

  KanjiDetailsData({
    required this.kanjiFromApi,
    required this.statusStorage,
    required this.favoriteStatus,
    required this.storingToFavoritesStatus,
  });
}
