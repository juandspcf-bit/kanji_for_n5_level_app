import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/Databases/db_computes_functions_for_inserting_data.dart';
import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';
import 'package:kanji_for_n5_level_app/networking/request_api.dart';
import 'package:kanji_for_n5_level_app/providers/status_stored_provider.dart';
import 'package:kanji_for_n5_level_app/screens/main_content.dart';
import 'package:path_provider/path_provider.dart';

class FavoritesListProvider extends Notifier<(List<KanjiFromApi>, int)> {
  @override
  (List<KanjiFromApi>, int) build() {
    return ([], 0);
  }

  void setInitialFavoritesOnline(List<KanjiFromApi> storedKanjis,
      List<String> myFavoritesCached, int section) {
    if (myFavoritesCached.isEmpty) {
      state = ([], 1);
      return;
    }
    RequestApi.getKanjis(storedKanjis, myFavoritesCached, section,
        onSuccesRequest, onErrorRequest);
  }

  void setInitialFavoritesOffline(List<KanjiFromApi> storedKanjis,
      List<String> myFavoritesCached, int section) {
    if (myFavoritesCached.isEmpty) {
      state = ([], 1);
      return;
    }

    List<KanjiFromApi> favoriteKanjisStored = [];

    for (var favorite in myFavoritesCached) {
      try {
        final favoriteStored =
            storedKanjis.firstWhere((e) => e.kanjiCharacter == favorite);
        favoriteKanjisStored.add(favoriteStored);
      } catch (e) {
        continue;
      }
    }

    onSuccesRequest(favoriteKanjisStored);
  }

  void onSuccesRequest(List<KanjiFromApi> kanjisFromApi) {
    state = (kanjisFromApi, 1);
  }

  void onErrorRequest() {
    state = ([], 2);
  }

  List<KanjiFromApi> getFavorites() {
    return state.$1;
  }

  void addItem(List<KanjiFromApi> storedItems, KanjiFromApi kanjiFromApi) {
    state = ([...state.$1, kanjiFromApi], 1);
  }

  void removeItem(KanjiFromApi favoritekanjiFromApi) {
    final copyState = [...state.$1];
    int index = copyState.indexWhere((element) =>
        element.kanjiCharacter == favoritekanjiFromApi.kanjiCharacter);
    copyState.removeAt(index);
    state = ([...copyState], state.$2);
  }

  String searchInFavorites(String kanji) {
    final copyState = [...state.$1];
    final mappedCopyState = copyState.map((e) => e.kanjiCharacter).toList();
    return mappedCopyState.firstWhere(
      (element) => element == kanji,
      orElse: () => '',
    );
  }

  void updateKanji(KanjiFromApi storedKanji) {
    final copyState = [...state.$1];

    final kanjiIndex = copyState.indexWhere(
        (element) => element.kanjiCharacter == storedKanji.kanjiCharacter);
    if (kanjiIndex == -1) return;
    copyState[kanjiIndex] = storedKanji;
    state = (copyState, state.$2);
  }

  void insertKanjiToStorageComputeVersion(
      KanjiFromApi kanjiFromApi, int selection) async {
    try {
      final dirDocumentPath = await getApplicationDocumentsDirectory();
      final kanjiFromApiStored = await compute(
          insertKanjiFromApiComputeVersion,
          ParametersCompute(
            kanjiFromApi: kanjiFromApi,
            path: dirDocumentPath,
          ));

      insertPathsInDB(kanjiFromApiStored);
      ref.read(statusStorageProvider.notifier).addItem(kanjiFromApiStored);

      ref.read(favoritesListProvider.notifier).updateKanji(kanjiFromApiStored);

      logger.i(kanjiFromApiStored);
      logger.d('success');
    } catch (e) {
      logger.e('error sotoring');
      logger.e(e.toString());
    }
  }
}

final favoritesListProvider =
    NotifierProvider<FavoritesListProvider, (List<KanjiFromApi>, int)>(
        FavoritesListProvider.new);
