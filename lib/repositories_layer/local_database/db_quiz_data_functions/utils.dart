import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/section_model.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_audio_example_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_flash_card_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_section_data.dart';

List<SingleQuizSectionData> getSectionKanjiQuizList(
  List<SectionModel> listSections,
  List<Map<String, Object?>> listKanjiQuizQuery,
) {
  return listSections.map((sectionData) {
    final list = listKanjiQuizQuery.where((element) {
      return element['section'] == sectionData.sectionNumber;
    }).toList();

    if (list.isNotEmpty) {
      final mapData = list[0];
      return SingleQuizSectionData(
        section: mapData['section'] as int,
        allCorrectAnswers: (mapData['allCorrectAnswersQuizKanji'] as int) == 1,
        isFinishedQuiz: (mapData['isFinishedKanjiQuiz'] as int) == 1,
        countCorrects: mapData['countCorrects'] as int,
        countIncorrect: mapData['countIncorrect'] as int,
        countOmitted: mapData['countOmitted'] as int,
      );
    } else {
      return SingleQuizSectionData(
        section: sectionData.sectionNumber,
        allCorrectAnswers: false,
        isFinishedQuiz: false,
        countCorrects: 0,
        countIncorrect: 0,
        countOmitted: 0,
      );
    }
  }).toList();
}

List<List<SingleAudioExampleQuizData>> getSectionAudioQuizList(
  List<SectionModel> listSections,
  List<Map<String, Object?>> listAudioQuizQuery,
  String uuid,
) {
  final listMap =
      List.generate(listSections.length, (index) => <Map<String, Object?>>[]);

  for (var section in listSections) {
    for (var kanjiCharacter in section.kanjisCharacters) {
      final mapDataList = listAudioQuizQuery
          .where((mapData) => mapData['kanjiCharacter'] == kanjiCharacter)
          .toList();
      if (mapDataList.isEmpty) {
        final myMap = {
          'kanjiCharacter': kanjiCharacter,
          'section': section.sectionNumber,
          'allCorrectAnswers': 0,
          'isFinishedQuiz': 0,
          'countCorrects': 0,
          'countIncorrect': 0,
          'countOmitted': 0,
        };
        listMap[section.sectionNumber - 1].add(myMap);
      } else {
        listMap[section.sectionNumber - 1].add(mapDataList[0]);
      }
    }
  }

  //logger.d('audio quiz data: $listMap');

  final listSingleQuizAudioExampleData = listMap.map(
    (sectionListData) {
      return sectionListData.map(
        (mapData) {
          return SingleAudioExampleQuizData(
            kanjiCharacter: mapData['kanjiCharacter'] as String,
            section: mapData['section'] as int,
            uuid: uuid,
            allCorrectAnswers: (mapData['allCorrectAnswers'] as int) == 1,
            isFinishedQuiz: (mapData['isFinishedQuiz'] as int) == 1,
            countCorrects: mapData['countCorrects'] as int,
            countIncorrect: mapData['countIncorrect'] as int,
            countOmitted: mapData['countOmitted'] as int,
          );
        },
      ).toList();
    },
  ).toList();

  //logger.d(listSingleQuizAudioExampleData);

  return listSingleQuizAudioExampleData;
}

List<List<SingleQuizFlashCardData>> getSectionFlashCardList(
  List<SectionModel> listSections,
  List<Map<String, Object?>> listFlahsCardQuery,
  String uuid,
) {
  final listMap =
      List.generate(listSections.length, (index) => <Map<String, Object?>>[]);

  for (var section in listSections) {
    for (var kanjiCharacter in section.kanjisCharacters) {
      final mapDataList = listFlahsCardQuery
          .where((mapData) => mapData['kanjiCharacter'] == kanjiCharacter)
          .toList();
      if (mapDataList.isEmpty) {
        final myMap = {
          'kanjiCharacter': kanjiCharacter,
          'section': section.sectionNumber,
          'allRevisedFlashCards': 0,
        };
        listMap[section.sectionNumber - 1].add(myMap);
      } else {
        listMap[section.sectionNumber - 1].add(mapDataList[0]);
      }
    }
  }

  return listMap.map(
    (sectionListData) {
      return sectionListData.map(
        (mapData) {
          return SingleQuizFlashCardData(
            kanjiCharacter: mapData['kanjiCharacter'] as String,
            section: mapData['section'] as int,
            uuid: uuid,
            allRevisedFlashCards: (mapData['allRevisedFlashCards'] as int) == 1,
          );
        },
      ).toList();
    },
  ).toList();
}

(List<bool>, List<bool>) getStatusAllQuizKanjis(
    List<SingleQuizSectionData> sectionKanjiQuizList) {
  List<bool> allKanjiQuizFinishedList = List.generate(
      sectionKanjiQuizList.length, (index) => false,
      growable: false);
  List<bool> allKanjiQuizCorrectList = List.generate(
      sectionKanjiQuizList.length, (index) => false,
      growable: false);

  for (int i = 0; i < sectionKanjiQuizList.length; i++) {
    var element = sectionKanjiQuizList[i];
    if (element.allCorrectAnswers) {
      allKanjiQuizCorrectList[i] = true;
    }
    if (element.isFinishedQuiz) {
      allKanjiQuizFinishedList[i] = true;
    }
  }

  return (
    allKanjiQuizFinishedList,
    allKanjiQuizCorrectList,
  );
}

(List<bool>, List<bool>) getStatusAllAudioQuiz(
    List<List<SingleAudioExampleQuizData>> sectionAudioQuizData) {
  List<bool> allAudioQuizFinishedList = List.generate(
      sectionAudioQuizData.length, (index) => true,
      growable: false);
  List<bool> allAudioQuizCorrectList = List.generate(
      sectionAudioQuizData.length, (index) => true,
      growable: false);

  for (int j = 0; j < sectionAudioQuizData.length; j++) {
    var element = sectionAudioQuizData[j];

    final allCorrectAnswers = element.where((element) {
      return element.allCorrectAnswers == false;
    }).length;

    if (allCorrectAnswers > 0) {
      allAudioQuizCorrectList[j] = false;
    }

    final allIsFinishedQuiz = element.where((element) {
      return element.isFinishedQuiz == false;
    }).length;

    if (allIsFinishedQuiz > 0) {
      allAudioQuizFinishedList[j] = false;
    }
  }
  //logger.d(allAudioQuizFinishedList);

  //logger.d(allAudioQuizCorrectList);

  return (
    allAudioQuizFinishedList,
    allAudioQuizCorrectList,
  );
}

List<bool> getAllFlashCardStatus(
    List<List<SingleQuizFlashCardData>> sectionFlashCardData) {
  List<bool> allRevisedFlashCards = List.generate(
    sectionFlashCardData.length,
    (index) => true,
    growable: false,
  );

  for (int k = 0; k < sectionFlashCardData.length; k++) {
    var element = sectionFlashCardData[k];
    final allRevisedFlashCardsFalse = element.where((element) {
      return element.allRevisedFlashCards == false;
    }).length;

    if (allRevisedFlashCardsFalse > 0) {
      allRevisedFlashCards[k] = false;
    }
  }
  return allRevisedFlashCards;
}

void printAudioData(Map<String, Object?> mapData) {
  logger.d(mapData['kanjiCharacter']);
  logger.d(mapData['section']);
  logger.d(mapData['allCorrectAnswers']);
  logger.d(mapData['isFinishedQuiz']);
  logger.d(mapData['countCorrects']);
  logger.d(mapData['countIncorrect']);
  logger.d(mapData['countOmitted']);
}
