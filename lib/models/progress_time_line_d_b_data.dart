class ProgressTimeLineDBData {
  final List<bool> allKanjiQuizFinishedStatusList;
  final List<bool> allKanjiQuizCorrectStatusList;
  final List<bool> allAudioQuizFinishedStatusList;
  final List<bool> allAudioQuizCorrectStatusList;
  final List<bool> allRevisedFlashCardsStatusList;

  ProgressTimeLineDBData({
    required this.allKanjiQuizFinishedStatusList,
    required this.allKanjiQuizCorrectStatusList,
    required this.allAudioQuizFinishedStatusList,
    required this.allAudioQuizCorrectStatusList,
    required this.allRevisedFlashCardsStatusList,
  });
}
