import 'dart:convert';

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

  SingleQuizFlashCardData copyWith({
    String? kanjiCharacter,
    int? section,
    String? uuid,
    bool? allRevisedFlashCards,
  }) {
    return SingleQuizFlashCardData(
      kanjiCharacter: kanjiCharacter ?? this.kanjiCharacter,
      section: section ?? this.section,
      uuid: uuid ?? this.uuid,
      allRevisedFlashCards: allRevisedFlashCards ?? this.allRevisedFlashCards,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kanjiCharacter': kanjiCharacter,
      'section': section,
      'uuid': uuid,
      'allRevisedFlashCards': allRevisedFlashCards,
    };
  }

  factory SingleQuizFlashCardData.fromMap(Map<String, dynamic> map) {
    return SingleQuizFlashCardData(
      kanjiCharacter: map['kanjiCharacter'] ?? '',
      section: map['section']?.toInt() ?? 0,
      uuid: map['uuid'] ?? '',
      allRevisedFlashCards: map['allRevisedFlashCards'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SingleQuizFlashCardData.fromJson(String source) =>
      SingleQuizFlashCardData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SingleQuizFlashCardData(kanjiCharacter: $kanjiCharacter, section: $section, uuid: $uuid, allRevisedFlashCards: $allRevisedFlashCards)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SingleQuizFlashCardData &&
        other.kanjiCharacter == kanjiCharacter &&
        other.section == section &&
        other.uuid == uuid &&
        other.allRevisedFlashCards == allRevisedFlashCards;
  }

  @override
  int get hashCode {
    return kanjiCharacter.hashCode ^
        section.hashCode ^
        uuid.hashCode ^
        allRevisedFlashCards.hashCode;
  }
}
