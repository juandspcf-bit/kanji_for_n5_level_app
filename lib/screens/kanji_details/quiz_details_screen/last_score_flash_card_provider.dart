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
    logger.d(
        'getttin flash card data input: kanji;$kanjiCharacter, section:$section, uuid:$uuid');
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () {
        return localDBService.getSingleFlashCardDataDB(
          kanjiCharacter,
          section,
          uuid,
        );
      },
    );
  }

  void setFinishedFlashCard({
    required String kanjiCharacter,
    required int section,
    required String uuid,
    required int countUnWatched,
  }) async {
    if (state.value?.section == -1) {
      final numberOfRows = await localDBService.insertSingleFlashCardDataDB(
        kanjiCharacter,
        section,
        uuid,
        countUnWatched,
      );
      if (numberOfRows != 0) {
        state = await AsyncValue.guard(
          () {
            return Future(() => SingleQuizFlashCardData(
                  kanjiCharacter: kanjiCharacter,
                  section: section,
                  uuid: uuid,
                  allRevisedFlashCards: countUnWatched == 0,
                ));
          },
        );
      }
      return;
    }

    final numberOfRows = await localDBService.setSingleFlashCardDataDB(
      kanjiCharacter,
      section,
      uuid,
      countUnWatched,
    );

    if (numberOfRows != 0) {
      state = await AsyncValue.guard(
        () {
          return Future(() => SingleQuizFlashCardData(
                kanjiCharacter: kanjiCharacter,
                section: section,
                uuid: uuid,
                allRevisedFlashCards: countUnWatched == 0,
              ));
        },
      );
    }
  }
}

final lastScoreFlashCardProvider =
    AsyncNotifierProvider<LastScoreFlashCardProvider, SingleQuizFlashCardData>(
        LastScoreFlashCardProvider.new);
