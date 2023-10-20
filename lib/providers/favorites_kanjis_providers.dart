import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesKanjis extends Notifier<List<(String, String, String)>> {
  @override
  List<(String, String, String)> build() {
    return [];
  }

  void setInitialState(List<(String, String, String)> initial) {
    state = initial;
  }
}

final favoritesKanjisProvider =
    NotifierProvider<FavoritesKanjis, List<(String, String, String)>>(
        FavoritesKanjis.new);

List<(String, String, String)> myFavoritesCached = [];
