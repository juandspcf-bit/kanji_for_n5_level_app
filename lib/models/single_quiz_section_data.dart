import 'dart:convert';

class SingleQuizSectionData {
  final int section;
  final bool allCorrectAnswers;
  final bool isFinishedQuiz;
  final int countCorrects;
  final int countIncorrects;
  final int countOmited;

  SingleQuizSectionData({
    required this.section,
    required this.allCorrectAnswers,
    required this.isFinishedQuiz,
    required this.countCorrects,
    required this.countIncorrects,
    required this.countOmited,
  });

  SingleQuizSectionData copyWith({
    int? section,
    bool? allCorrectAnswers,
    bool? isFinishedQuiz,
    int? countCorrects,
    int? countIncorrects,
    int? countOmited,
  }) {
    return SingleQuizSectionData(
      section: section ?? this.section,
      allCorrectAnswers: allCorrectAnswers ?? this.allCorrectAnswers,
      isFinishedQuiz: isFinishedQuiz ?? this.isFinishedQuiz,
      countCorrects: countCorrects ?? this.countCorrects,
      countIncorrects: countIncorrects ?? this.countIncorrects,
      countOmited: countOmited ?? this.countOmited,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'section': section,
      'allCorrectAnswers': allCorrectAnswers,
      'isFinishedQuiz': isFinishedQuiz,
      'countCorrects': countCorrects,
      'countIncorrects': countIncorrects,
      'countOmited': countOmited,
    };
  }

  factory SingleQuizSectionData.fromMap(Map<String, dynamic> map) {
    return SingleQuizSectionData(
      section: map['section']?.toInt() ?? 0,
      allCorrectAnswers: map['allCorrectAnswers'] ?? false,
      isFinishedQuiz: map['isFinishedQuiz'] ?? false,
      countCorrects: map['countCorrects']?.toInt() ?? 0,
      countIncorrects: map['countIncorrects']?.toInt() ?? 0,
      countOmited: map['countOmited']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SingleQuizSectionData.fromJson(String source) =>
      SingleQuizSectionData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SingleQuizSectionData(section: $section, allCorrectAnswers: $allCorrectAnswers, isFinishedQuiz: $isFinishedQuiz, countCorrects: $countCorrects, countIncorrects: $countIncorrects, countOmited: $countOmited)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SingleQuizSectionData &&
        other.section == section &&
        other.allCorrectAnswers == allCorrectAnswers &&
        other.isFinishedQuiz == isFinishedQuiz &&
        other.countCorrects == countCorrects &&
        other.countIncorrects == countIncorrects &&
        other.countOmited == countOmited;
  }

  @override
  int get hashCode {
    return section.hashCode ^
        allCorrectAnswers.hashCode ^
        isFinishedQuiz.hashCode ^
        countCorrects.hashCode ^
        countIncorrects.hashCode ^
        countOmited.hashCode;
  }
}
