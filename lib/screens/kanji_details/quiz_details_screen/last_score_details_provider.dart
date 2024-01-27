import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_audio_example_data.dart';

class LastScoreDetailsProvider
    extends AsyncNotifier<SingleQuizAudioExampleData> {
  @override
  FutureOr<SingleQuizAudioExampleData> build() {
    return SingleQuizAudioExampleData(
      kanjiCharacter: '',
      section: -1,
      uuid: '',
      allCorrectAnswers: false,
      isFinishedQuiz: false,
      countCorrects: 0,
      countIncorrects: 0,
      countOmited: 0,
    );
  }

  void getSingleAudioExampleQuizDataDB(
    String kanjiCharacter,
    int section,
    String uuid,
  ) async {
    logger.d('$kanjiCharacter, $section, $uuid');
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
  }) async {
    if (state.value?.section == -1) {
      final numberOfRows = await localDBService.insertAudioExampleScore(
        section,
        uuid,
        kanjiCharacter,
        countCorrects,
        countIncorrects,
        countOmited,
      );
      if (numberOfRows != 0) {
        state = await AsyncValue.guard(
          () {
            return Future(
              () => SingleQuizAudioExampleData(
                kanjiCharacter: kanjiCharacter,
                section: section,
                uuid: uuid,
                isFinishedQuiz: true,
                countCorrects: countCorrects,
                countIncorrects: countIncorrects,
                countOmited: countOmited,
                allCorrectAnswers: countCorrects == 0 && countOmited == 0,
              ),
            );
          },
        );
      }
      return;
    }

    final numberOfRows = await localDBService.setAudioExampleLastScore(
      kanjiCharacter: kanjiCharacter,
      section: section,
      uuid: uuid,
      countCorrects: countCorrects,
      countIncorrects: countIncorrects,
      countOmited: countOmited,
    );

    if (numberOfRows != 0) {
      state = await AsyncValue.guard(
        () {
          return Future(
            () => SingleQuizAudioExampleData(
              kanjiCharacter: kanjiCharacter,
              section: section,
              uuid: uuid,
              isFinishedQuiz: true,
              countCorrects: countCorrects,
              countIncorrects: countIncorrects,
              countOmited: countOmited,
              allCorrectAnswers: countCorrects == 0 && countOmited == 0,
            ),
          );
        },
      );
    }
  }
}

final lastScoreDetailsProvider =
    AsyncNotifierProvider<LastScoreDetailsProvider, SingleQuizAudioExampleData>(
        LastScoreDetailsProvider.new);
