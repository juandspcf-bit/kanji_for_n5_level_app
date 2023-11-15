import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/Databases/favorites_db_utils.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/providers/favorites_cached_provider.dart';
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
        statusStorage: statusStorage);
  }

  void setFavorites(bool value) {
    state = KanjiDetailsData(
        favoriteStatus: value,
        kanjiFromApi: state!.kanjiFromApi,
        statusStorage: state!.statusStorage);
  }

  void storeToFavorites(KanjiFromApi kanjiFromApi) {
    final queryKanji = ref
        .read(favoritesCachedProvider.notifier)
        .searchInFavorites(kanjiFromApi.kanjiCharacter);

    if (queryKanji == "") {
      insertFavorite(kanjiFromApi.kanjiCharacter).then((value) {
        final storedItems =
            ref.read(statusStorageProvider.notifier).getStoresItems();
        ref.read(favoritesCachedProvider.notifier).addItem(
            storedItems.values.fold([], (previousValue, element) {
              previousValue.addAll(element);
              return previousValue;
            }),
            kanjiFromApi);
        setFavorites(queryKanji == "");
      });
    } else {
      deleteFavorite(kanjiFromApi.kanjiCharacter).then((value) {
        ref.read(favoritesCachedProvider.notifier).removeItem(kanjiFromApi);
        setFavorites(queryKanji == "");
      });
    }
  }
}

final kanjiDetailsProvider =
    NotifierProvider<KanjiDetailsProvider, KanjiDetailsData?>(
        KanjiDetailsProvider.new);

class KanjiDetailsData {
  final KanjiFromApi kanjiFromApi;
  final StatusStorage statusStorage;
  final bool favoriteStatus;

  KanjiDetailsData({
    required this.kanjiFromApi,
    required this.statusStorage,
    required this.favoriteStatus,
  });
}
