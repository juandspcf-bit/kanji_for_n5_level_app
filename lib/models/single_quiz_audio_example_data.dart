import 'dart:convert';

class SingleAudioExampleQuizData {
  final String kanjiCharacter;
  final int section;
  final String uuid;
  final bool allCorrectAnswers;
  final bool isFinishedQuiz;
  final int countCorrects;
  final int countIncorrect;
  final int countOmitted;

  SingleAudioExampleQuizData({
    required this.kanjiCharacter,
    required this.section,
    required this.uuid,
    required this.allCorrectAnswers,
    required this.isFinishedQuiz,
    required this.countCorrects,
    required this.countIncorrect,
    required this.countOmitted,
  });

  SingleAudioExampleQuizData copyWith({
    String? kanjiCharacter,
    int? section,
    String? uuid,
    bool? allCorrectAnswers,
    bool? isFinishedQuiz,
    int? countCorrects,
    int? countIncorrect,
    int? countOmitted,
  }) {
    return SingleAudioExampleQuizData(
      kanjiCharacter: kanjiCharacter ?? this.kanjiCharacter,
      section: section ?? this.section,
      uuid: uuid ?? this.uuid,
      allCorrectAnswers: allCorrectAnswers ?? this.allCorrectAnswers,
      isFinishedQuiz: isFinishedQuiz ?? this.isFinishedQuiz,
      countCorrects: countCorrects ?? this.countCorrects,
      countIncorrect: countIncorrect ?? this.countIncorrect,
      countOmitted: countOmitted ?? this.countOmitted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kanjiCharacter': kanjiCharacter,
      'section': section,
      'uuid': uuid,
      'allCorrectAnswers': allCorrectAnswers,
      'isFinishedQuiz': isFinishedQuiz,
      'countCorrects': countCorrects,
      'countIncorrect': countIncorrect,
      'countOmitted': countOmitted,
    };
  }

  factory SingleAudioExampleQuizData.fromMap(Map<String, dynamic> map) {
    return SingleAudioExampleQuizData(
      kanjiCharacter: map['kanjiCharacter'] ?? '',
      section: map['section']?.toInt() ?? 0,
      uuid: map['uuid'] ?? '',
      allCorrectAnswers: map['allCorrectAnswers'] ?? false,
      isFinishedQuiz: map['isFinishedQuiz'] ?? false,
      countCorrects: map['countCorrects']?.toInt() ?? 0,
      countIncorrect: map['countIncorrect']?.toInt() ?? 0,
      countOmitted: map['countOmitted']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SingleAudioExampleQuizData.fromJson(String source) =>
      SingleAudioExampleQuizData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SingleAudioExampleQuizData(kanjiCharacter: $kanjiCharacter, section: $section, uuid: $uuid, allCorrectAnswers: $allCorrectAnswers, isFinishedQuiz: $isFinishedQuiz, countCorrects: $countCorrects, countIncorrect: $countIncorrect, countOmitted: $countOmitted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SingleAudioExampleQuizData &&
        other.kanjiCharacter == kanjiCharacter &&
        other.section == section &&
        other.uuid == uuid &&
        other.allCorrectAnswers == allCorrectAnswers &&
        other.isFinishedQuiz == isFinishedQuiz &&
        other.countCorrects == countCorrects &&
        other.countIncorrect == countIncorrect &&
        other.countOmitted == countOmitted;
  }

  @override
  int get hashCode {
    return kanjiCharacter.hashCode ^
        section.hashCode ^
        uuid.hashCode ^
        allCorrectAnswers.hashCode ^
        isFinishedQuiz.hashCode ^
        countCorrects.hashCode ^
        countIncorrect.hashCode ^
        countOmitted.hashCode;
  }
}
