import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/db_contract.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';

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
        isFinishedQuiz: (mapData['isFinishedKanjiQuizz'] as int) == 1,
        countCorrects: mapData['countCorrects'] as int,
        countIncorrects: mapData['countIncorrects'] as int,
        countOmited: mapData['countOmited'] as int,
      );
    } else {
      return SingleQuizSectionData(
        section: sectionData.sectionNumber,
        allCorrectAnswers: false,
        isFinishedQuiz: false,
        countCorrects: 0,
        countIncorrects: 0,
        countOmited: 0,
      );
    }
  }).toList();
}

List<List<SingleQuizAudioExampleData>> getSectionAudioQuizList(
  List<SectionModel> listSections,
  List<Map<String, Object?>> listAudioQuizQuery,
  String uuid,
) {
  return listSections
      .map(
        (sectionData) {
          return listAudioQuizQuery.where(
            (element) {
              return element['section'] == sectionData.sectionNumber;
            },
          ).toList();
        },
      )
      .toList()
      .map(
        (sectionListData) {
          return sectionListData.map(
            (mapData) {
              return SingleQuizAudioExampleData(
                kanjiCharacter: mapData['kanjiCharacter'] as String,
                section: mapData['section'] as int,
                uuid: uuid,
                allCorrectAnswers: (mapData['allCorrectAnswers'] as int) == 1,
                isFinishedQuiz: (mapData['isFinishedQuiz'] as int) == 1,
                countCorrects: mapData['countCorrects'] as int,
                countIncorrects: mapData['countIncorrects'] as int,
                countOmited: mapData['countOmited'] as int,
              );
            },
          ).toList();
        },
      )
      .toList();
}

List<List<SingleQuizFlashCardData>> getSectionFlashCardList(
  List<SectionModel> listSections,
  List<Map<String, Object?>> listFlahsCardQuery,
  String uuid,
) {
  return listSections
      .map(
        (sectionData) {
          return listFlahsCardQuery.where(
            (element) {
              return element['section'] == sectionData.sectionNumber;
            },
          ).toList();
        },
      )
      .toList()
      .map(
        (sectionListData) {
          return sectionListData.map(
            (mapData) {
              return SingleQuizFlashCardData(
                kanjiCharacter: mapData['kanjiCharacter'] as String,
                section: mapData['section'] as int,
                uuid: uuid,
                allRevisedFlashCards:
                    (mapData['allRevisedFlashCards'] as int) == 1,
              );
            },
          ).toList();
        },
      )
      .toList();
}

(List<bool>, List<bool>) getStatusAllQuizKanjis(sectionKanjiQuizList) {
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
