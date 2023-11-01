import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccesToQuizProvider extends Notifier<bool> {
  @override
  bool build() {
    return true;
  }

  void giveAccesToQuiz() {
    state = true;
  }

  void denyAccesToQuiz() {
    state = false;
  }
}

final accesToQuizProvider =
    NotifierProvider<AccesToQuizProvider, bool>(AccesToQuizProvider.new);
