import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/db_contract.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/db_sqflite_impl.dart';
import 'package:kanji_for_n5_level_app/main.dart';

class LastScoreProvider extends AsyncNotifier<SingleQuizSectionData> {
  @override
  FutureOr<SingleQuizSectionData> build() {
    return SingleQuizSectionData(
      section: -1,
      allCorrectAnswersQuizKanji: false,
      isFinishedKanjiQuizz: false,
      countCorrects: 0,
      countIncorrects: 0,
      countOmited: 0,
    );
  }

  void getKanjiQuizLastScore(int section, String uuid) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard((() {
      return localDBService.getKanjiQuizLastScore(section, uuid);
    }));
  }

  void setFinishedQuiz({
    int section = -1,
    String uuid = '',
    int countCorrects = 0,
    int countIncorrects = 0,
    int countOmited = 0,
  }) {
    logger.d('data $section');
    if (state.value?.section == -1) {
      localDBService.insertSingleQuizSectionData(
          section, uuid, countCorrects, countIncorrects, countOmited);
      return;
    }

    localDBService.setKanjiQuizLastScore(
      section: section,
      uuid: uuid,
      countCorrects: countCorrects,
      countIncorrects: countIncorrects,
      countOmited: countOmited,
    );
  }
}

final lastScoreProvider =
    AsyncNotifierProvider<LastScoreProvider, SingleQuizSectionData>(
        LastScoreProvider.new);
