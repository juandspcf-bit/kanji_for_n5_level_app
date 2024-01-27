class SingleQuizFlashCardData {
  final String kanjiCharacter;
  final int section;
  final String uuid;
  final bool allRevisedFlashCards;

  SingleQuizFlashCardData({
    required this.kanjiCharacter,
    required this.section,
    required this.uuid,
    required this.allRevisedFlashCards,
  });

  @override
  String toString() {
    return 'kanjiCharacter;$kanjiCharacter, '
        'section:$section, '
        'uuid:$uuid, '
        'allRevisedFlashCards:$allRevisedFlashCards';
  }
}
