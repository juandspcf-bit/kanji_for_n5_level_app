import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/application_layer/services.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_flash_card_data.dart';

class LastScoreFlashCardProvider
    extends AsyncNotifier<SingleQuizFlashCardData> {
  @override
  FutureOr<SingleQuizFlashCardData> build() {
    return SingleQuizFlashCardData(
      kanjiCharacter: '',
      section: -1,
      uuid: '',
      allRevisedFlashCards: false,
    );
  }

  void getSingleFlashCardDataDB(
    String kanjiCharacter,
    int section,
    String uuid,
  ) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () {
        return ref.read(localDBServiceProvider).getSingleFlashCardDataDB(
              kanjiCharacter,
              section,
              uuid,
            );
      },
    );
  }

  Future<void> setFinishedFlashCard({
    required String kanjiCharacter,
    required int section,
    required String uuid,
    required int countUnWatched,
  }) async {
    state = const AsyncLoading();
    final flashCardDataLastScore =
        await ref.read(localDBServiceProvider).getSingleFlashCardDataDB(
              kanjiCharacter,
              section,
              uuid,
            );
    final allRevisedFlashCards = flashCardDataLastScore.allRevisedFlashCards;
    if (allRevisedFlashCards) {
      state = await AsyncValue.guard(
        () {
          return Future(() => flashCardDataLastScore);
        },
      );
      return;
    }
    await ref.read(cloudDBServiceProvider).updateQuizFlashCardScore(
          kanjiCharacter,
          countUnWatched == 0,
          section,
          uuid,
        );

    if (state.value?.section == -1) {
      await ref.read(localDBServiceProvider).insertSingleFlashCardDataDB(
            kanjiCharacter,
            section,
            uuid,
            countUnWatched,
          );
      state = await AsyncValue.guard(
        () {
          return ref.read(localDBServiceProvider).getSingleFlashCardDataDB(
                kanjiCharacter,
                section,
                uuid,
              );
        },
      );
      return;
    }

    await ref.read(localDBServiceProvider).setSingleFlashCardDataDB(
          kanjiCharacter,
          section,
          uuid,
          countUnWatched,
        );

    state = await AsyncValue.guard(
      () {
        return ref.read(localDBServiceProvider).getSingleFlashCardDataDB(
              kanjiCharacter,
              section,
              uuid,
            );
      },
    );
  }
}

final lastScoreFlashCardProvider =
    AsyncNotifierProvider<LastScoreFlashCardProvider, SingleQuizFlashCardData>(
        LastScoreFlashCardProvider.new);
