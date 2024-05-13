import 'dart:convert';

class SingleQuizSectionData {
  final int section;
  final bool allCorrectAnswers;
  final bool isFinishedQuiz;
  final int countCorrects;
  final int countIncorrect;
  final int countOmitted;

  SingleQuizSectionData({
    required this.section,
    required this.allCorrectAnswers,
    required this.isFinishedQuiz,
    required this.countCorrects,
    required this.countIncorrect,
    required this.countOmitted,
  });

  SingleQuizSectionData copyWith({
    int? section,
    bool? allCorrectAnswers,
    bool? isFinishedQuiz,
    int? countCorrects,
    int? countIncorrect,
    int? countOmitted,
  }) {
    return SingleQuizSectionData(
      section: section ?? this.section,
      allCorrectAnswers: allCorrectAnswers ?? this.allCorrectAnswers,
      isFinishedQuiz: isFinishedQuiz ?? this.isFinishedQuiz,
      countCorrects: countCorrects ?? this.countCorrects,
      countIncorrect: countIncorrect ?? this.countIncorrect,
      countOmitted: countOmitted ?? this.countOmitted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'section': section,
      'allCorrectAnswers': allCorrectAnswers,
      'isFinishedQuiz': isFinishedQuiz,
      'countCorrects': countCorrects,
      'countIncorrect': countIncorrect,
      'countOmitted': countOmitted,
    };
  }

  factory SingleQuizSectionData.fromMap(Map<String, dynamic> map) {
    return SingleQuizSectionData(
      section: map['section']?.toInt() ?? 0,
      allCorrectAnswers: map['allCorrectAnswers'] ?? false,
      isFinishedQuiz: map['isFinishedQuiz'] ?? false,
      countCorrects: map['countCorrects']?.toInt() ?? 0,
      countIncorrect: map['countIncorrect']?.toInt() ?? 0,
      countOmitted: map['countOmitted']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SingleQuizSectionData.fromJson(String source) =>
      SingleQuizSectionData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SingleQuizSectionData(section: $section, allCorrectAnswers: $allCorrectAnswers, isFinishedQuiz: $isFinishedQuiz, countCorrects: $countCorrects, countIncorrect: $countIncorrect, countOmitted: $countOmitted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SingleQuizSectionData &&
        other.section == section &&
        other.allCorrectAnswers == allCorrectAnswers &&
        other.isFinishedQuiz == isFinishedQuiz &&
        other.countCorrects == countCorrects &&
        other.countIncorrect == countIncorrect &&
        other.countOmitted == countOmitted;
  }

  @override
  int get hashCode {
    return section.hashCode ^
        allCorrectAnswers.hashCode ^
        isFinishedQuiz.hashCode ^
        countCorrects.hashCode ^
        countIncorrect.hashCode ^
        countOmitted.hashCode;
  }
}
