import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesKanjis extends Notifier<List<String>> {
  @override
  List<String> build() {
    return [];
  }

  void toggleFavorite(String kanjiCharacter) {
    final kanjiInList = state.firstWhere((element) => element == kanjiCharacter,
        orElse: () => "");

    var copy = state;
    if (kanjiInList == "") {
      copy.add(kanjiCharacter);
    } else {
      copy.remove(kanjiCharacter);
    }
    state = copy;
  }
}

final favoritesKanjisProvider =
    NotifierProvider<FavoritesKanjis, List<String>>(FavoritesKanjis.new);
