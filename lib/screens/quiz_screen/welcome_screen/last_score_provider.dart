import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/db_sqflite_impl.dart';

class LastScoreProvider extends AsyncNotifier<(int, bool, bool)> {
  @override
  FutureOr<(int, bool, bool)> build() {
    return (0, false, false);
  }

  void getKanjiQuizLastScore(int section, String uuid) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard((() {
      return localDBService.getKanjiQuizLastScore(section, uuid);
    }));
  }
}

final lastScoreProvider =
    AsyncNotifierProvider<LastScoreProvider, (int, bool, bool)>(
        LastScoreProvider.new);

class LastScoreData {
  final int section;
  final bool allCorrectAnswersQuizKanji;
  final bool isFinishedKanjiQuizz;

  LastScoreData({
    required this.section,
    required this.allCorrectAnswersQuizKanji,
    required this.isFinishedKanjiQuizz,
  });
}
