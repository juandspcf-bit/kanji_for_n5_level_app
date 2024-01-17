import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/db_contract.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/db_sqflite_impl.dart';

class LastScoreDetailsProvider extends AsyncNotifier<SingleQuizSectionData> {
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

  void getDetailsQuizLastScore(int section, String uuid) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard((() {
      return localDBService.getSingleAudioExampleQuizDataDB(section, uuid);
    }));
  }

  void setFinishedQuiz({
    int section = -1,
    String uuid = '',
    int countCorrects = 0,
    int countIncorrects = 0,
    int countOmited = 0,
  }) {
    if (state.value?.section == -1) {
      localDBService.insertAudioExampleScore(
          section, uuid, countCorrects, countIncorrects, countOmited);
      return;
    }

    localDBService.setAudioExampleLastScore(
      section: section,
      uuid: uuid,
      countCorrects: countCorrects,
      countIncorrects: countIncorrects,
      countOmited: countOmited,
    );
  }
}

final lastScoreDetailsProvider =
    AsyncNotifierProvider<LastScoreDetailsProvider, SingleQuizSectionData>(
        LastScoreDetailsProvider.new);
