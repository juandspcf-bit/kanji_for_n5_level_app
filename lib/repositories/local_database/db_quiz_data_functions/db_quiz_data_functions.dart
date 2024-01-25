import 'package:kanji_for_n5_level_app/aplication_layer/repository_contract/db_contract.dart';
import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_definitions.dart';
import 'package:kanji_for_n5_level_app/repositories/local_database/db_quiz_data_functions/utils.dart';

Future<SingleQuizSectionData> getSingleQuizSectionData(
  int section,
  String uuid,
) async {
  final db = await kanjiFromApiDatabase;
  final listQuery = await db.rawQuery(
      'SELECT * FROM kanji_quiz WHERE section = ? AND uuid = ?',
      [section, uuid]);

  if (listQuery.isEmpty) {
    return SingleQuizSectionData(
      section: -1,
      allCorrectAnswers: false,
      isFinishedQuiz: false,
      countCorrects: 0,
      countIncorrects: 0,
      countOmited: 0,
    );
  }

  return SingleQuizSectionData(
    section: listQuery[0]['section'] as int,
    allCorrectAnswers: (listQuery[0]['allCorrectAnswersQuizKanji'] as int) == 1,
    isFinishedQuiz: (listQuery[0]['isFinishedKanjiQuizz'] as int) == 1,
    countCorrects: listQuery[0]['countCorrects'] as int,
    countIncorrects: listQuery[0]['countIncorrects'] as int,
    countOmited: listQuery[0]['countOmited'] as int,
  );
}

Future<void> getAllQuizSectionData(
  String uuid,
) async {
  final db = await kanjiFromApiDatabase;
  final listKanjiQuizQuery = await db.rawQuery(
    'SELECT * FROM kanji_quiz '
    'WHERE'
    ' uuid = ? '
    'ORDER BY section',
    [uuid],
  );

  final sectionKanjiQuizList = getSectionKanjiQuizList(
    listSections,
    listKanjiQuizQuery,
  );

  //logger.d(sectionKanjiQuizList);
  List<bool> allKanjiQuizFinishedList;
  List<bool> allKanjiQuizCorrectList;

  (
    allKanjiQuizFinishedList,
    allKanjiQuizCorrectList,
  ) = getStatusAllQuizKanjis(sectionKanjiQuizList);

  logger.d(allKanjiQuizFinishedList);
  logger.d(allKanjiQuizCorrectList);

  final listAudioQuizQuery = await db.rawQuery(
      'SELECT * FROM kanji_audio_example_quiz '
      'WHERE'
      ' uuid = ? '
      'ORDER BY section',
      [uuid]);

  final sectionAudioQuizData = getSectionAudioQuizList(
    listSections,
    listAudioQuizQuery,
    uuid,
  );

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

  final listFlahsCardQuery = await db.rawQuery(
      'SELECT * FROM kanji_flashcard_quiz '
      'WHERE'
      ' uuid = ?',
      [uuid]);

  final sectionFlashCardData = getSectionFlashCardList(
    listSections,
    listFlahsCardQuery,
    uuid,
  );

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
}

void updateSingleQuizSectionData(
  int section,
  String uuid,
  bool allCorrectAnswersQuizKanji,
  bool isFinishedKanjiQuizz,
  int countCorrects,
  int countIncorrects,
  int countOmited,
) async {
  final db = await kanjiFromApiDatabase;
  await db.rawUpdate(
      'UPDATE kanji_quiz '
      'SET'
      ' allCorrectAnswersQuizKanji = ?,'
      ' isFinishedKanjiQuizz = ?,'
      ' countCorrects = ?,'
      ' countIncorrects = ?,'
      ' countOmited = ? '
      'WHERE section = ? AND uuid = ?',
      [
        allCorrectAnswersQuizKanji ? 1 : 0,
        isFinishedKanjiQuizz ? 1 : 0,
        countCorrects,
        countIncorrects,
        countOmited,
        section,
        uuid,
      ]);
}

void insertSingleQuizSectionDataDB(
  int section,
  String uuid,
  bool allCorrectAnswersQuizKanji,
  bool isFinishedKanjiQuizz,
  int countCorrects,
  int countIncorrects,
  int countOmited,
) async {
  final db = await kanjiFromApiDatabase;
  await db.rawInsert(
      'INSERT INTO kanji_quiz('
      ' allCorrectAnswersQuizKanji,'
      ' isFinishedKanjiQuizz,'
      ' countCorrects,'
      ' countIncorrects,'
      ' countOmited,'
      ' section,'
      ' uuid'
      ') '
      'VALUES(?,?,?,?,?,?,?)',
      [
        allCorrectAnswersQuizKanji ? 1 : 0,
        isFinishedKanjiQuizz ? 1 : 0,
        countCorrects,
        countIncorrects,
        countOmited,
        section,
        uuid
      ]);
}

Future<SingleQuizAudioExampleData> getSingleQuizSectionAudioExamplerData(
  String kanjiCharacter,
  int section,
  String uuid,
) async {
  final db = await kanjiFromApiDatabase;
  final listQuery = await db.rawQuery(
      'SELECT * FROM kanji_audio_example_quiz'
      ' WHERE kanjiCharacter = ? AND section = ? AND uuid = ?',
      [kanjiCharacter, section, uuid]);

  if (listQuery.isEmpty) {
    return SingleQuizAudioExampleData(
      kanjiCharacter: '',
      section: -1,
      uuid: '',
      allCorrectAnswers: false,
      isFinishedQuiz: false,
      countCorrects: 0,
      countIncorrects: 0,
      countOmited: 0,
    );
  }

  return SingleQuizAudioExampleData(
    kanjiCharacter: listQuery[0]['kanjiCharacter'] as String,
    section: listQuery[0]['section'] as int,
    uuid: listQuery[0]['uuid'] as String,
    allCorrectAnswers: (listQuery[0]['allCorrectAnswers'] as int) == 1,
    isFinishedQuiz: (listQuery[0]['isFinishedQuiz'] as int) == 1,
    countCorrects: listQuery[0]['countCorrects'] as int,
    countIncorrects: listQuery[0]['countIncorrects'] as int,
    countOmited: listQuery[0]['countOmited'] as int,
  );
}

