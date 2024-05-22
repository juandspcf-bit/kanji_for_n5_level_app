import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:kanji_for_n5_level_app/models/single_quiz_audio_example_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_flash_card_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_section_data.dart';

class QuizSectionData {
  final SingleQuizSectionData singleQuizSectionData;
  final List<SingleQuizFlashCardData> singleQuizFlashCardData;
  final List<SingleAudioExampleQuizData> singleAudioExampleQuizData;

  QuizSectionData({
    required this.singleQuizSectionData,
    required this.singleQuizFlashCardData,
    required this.singleAudioExampleQuizData,
  });

  QuizSectionData copyWith({
    SingleQuizSectionData? singleQuizSectionData,
    List<SingleQuizFlashCardData>? singleQuizFlashCardData,
    List<SingleAudioExampleQuizData>? singleAudioExampleQuizData,
  }) {
    return QuizSectionData(
      singleQuizSectionData:
          singleQuizSectionData ?? this.singleQuizSectionData,
      singleQuizFlashCardData:
          singleQuizFlashCardData ?? this.singleQuizFlashCardData,
      singleAudioExampleQuizData:
          singleAudioExampleQuizData ?? this.singleAudioExampleQuizData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'singleQuizSectionData': singleQuizSectionData.toMap(),
      'singleQuizFlashCardData':
          singleQuizFlashCardData.map((x) => x.toMap()).toList(),
      'singleAudioExampleQuizData':
          singleAudioExampleQuizData.map((x) => x.toMap()).toList(),
    };
  }

  factory QuizSectionData.fromMap(Map<String, dynamic> map) {
    return QuizSectionData(
      singleQuizSectionData:
          SingleQuizSectionData.fromMap(map['singleQuizSectionData']),
      singleQuizFlashCardData: List<SingleQuizFlashCardData>.from(
          map['singleQuizFlashCardData']
              ?.map((x) => SingleQuizFlashCardData.fromMap(x))),
      singleAudioExampleQuizData: List<SingleAudioExampleQuizData>.from(
          map['singleAudioExampleQuizData']
              ?.map((x) => SingleAudioExampleQuizData.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory QuizSectionData.fromJson(String source) =>
      QuizSectionData.fromMap(json.decode(source));

  @override
  String toString() =>
      'QuizSectionData(singleQuizSectionData: $singleQuizSectionData, singleQuizFlashCardData: $singleQuizFlashCardData, singleAudioExampleQuizData: $singleAudioExampleQuizData)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuizSectionData &&
        other.singleQuizSectionData == singleQuizSectionData &&
        listEquals(other.singleQuizFlashCardData, singleQuizFlashCardData) &&
        listEquals(
            other.singleAudioExampleQuizData, singleAudioExampleQuizData);
  }

  @override
  int get hashCode =>
      singleQuizSectionData.hashCode ^
      singleQuizFlashCardData.hashCode ^
      singleAudioExampleQuizData.hashCode;
}
