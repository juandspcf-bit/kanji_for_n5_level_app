import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_section_data.dart';

class LastScoreKanjiQuizProvider extends AsyncNotifier<SingleQuizSectionData> {
  @override
  FutureOr<SingleQuizSectionData> build() {
    return SingleQuizSectionData(
      section: -1,
      allCorrectAnswers: false,
      isFinishedQuiz: false,
      countCorrects: 0,
      countIncorrects: 0,
      countOmited: 0,
    );
  }

  void getKanjiQuizLastScore(int section, String uuid) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      (() {
        return localDBService.getKanjiQuizLastScore(section, uuid);
      }),
    );
  }

  void setFinishedQuiz({
    int section = -1,
    String uuid = '',
    int countCorrects = 0,
    int countIncorrects = 0,
    int countOmited = 0,
  }) async {
    state = const AsyncLoading();
    try {
      await cloudDBService.updateQuizSectionScore(
        countIncorrects == 0 && countOmited == 0,
        true,
        countCorrects,
        countIncorrects,
        countOmited,
        section,
        uuid,
      );
      if (state.value?.section == -1) {
        await localDBService.insertSingleQuizSectionData(
            section, uuid, countCorrects, countIncorrects, countOmited);
        return;
      }

      await localDBService.setKanjiQuizLastScore(
        section: section,
        uuid: uuid,
        countCorrects: countCorrects,
        countIncorrects: countIncorrects,
        countOmited: countOmited,
      );

      state = await AsyncValue.guard(
        (() {
          return localDBService.getKanjiQuizLastScore(section, uuid);
        }),
      );
    } catch (e) {
      state = AsyncValue.error('error retriving data', StackTrace.current);
      logger.e(e);
    }
  }
}

final lastScoreKanjiQuizProvider =
    AsyncNotifierProvider<LastScoreKanjiQuizProvider, SingleQuizSectionData>(
        LastScoreKanjiQuizProvider.new);
