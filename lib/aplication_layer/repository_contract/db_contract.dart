import 'dart:convert';

import 'package:kanji_for_n5_level_app/models/kanji_from_api.dart';

abstract class LocalDBService {
  Future<KanjiFromApi?> storeKanjiToLocalDatabase(
    KanjiFromApi kanjiFromApi,
  );
  Future<void> deleteKanjiFromLocalDatabase(
    KanjiFromApi kanjiFromApi,
  );
  Future<void> deleteUserData(
    String uuid,
  );
  Future<SingleQuizSectionData> getKanjiQuizLastScore(
    int section,
    String uuid,
  );
  void setKanjiQuizLastScore({
    int section = -1,
    String uuid = '',
    int countCorrects = 0,
    int countIncorrects = 0,
    int countOmited = 0,
  });

  void insertSingleQuizSectionData(
    int section,
    String uuid,
    int countCorrects,
    int countIncorrects,
    int countOmited,
  );

  Future<SingleQuizAudioExampleData> getSingleAudioExampleQuizDataDB(
    String kanjiCharacter,
    int section,
    String uuid,
  );

  Future<int> setAudioExampleLastScore({
    String kanjiCharacter = '',
    int section = -1,
    String uuid = '',
    int countCorrects = 0,
    int countIncorrects = 0,
    int countOmited = 0,
  });

  Future<int> insertAudioExampleScore(
    int section,
    String uuid,
    String kanjiCharacter,
    int countCorrects,
    int countIncorrects,
    int countOmited,
  );

  Future<SingleQuizFlashCardData> getSingleFlashCardDataDB(
    String kanjiCharacter,
    int section,
    String uuid,
  );

  Future<int> insertSingleFlashCardDataDB(
    String kanjiCharacter,
    int section,
    String uuid,
    int countUnWatched,
  );

  Future<int> setSingleFlashCardDataDB(
    String kanjiCharacter,
    int section,
    String uuid,
    int countUnWatched,
  );
}

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
