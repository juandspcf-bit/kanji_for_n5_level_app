import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
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
      countIncorrect: 0,
      countOmitted: 0,
    );
  }

  void getKanjiQuizLastScore(int section, String uuid) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      (() {
        return ref
            .read(localDBServiceProvider)
            .getKanjiQuizLastScore(section, uuid);
      }),
    );
  }

  void setFinishedQuiz({
    int section = -1,
    String uuid = '',
    int countCorrects = 0,
    int countIncorrect = 0,
    int countOmitted = 0,
  }) async {
    state = const AsyncLoading();
    try {
      await ref.read(cloudDBServiceProvider).updateQuizSectionScore(
            countIncorrect == 0 && countOmitted == 0,
            true,
            countCorrects,
            countIncorrect,
            countOmitted,
            section,
            uuid,
          );
      if (state.value?.section == -1) {
        await ref.read(localDBServiceProvider).insertSingleQuizSectionData(
            section, uuid, countCorrects, countIncorrect, countOmitted);
        return;
      }

      await ref.read(localDBServiceProvider).setKanjiQuizLastScore(
            section: section,
            uuid: uuid,
            countCorrects: countCorrects,
            countIncorrect: countIncorrect,
            countOmitted: countOmitted,
          );

      state = await AsyncValue.guard(
        (() {
          return ref
              .read(localDBServiceProvider)
              .getKanjiQuizLastScore(section, uuid);
        }),
      );
    } catch (e) {
      state = AsyncValue.error('error retrieving data', StackTrace.current);
      logger.e(e);
    }
  }
}

final lastScoreKanjiQuizProvider =
    AsyncNotifierProvider<LastScoreKanjiQuizProvider, SingleQuizSectionData>(
        LastScoreKanjiQuizProvider.new);