Future<int> updateSingleAudioExampleQuizSectionData(
  String kanjiCharacter,
  int section,
  String uuid,
  bool allCorrectAnswers,
  bool isFinishedQuiz,
  int countCorrects,
  int countIncorrects,
  int countOmited,
) async {
  final db = await kanjiFromApiDatabase;
  logger.d('uuid: $uuid, allCorrectAnwers: $allCorrectAnswers,'
      ' isFinishedQuiz: $isFinishedQuiz, corrects: $countCorrects');
  return db.rawUpdate(
      'UPDATE'
      ' kanji_audio_example_quiz '
      'SET'
      ' allCorrectAnswers = ?,'
      ' isFinishedQuiz = ?,'
      ' countCorrects = ?,'
      ' countIncorrects = ?,'
      ' countOmited = ? '
      'WHERE'
      ' kanjiCharacter = ? AND section = ? AND uuid = ?',
      [
        allCorrectAnswers ? 1 : 0,
        isFinishedQuiz ? 1 : 0,
        countCorrects,
        countIncorrects,
        countOmited,
        kanjiCharacter,
        section,
        uuid
      ]);
}

Future<int> insertSingleAudioExampleQuizSectionDataDB(
  int section,
  String uuid,
  String kanjiCharacter,
  bool allCorrectAnswers,
  bool isFinishedQuiz,
  int countCorrects,
  int countIncorrects,
  int countOmited,
) async {
  logger.d('uuid: $uuid, corrects: $countCorrects,'
      ' countIncorrects: $countIncorrects, countOmited: $countOmited');
  final db = await kanjiFromApiDatabase;
  try {
    return await db.rawInsert(
        'INSERT INTO kanji_audio_example_quiz('
        ' kanjiCharacter,'
        ' allCorrectAnswers,'
        ' isFinishedQuiz,'
        ' countCorrects,'
        ' countIncorrects,'
        ' countOmited,'
        ' section,'
        ' uuid)'
        ' VALUES(?,?,?,?,?,?,?,?)',
        [
          kanjiCharacter,
          allCorrectAnswers ? 1 : 0,
          isFinishedQuiz ? 1 : 0,
          countCorrects,
          countIncorrects,
          countOmited,
          section,
          uuid
        ]);
  } catch (e) {
    logger.e(e);
    return Future(() => 0);
  }
}

Future<SingleQuizFlashCardData> getSingleFlashCardData(
  String kanjiCharacter,
  int section,
  String uuid,
) async {
  final db = await kanjiFromApiDatabase;
  final listQuery = await db.rawQuery(
      'SELECT * FROM kanji_flashcard_quiz '
      'WHERE'
      ' section = ? AND uuid = ?',
      [section, uuid]);
  logger.d('getttin flash card data out: $listQuery');

  if (listQuery.isEmpty) {
    return SingleQuizFlashCardData(
      kanjiCharacter: '',
      section: -1,
      uuid: '',
      allRevisedFlashCards: false,
    );
  }

  return SingleQuizFlashCardData(
    kanjiCharacter: listQuery[0]['kanjiCharacter'] as String,
    uuid: listQuery[0]['uuid'] as String,
    section: listQuery[0]['section'] as int,
    allRevisedFlashCards: (listQuery[0]['allRevisedFlashCards'] as int) == 1,
  );
}

Future<int> insertSingleFlashCardData(
  String kanjiCharacter,
  int section,
  String uuid,
  bool allRevisedFlashCards,
) async {
  logger.d('inserting: kanji: $kanjiCharacter, section:$section, uuid:$uuid,'
      ' revised?:$allRevisedFlashCards');
  final db = await kanjiFromApiDatabase;
  try {
    return await db.rawInsert(
        'INSERT INTO kanji_flashcard_quiz('
        ' kanjiCharacter,'
        ' section,'
        ' uuid,'
        ' allRevisedFlashCards'
        ')'
        ' VALUES(?,?,?,?)',
        [
          kanjiCharacter,
          section,
          uuid,
          allRevisedFlashCards ? 1 : 0,
        ]);
  } catch (e) {
    logger.e(e);
    return Future(() => 0);
  }
}

Future<int> updateSingleFlashCardData(
  String kanjiCharacter,
  int section,
  String uuid,
  bool allRevisedFlashCards,
) async {
  final db = await kanjiFromApiDatabase;
  //logger.d('uuid: $uuid, allCorrectAnwers: $allCorrectAnswers,'
  //    ' isFinishedQuiz: $isFinishedQuiz, corrects: $countCorrects');
  return await db.rawUpdate(
      'UPDATE'
      ' kanji_flashcard_quiz '
      'SET'
      ' allRevisedFlashCards = ?,'
      'WHERE'
      ' kanjiCharacter = ? AND section = ? AND uuid = ?',
      [
        allRevisedFlashCards ? 1 : 0,
        kanjiCharacter,
        section,
        uuid,
      ]);
}
