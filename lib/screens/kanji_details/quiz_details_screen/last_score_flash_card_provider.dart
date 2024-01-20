import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/db_contract.dart';
import 'package:kanji_for_n5_level_app/main.dart';

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
    logger.d('$kanjiCharacter, $section, $uuid');
    state = const AsyncLoading();
    state = await AsyncValue.guard((() {
      return localDBService.getSingleFlashCardDataDB(
        kanjiCharacter,
        section,
        uuid,
      );
    }));
  }

  void setFinishedFlashCard({
    String kanjiCharacter = '',
    int section = -1,
    String uuid = '',
    int countUnWatched = 1,
  }) {
    if (state.value?.section == -1) {
      localDBService.insertSingleFlashCardDataDB(
        kanjiCharacter,
        section,
        uuid,
        countUnWatched,
      );
      return;
    }

    localDBService.setSingleFlashCardDataDB(
      kanjiCharacter,
      section,
      uuid,
      countUnWatched,
    );
  }
}

final lastScoreFlashCardProvider =
    AsyncNotifierProvider<LastScoreFlashCardProvider, SingleQuizFlashCardData>(
        LastScoreFlashCardProvider.new);
