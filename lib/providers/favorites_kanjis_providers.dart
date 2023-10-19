import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';

class FavoritesKanjis extends AsyncNotifier<List<(String, String, String)>> {
  @override
  FutureOr<List<(String, String, String)>> build() async {
    final querySnapshot = await dbFirebase.collection("favorites").get();
    final myFavorites = querySnapshot.docs.map(
      (e) {
        Map<String, dynamic> data = e.data();
        return (e.id, 'kanjiCharacter', data['kanjiCharacter'] as String);
      },
    ).toList();
    return myFavorites;
  }

  void addFavoriteOrRemove(List<(String, String, String)> kanji) {}
}

final favoritesKanjisProvider =
    AsyncNotifierProvider<FavoritesKanjis, List<(String, String, String)>>(
        FavoritesKanjis.new);

List<(String, String, String)> myFavoritesCached = [];
