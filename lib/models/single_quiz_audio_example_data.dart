class SingleQuizAudioExampleData {
  final String kanjiCharacter;
  final int section;
  final String uuid;
  final bool allCorrectAnswers;
  final bool isFinishedQuiz;
  final int countCorrects;
  final int countIncorrect;
  final int countOmitted;

  SingleQuizAudioExampleData({
    required this.kanjiCharacter,
    required this.section,
    required this.uuid,
    required this.allCorrectAnswers,
    required this.isFinishedQuiz,
    required this.countCorrects,
    required this.countIncorrect,
    required this.countOmitted,
  });

  @override
  String toString() {
    return 'kanjiCharacter;$kanjiCharacter, allCorrectAnswers:$allCorrectAnswers, isFinished:$isFinishedQuiz';
  }
}
