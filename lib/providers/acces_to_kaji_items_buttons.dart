import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccessToKanjiItemsButtons extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  void giveAccesToButtons() {
    state = true;
  }

  void denyAccesToButtons() {
    state = false;
  }
}

final accessToKanjiItemsButton =
    NotifierProvider<AccessToKanjiItemsButtons, bool>(
        AccessToKanjiItemsButtons.new);
