import 'package:flutter_riverpod/flutter_riverpod.dart';

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
