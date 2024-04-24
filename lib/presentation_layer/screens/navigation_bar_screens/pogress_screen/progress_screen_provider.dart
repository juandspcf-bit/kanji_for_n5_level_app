import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kanji_for_n5_level_app/aplication_layer/services.dart';
import 'package:kanji_for_n5_level_app/main.dart';

class ProgressTimelineProvider extends Notifier<ProgressTimeLineData> {
  @override
  ProgressTimeLineData build() {
    return ProgressTimeLineData(
      allKanjiQuizFinishedStatusList: [],
      allKanjiQuizCorrectStatusList: [],
      allAudioQuizFinishedStatusList: [],
      allAudioQuizCorrectStatusList: [],
      allRevisedFlashCardsStatusList: [],
    );
  }

  void getAllQuizSectionData(
    String uuid,
  ) async {
    final data =
        await ref.read(localDBServiceProvider).getAllQuizSectionDBData(uuid);
    logger.d(data.allAudioQuizCorrectStatusList);
    logger.d(data.allAudioQuizFinishedStatusList);
    state = ProgressTimeLineData(
      allKanjiQuizFinishedStatusList: data.allKanjiQuizFinishedStatusList,
      allKanjiQuizCorrectStatusList: data.allKanjiQuizCorrectStatusList,
      allAudioQuizFinishedStatusList: data.allAudioQuizFinishedStatusList,
      allAudioQuizCorrectStatusList: data.allAudioQuizCorrectStatusList,
      allRevisedFlashCardsStatusList: data.allRevisedFlashCardsStatusList,
    );
  }
}

final progressTimelineProvider =
    NotifierProvider<ProgressTimelineProvider, ProgressTimeLineData>(
  ProgressTimelineProvider.new,
);

class ProgressTimeLineData {
  final List<bool> allKanjiQuizFinishedStatusList;
  final List<bool> allKanjiQuizCorrectStatusList;
  final List<bool> allAudioQuizFinishedStatusList;
  final List<bool> allAudioQuizCorrectStatusList;
  final List<bool> allRevisedFlashCardsStatusList;

  ProgressTimeLineData({
    required this.allKanjiQuizFinishedStatusList,
    required this.allKanjiQuizCorrectStatusList,
    required this.allAudioQuizFinishedStatusList,
    required this.allAudioQuizCorrectStatusList,
    required this.allRevisedFlashCardsStatusList,
  });
}
