import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/db_contract.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/db_sqflite_impl.dart';

class LastScoreDetailsProvider
    extends AsyncNotifier<SingleQuizAudioExampleData> {
  @override
  FutureOr<SingleQuizAudioExampleData> build() {
    return SingleQuizAudioExampleData(
      kanjiCharacter: '',
      section: -1,
      allCorrectAnswers: false,
      isFinishedQuiz: false,
      countCorrects: 0,
      countIncorrects: 0,
      countOmited: 0,
    );
  }

  void getDetailsQuizLastScore(
    String kanjiCharacter,
    int section,
    String uuid,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard((() {
      return localDBService.getSingleAudioExampleQuizDataDB(
        kanjiCharacter,
        section,
        uuid,
      );
    }));
  }

  void setFinishedQuiz({
    int section = -1,
    String uuid = '',
    String kanjiCharacter = '',
    int countCorrects = 0,
    int countIncorrects = 0,
    int countOmited = 0,
  }) {
    if (state.value?.section == -1) {
      localDBService.insertAudioExampleScore(
        section,
        uuid,
        kanjiCharacter,
        countCorrects,
        countIncorrects,
        countOmited,
      );
      return;
    }

    localDBService.setAudioExampleLastScore(
      kanjiCharacter: kanjiCharacter,
      section: section,
      uuid: uuid,
      countCorrects: countCorrects,
      countIncorrects: countIncorrects,
      countOmited: countOmited,
    );
  }
}

final lastScoreDetailsProvider =
    AsyncNotifierProvider<LastScoreDetailsProvider, SingleQuizAudioExampleData>(
        LastScoreDetailsProvider.new);
