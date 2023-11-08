import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectQuizDetailsProvider extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void setScreen(int screenNumber) {
    state = screenNumber;
  }
}

final selectQuizDetailsProvider =
    NotifierProvider<SelectQuizDetailsProvider, int>(
        SelectQuizDetailsProvider.new);
