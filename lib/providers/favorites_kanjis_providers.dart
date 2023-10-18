import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesKanjis extends Notifier<List<String>> {
  @override
  List<String> build() {
    return [];
  }

  void toggleFavorite(String kanjiCharacter) {}

  void initState(List<String> favoriteKanjis) {
    state = favoriteKanjis;
  }
}

final favoritesKanjisProvider =
    NotifierProvider<FavoritesKanjis, List<String>>(FavoritesKanjis.new);

List<String> myFavoritesCached = [];
