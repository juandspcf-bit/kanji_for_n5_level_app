import 'package:flutter/material.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_section_data.dart';

(Color, Color, IconData) getColorsStatus(
  bool isFinishedKanjiQuizSection,
  bool isAllCorrectKanjiQuizSection,
  bool isFinishedAudioQuizSection,
  bool isAllCorrectAudioQuizSection,
  bool isFinishedFlashCardSection,
) {
  if (isFinishedKanjiQuizSection &&
      isAllCorrectKanjiQuizSection &&
      isFinishedAudioQuizSection &&
      isAllCorrectAudioQuizSection &&
      isFinishedFlashCardSection) {
    return (Colors.amberAccent, Colors.deepPurple, Icons.military_tech_rounded);
  } else if (isFinishedKanjiQuizSection &&
      isFinishedAudioQuizSection &&
      isFinishedFlashCardSection) {
    return (const Color.fromARGB(255, 101, 172, 207), Colors.white, Icons.done);
  } else {
    return (Colors.deepPurple, Colors.white, Icons.sentiment_dissatisfied);
  }
}

double getCountKanjiQuiz(SingleQuizSectionData data) {
  if (data.countCorrects == 0 &&
      data.countIncorrect == 0 &&
      data.countOmitted == 0) return 0;
  return ((data.countCorrects /
              (data.countCorrects + data.countIncorrect + data.countOmitted)) *
          100)
      .floorToDouble();
}
