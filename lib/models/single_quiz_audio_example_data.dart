class SingleQuizAudioExampleData {
  final String kanjiCharacter;
  final int section;
  final String uuid;
  final bool allCorrectAnswers;
  final bool isFinishedQuiz;
  final int countCorrects;
  final int countIncorrects;
  final int countOmited;

  SingleQuizAudioExampleData({
    required this.kanjiCharacter,
    required this.section,
    required this.uuid,
    required this.allCorrectAnswers,
    required this.isFinishedQuiz,
    required this.countCorrects,
    required this.countIncorrects,
    required this.countOmited,
  });

  @override
  String toString() {
    return 'kanjiCharacter;$kanjiCharacter, section:$section, uuid:$uuid isFinished:$isFinishedQuiz';
  }
}
