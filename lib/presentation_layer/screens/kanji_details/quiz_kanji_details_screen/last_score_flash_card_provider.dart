import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';
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
    logger.d(
        'getttin flash card data input: kanji;$kanjiCharacter, section:$section, uuid:$uuid');
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

    logger.d('set flash card score');
  }
}

final lastScoreFlashCardProvider =
    AsyncNotifierProvider<LastScoreFlashCardProvider, SingleQuizFlashCardData>(
        LastScoreFlashCardProvider.new);
