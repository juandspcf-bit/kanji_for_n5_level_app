import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectionNavigationBarScreen extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setScreen(int screen) {
    state = screen;
  }

  int getScreenSelection() {
    return state;
  }
}

final selectionNavigationBarScreen =
    NotifierProvider<SelectionNavigationBarScreen, int>(
        SelectionNavigationBarScreen.new);

enum ScreenSelection { kanjiSections, favoritesKanjis }
