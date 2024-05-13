import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
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
      countIncorrect: 0,
      countOmitted: 0,
    );
  }

  void getSingleAudioExampleQuizDataDB(
    String kanjiCharacter,
    int section,
    String uuid,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      (() {
        return ref.read(localDBServiceProvider).getSingleAudioExampleQuizDataDB(
              kanjiCharacter,
              section,
              uuid,
            );
      }),
    );
  }

  void setFinishedQuiz({
    int section = -1,
    String uuid = '',
    String kanjiCharacter = '',
    int countCorrects = 0,
    int countIncorrect = 0,
    int countOmitted = 0,
  }) async {
    state = const AsyncLoading();
    try {
      await ref.read(cloudDBServiceProvider).updateQuizDetailScore(
          kanjiCharacter,
          countCorrects == 0 && countOmitted == 0,
          true,
          countCorrects,
          countIncorrect,
          countOmitted,
          section,
          uuid);
    } catch (e) {
      logger.e(e);
    }

    if (state.value?.section == -1) {
      final numberOfRows =
          await ref.read(localDBServiceProvider).insertAudioExampleScore(
                section,
                uuid,
                kanjiCharacter,
                countCorrects,
                countIncorrect,
                countOmitted,
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
                countIncorrect: countIncorrect,
                countOmitted: countOmitted,
                allCorrectAnswers: countCorrects == 0 && countOmitted == 0,
              ),
            );
          },
        );
      }
      return;
    }

    final numberOfRows =
        await ref.read(localDBServiceProvider).setAudioExampleLastScore(
              kanjiCharacter: kanjiCharacter,
              section: section,
              uuid: uuid,
              countCorrects: countCorrects,
              countIncorrect: countIncorrect,
              countOmitted: countOmitted,
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
              countIncorrect: countIncorrect,
              countOmitted: countOmitted,
              allCorrectAnswers: countCorrects == 0 && countOmitted == 0,
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
