import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesKanjis extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  bool toggleFavorite(String kanjiCharacter) {
    final queryKanji = myFavoritesCached.firstWhere(
        (element) => element.$3 == kanjiCharacter,
        orElse: () => ("", "", ""));
    final isFavorite = queryKanji.$3 != "";
    state = isFavorite;
    return isFavorite;
  }
}

final favoritesKanjisProvider =
    NotifierProvider<FavoritesKanjis, bool>(FavoritesKanjis.new);

List<(String, String, String)> myFavoritesCached = [];
