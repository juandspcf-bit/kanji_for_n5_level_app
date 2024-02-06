import 'package:kanji_for_n5_level_app/main.dart';
import 'package:kanji_for_n5_level_app/models/progress_time_line_d_b_data.dart';
import 'package:kanji_for_n5_level_app/models/secction_model.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_audio_example_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_flash_card_data.dart';
import 'package:kanji_for_n5_level_app/models/single_quiz_section_data.dart';
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

Future<ProgressTimeLineDBData> getAllQuizSectionData(
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

  var (
    allKanjiQuizFinishedStatusList,
    allKanjiQuizCorrectStatusList,
  ) = getStatusAllQuizKanjis(sectionKanjiQuizList);

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

  var (
    allAudioQuizFinishedStatusList,
    allAudioQuizCorrectStatusList,
  ) = getStatusAllAudioQuiz(sectionAudioQuizData);

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

  List<bool> allRevisedFlashCardsStatusList =
      getAllFlashCardStatus(sectionFlashCardData);

/*   logger.d(allKanjiQuizFinishedStatusList);
  logger.d(allKanjiQuizCorrectStatusList);
  logger.d(allAudioQuizFinishedStatusList);
  logger.d(allAudioQuizCorrectStatusList);
  logger.d(allRevisedFlashCardsStatusList); */

  return ProgressTimeLineDBData(
    allKanjiQuizFinishedStatusList: allKanjiQuizFinishedStatusList,
    allKanjiQuizCorrectStatusList: allKanjiQuizCorrectStatusList,
    allAudioQuizFinishedStatusList: allAudioQuizFinishedStatusList,
    allAudioQuizCorrectStatusList: allAudioQuizCorrectStatusList,
    allRevisedFlashCardsStatusList: allRevisedFlashCardsStatusList,
  );
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
    ],
  );
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

Future<void> storeQuizScore(
    Map<String, Object> quizScoreData, String uuid) async {
  logger.d(quizScoreData);
  final sections = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

  for (String section in sections) {
    final quizScore =
        quizScoreData['quizScore_$section'] as Map<String, Object>;
    if (quizScore['isFinishedKanjiQuiz'] != null) {
      insertSingleQuizSectionDataDB(
        int.parse(section),
        uuid,
        quizScore['allCorrectAnswersQuizKanji'] as bool,
        quizScore['isFinishedKanjiQuiz'] as bool,
        quizScore['countCorrects'] as int,
        quizScore['countIncorrects'] as int,
        quizScore['countOmited'] as int,
      );
    }
  }
}
